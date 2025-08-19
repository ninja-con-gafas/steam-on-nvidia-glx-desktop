FROM ghcr.io/selkies-project/nvidia-glx-desktop:24.04-20250629090948
LABEL maintainer="ninja-con-gafas <el.ninja.con.gafas@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN add-apt-repository multiverse && \
    apt-get update && \
    apt-get install -y steam && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/ubuntu/.steam/ && \
    chown -R ubuntu:ubuntu /home/ubuntu/.steam/

USER 1000
