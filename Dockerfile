#Copyright (c) 2018 
FROM ubuntu:16.04

#Docker image info and maintainer
LABEL version="1.0"


#install prerequisite and geth
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y build-essential git
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get update
RUN apt-get install -y golang-go
RUN git clone https://github.com/ethereum/go-ethereum
WORKDIR /go-ethereum
RUN make geth
RUN ln -sf /go-ethereum/build/bin/geth /bin/geth

#Install bash
RUN apt-get update && apt-get install bash

#Add a user
RUN adduser --disabled-login --gecos "" rio_user
COPY rbt_common /home/rio_user/rbt_common
RUN chown -R rio_user:rio_user /home/rio_user/rbt_common
RUN chmod 777 -Rf /home/rio_user/rbt_common
USER rio_user

#Set up the working directroy
WORKDIR /home/rio_user

# Store the data here
RUN mkdir /home/rio_user/block-data

# Build arguments whose values are given to env variables to configure the docker images from one node to another
ARG identity_arg
ARG rpcport_arg
ENV identity_env $identity_arg
ENV rpcport_env $rpcport_arg

#Run
EXPOSE 22 8088 50070 8545
#ENTRYPOINT /bin/bash
ENTRYPOINT /home/rio_user/rbt_common/startNode



