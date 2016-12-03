# Gets latest base image from https://registry.hub.docker.com/u/resin/edison-node/
#FROM resin/edison-node:latest
#FROM resin/edison-python:latest


#RUN apt-get -q update \
#	&& apt-get -qy install \
 #		wget \
#		python python-dev python-pip python-virtualenv \
#		build-essential  \
#		curl \
 #       	git 


#RUN pip install --upgrade pip

#RUN pip install paho-mqtt

#RUN sudo pip install mraa		


#WORKDIR /usr/src/app

#COPY app/ /usr/src/app
#CMD ["python", "/usr/src/app/main.py"]



FROM resin/i386-debian:jessie

LABEL io.resin.device-type="edison"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		module-init-tools \
		nano \
		net-tools \		
		i2c-tools \
		iputils-ping \		
		ifupdown \	
		python python-dev python-pip python-virtualenv \	
		build-essential  \		
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*

# MRAA
ENV MRAA_COMMIT d336e9f8d69a85b6ed1aeb5b324910234031d4a8
ENV MRAA_VERSION 1.1.1
# UPM
ENV UPM_COMMIT 1849e22154177096f1725e9cc96ec62ac2ef3635
ENV UPM_VERSION 0.7.2

# Install mraa
RUN set -x \
	&& buildDeps=' \
		build-essential \
		git-core \
		libpcre3-dev \
		python-dev \
		swig \
		pkg-config \
		curl \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& mkdir /cmake \ 
	&& curl -SL https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz -o cmake.tar.gz \
	&& echo "92d8410d3d981bb881dfff2aed466da55a58d34c7390d50449aa59b32bb5e62a  cmake.tar.gz" | sha256sum -c - \
	&& tar -xzf cmake.tar.gz -C /cmake --strip-components=1 \
	&& cd /cmake \
	&& ./configure \
	&& make -j $(nproc) \
	&& make install \
	&& cd / \
	&& git clone https://github.com/intel-iot-devkit/mraa.git \
	&& cd /mraa \
	&& git checkout $MRAA_COMMIT \
	&& mkdir build && cd build \
	&& cmake .. -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr \
	&& make -j $(nproc) \
	&& make install \
	&& cd / \
	&& git clone https://github.com/intel-iot-devkit/upm.git \
	&& cd /upm \
	&& mkdir build && cd build \
	&& cmake .. -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr \
	&& make -j $(nproc) \
	&& make install \
	&& cd /cmake \
	&& make uninstall \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& cd / && rm -rf mraa upm cmake


# Update Shared Library Cache
RUN echo "/usr/local/lib/i386-linux-gnu/" >> /etc/ld.so.conf \
	&& ldconfig

WORKDIR /usr/src/app

COPY app/ /usr/src/app
CMD ["python", "/usr/src/app/main.py"]
