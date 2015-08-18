#!/bin/sh

set -e
usermod --uid $UID minecraft
chown -R minecraft /data /start-server

#download server files
cd "$(dirname "$0")"
MCVER="1.7.10"
JARFILE="minecraft_server.${MCVER}.jar"
LAUNCHWRAPPER="net/minecraft/launchwrapper/1.11/launchwrapper-1.11.jar"
which wget
if [ $? -eq 0 ]; then
        wget -O ${JARFILE} https://s3.amazonaws.com/Minecraft.Download/versions/${MCVER}/${JARFILE}
        wget -O libraries/${LAUNCHWRAPPER} https://libraries.minecraft.net/${LAUNCHWRAPPER}
else
        which curl
        if [ $? -eq 0 ]; then
                curl -o ${JARFILE} https://s3.amazonaws.com/Minecraft.Download/versions/${MCVER}/minecraft_server.${MCVER}.jar
        		curl -o libraries/${LAUNCHWRAPPER} https://libraries.minecraft.net/${LAUNCHWRAPPER}
        else
                echo "Neither wget or curl were found on your system. Please install one and try again"
        fi
fi

#edit server.properties
if [ ! -e server.properties ]; then
  cp /tmp/server.properties .

  if [ -n "$MOTD" ]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
  fi

  if [ -n "$LEVEL" ]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
  fi

  if [ -n "$SEED" ]; then
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /data/server.properties
  fi

  if [ -n "$PVP" ]; then
    sed -i "/pvp\s*=/ c pvp=$PVP" /data/server.properties
  fi

  if [ -n "$DIFFICULTY" ]; then
    case $DIFFICULTY in
      peaceful)
        DIFFICULTY=0
        ;;
      easy)
        DIFFICULTY=1
        ;;
      normal)
        DIFFICULTY=2
        ;;
      hard)
        DIFFICULTY=3
        ;;
      *)
        echo "DIFFICULTY must be peaceful, easy, normal, or hard."
        exit 1
        ;;
    esac
    sed -i "/difficulty\s*=/ c difficulty=$DIFFICULTY" /data/server.properties
  fi

  if [ -n "$MODE" ]; then
    case ${MODE,,?} in
      0|1|2|3)
        ;;
      s*)
        MODE=0
        ;;
      c*)
        MODE=1
        ;;
      *)
        echo "ERROR: Invalid game mode: $MODE"
        exit 1
        ;;
    esac

    sed -i "/gamemode\s*=/ c gamemode=$MODE" /data/server.properties
  fi
fi

exec sudo -E -u minecraft /start-server
