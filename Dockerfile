FROM ubuntu:latest

RUN apt update
RUN apt upgrade -y
RUN apt install -y iputils-ping
RUN apt install -y telnet

WORKDIR /usr/app/src

COPY restarter.sh ./
RUN chmod +x restarter.sh

CMD /bin/bash ./restarter.sh
