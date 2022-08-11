FROM ubuntu:latest

RUN apt update
RUN apt upgrade -y
RUN apt install python3 -y
RUN pip install pythonping

WORKDIR /usr/app/src

COPY run.py ./

CMD [ "python3", "./run.py" ]
