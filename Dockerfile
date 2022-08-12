FROM ubuntu:latest

RUN apt update
RUN apt upgrade -y

WORKDIR /usr/app/src

COPY restarter.sh ./
RUN chmod +x restarter.sh

CMD /bin/bash ./restarter.sh