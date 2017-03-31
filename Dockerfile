FROM ubuntu:14.04

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF-8

RUN apt-get update
RUN apt-get -y -q install software-properties-common
RUN apt-get -y -q install fonts-ipafont-gothic fonts-ipafont-mincho

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-add-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get -y -q install oracle-java8-installer

RUN apt-get update
RUN apt-get -y -q install python python-pip
RUN pip install xmljson
