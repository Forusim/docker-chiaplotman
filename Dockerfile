FROM ubuntu:focal

ARG BRANCH="latest"                                                      
ARG DEBIAN_FRONTEND="noninteractive"
COPY dpkg_excludes /etc/dpkg/dpkg.cfg.d/excludes 

RUN apt-get update \
 && apt-get --no-install-recommends -y install git lsb-release sudo git nano rsync

RUN git clone https://github.com/Chia-Network/chia-blockchain.git --branch ${BRANCH} --recurse-submodules \
 && cd chia-blockchain \
 && chmod +x install.sh && ./install.sh

RUN . ./activate && chia init

RUN pip install git+https://github.com/ericaltendorf/plotman@main

WORKDIR /chia-blockchain/venv/bin  
VOLUME /config

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
