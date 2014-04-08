FROM dockerfile/java
MAINTAINER Mammad Asgari <mammad.asgari@gmail.com>

# Install Java
RUN apt-get update
RUN apt-get -y install openssh-server 

EXPOSE 22

# Install ElasticSearch with head plugin.
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.0.tar.gz \
    && tar xzf elasticsearch-1.1.0.tar.gz \
    && mv elasticsearch-1.1.0 /opt/elasticsearch \
    && rm elasticsearch-1.1.0.tar.gz 
    && cd /opt/elasticsearch \
    && bin/plugin -install mobz/elasticsearch-head
 
# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
 
RUN mkdir -p /var/run/sshd && echo "root:r" | chpasswd

# Add startup script to start elasticsearch and ssh daemon
ADD scripts/start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

CMD ["/scripts/start.sh"]
 
