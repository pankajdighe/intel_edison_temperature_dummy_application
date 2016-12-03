# Gets latest base image from https://registry.hub.docker.com/u/resin/edison-node/
FROM resin/edison-node:latest


RUN apt-get -q update \
	&& apt-get -qy install \
 		wget \
		python python-dev python-pip python-virtualenv \
		build-essential  \
		curl \
        	git 

RUN pip install paho-mqtt

#RUN sudo pip install mraa		
RUN echo "src mraa-upm http://iotdk.intel.com/repos/1.1/intelgalactic" > /etc/opkg/mraa-upm.conf
RUN opkg update
RUN opkg install libmraa0

WORKDIR /usr/src/app

COPY app/ /usr/src/app
CMD ["python", "/usr/src/app/main.py"]
