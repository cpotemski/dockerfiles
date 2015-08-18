## Description
A docker container that automatically loads FTB Infinity and starts up the Server

## How to use (Example)
docker run -d --name mc -p 25565:25565\
       -e EULA=TRUE \
       -e JVM_OPTS='-Xmx2G -Xms2G -Xincgc' \
       -v /root/docker/data/mc/:/data \
       dasarma/minecraft-ftb
