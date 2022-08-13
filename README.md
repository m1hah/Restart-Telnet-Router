# Restart Telnet (Router)
Restart any telnet-capable router when the network is down.
Forked: https://github.com/herrberk/router-resetter

Build your docker image with commands below.

1. 
```
git clone https://github.com/m1hah/Restart-Telnet-Router.git
```
2.
```
cd Restart-Telnet-Router
```
3.
Edit your credentials and ip.
Nano into the code and search for:
  eval "{ sleep 2; echo '####'; sleep 3; echo '####'; sleep 3; echo 'reboot'; sleep 5; }" | telnet ####

Change to:
  eval "{ sleep 2; echo 'telnetusername'; sleep 3; echo 'telnetpassword'; sleep 3; echo 'reboot'; sleep 5; }" | telnet telnetip
```
nano restarter.sh
```
4.
Build an image and run it as daemon.
```
sudo docker build -t [imagename] .
sudo docker run --name [name] -d [imagename]
```
5. 
You can exec into the docker and check your logs.
```
sudo docker exec -it [name] /bin/bash
cat running.log
```
