ARG JITSI_REPO=localhost:5000
FROM ${JITSI_REPO}/base

RUN \ 
	rm -rf /usr/local/src/* && \
	apt-dpkg-wrap apt-get remove -y maven && \
	cd /usr/local/src/ && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install wget && \
	wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz && \
	tar -xf apache-maven-3.5.4-bin.tar.gz && \
	mv apache-maven-3.5.4/ apache-maven/

ENV M2_HOME /usr/local/src/apache-maven
ENV MAVEN_HOME /usr/local/src/apache-maven
ENV PATH ${M2_HOME}/bin:${PATH}

RUN \
	echo '=========== mvn version ===============' && \
	mvn --version

RUN \
	cd ~/worksapce && \
	git clone https://github.com/devsupport2/jvb.git && \
	cd jvb && \
	./resources/build.sh

RUN \
	cd ~/worksapce/jvb/ && \
	dpkg-buildpackage -A -rfakeroot -us -uc

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt install ~/worksapce/jitsi-videobridge2*.deb && \
	apt-dpkg-wrap apt-get install -y jq curl iproute2 && \
	apt-cleanup

COPY rootfs/ /

VOLUME /config
