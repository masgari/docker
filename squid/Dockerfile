FROM masgari/base
MAINTAINER Mammad Asgari <mammad.asgari@gmail.com>

# Install squid
RUN apt-get update && apt-get install -y squid

ADD startup-scripts/start.sh startup-scripts/

# Local network access
RUN sed -i  -e 's/http_access deny all/http_access allow all/g' /etc/squid3/squid.conf \
    && chmod +x /startup-scripts/start.sh

EXPOSE 3128

CMD ["/startup-scripts/start.sh"]
