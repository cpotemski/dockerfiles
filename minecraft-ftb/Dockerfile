FROM itzg/ubuntu-openjdk-7

MAINTAINER dasarma

ENV APT_GET_UPDATE 2015-03-28
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libmozjs-24-bin imagemagick && apt-get clean
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

RUN useradd -M -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && chown minecraft:minecraft /data

ADD http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinity/1_10_1/FTBInfinityServer.zip /data/infinity.zip
RUN apt-get install zip -y && cd /data && unzip infinity.zip && rm infinity.zip

EXPOSE 25565

COPY install.sh /install
COPY start-server.sh /start-server

VOLUME ["/data"]
COPY server.properties /tmp/server.properties
WORKDIR /data
RUN ["chown", "-R", "minecraft:minecraft", "."]

CMD ["/bin/bash","-c","chmod +x /install"]

ENV UID=1000
ENV MOTD Have fun :)
ENV JVM_OPTS -Xmx2G -Xms2G -Xincgc
ENV LEVEL=Nodedev PVP=true DIFFICULTY=easy
