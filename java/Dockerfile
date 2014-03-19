#gb sources
FROM masgari/base

ENV DEBIAN_FRONTEND noninteractive

# Install Java
RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java7-installer

RUN apt-cleanup && rm -rf /var/tmp/*
