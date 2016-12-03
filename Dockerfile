# Gets latest base image from https://registry.hub.docker.com/u/resin/edison-node/
#FROM resin/edison-node:latest
FROM resin/edison-python:latest


RUN apt-get -q update \
	&& apt-get -qy install \
 		wget \
		python python-dev python-pip python-virtualenv \
		build-essential  \
		curl \
        	git 

RUN pip install paho-mqtt

#RUN sudo pip install mraa		


WORKDIR /usr/src/app

COPY app/ /usr/src/app
CMD ["python", "/usr/src/app/main.py"]
