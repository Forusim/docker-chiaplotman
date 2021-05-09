FROM ubuntu:latest

ARG BRANCH="latest"                                                      
   
ARG DEBIAN_FRONTEND="noninteractive"
COPY dpkg_excludes /etc/dpkg/dpkg.cfg.d/excludes 

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl wget jq tar unzip ca-certificates git openssl lsb-release sudo python3 python3-pip python3-dev python3.8-venv python3.8-distutils python-is-python3

RUN git clone --branch ${BRANCH} https://github.com/Chia-Network/chia-blockchain.git \
 && cd chia-blockchain \
 && git submodule update --init mozilla-ca \
 && chmod +x install.sh \
 && ./install.sh        

RUN pip3 install git+https://github.com/ericaltendorf/plotman@main

WORKDIR /chia-blockchain/venv/bin  
VOLUME /config

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
