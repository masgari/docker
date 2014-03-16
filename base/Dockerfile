FROM ubuntu:precise
MAINTAINER Mamad Asgari <mammad.asgari@gmail.com>

# non interactive apt
ENV DEBIAN_FRONTEND noninteractive

# gb sources
RUN echo "deb http://gb.archive.ubuntu.com/ubuntu/ precise main universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://gb.archive.ubuntu.com/ubuntu/ precise-updates main universe multiverse" >> /etc/apt/sources.list 

RUN apt-mark hold initscripts udev plymouth mountall \
 && dpkg-divert --local --rename --add /sbin/initctl \
 && ln -sf /bin/true /sbin/initctl \
 && dpkg-divert --local --rename /usr/bin/ischroot \
 && ln -sf /bin/true /usr/bin/ischroot \
 && echo "exit 101" > /usr/sbin/policy-rc.d \
 && chmod +x /usr/sbin/policy-rc.d \
 && echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
 && echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache \
 && echo "APT {Install-Recommends="false";Install-Suggests="false";};" > /etc/apt/apt.conf.d/no-recommends

RUN echo "apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*" > /usr/local/bin/apt-cleanup \
 && chmod +x /usr/local/bin/apt-cleanup

# upgrade
RUN apt-get -q -y update && apt-get -q -y upgrade

#    && cd /tmp && ln -s /bin/true date && PATH=./:$PATH apt-get -q -y --force-yes install base-files && rm /tmp/date \
#    && apt-get -q -y upgrade

RUN apt-get -q -y install software-properties-common python-software-properties unzip bzip2 wget curl lsb-release openssh-server language-pack-en \
 && echo "Europe/London" > /etc/timezone \
 && dpkg-reconfigure -f noninteractive tzdata \
 && apt-cleanup && rm -fr /tmp/*

ENV LC_ALL en_GB.UTF8

RUN mkdir -p /var/run/sshd && \
    echo "root:r" | chpasswd

CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 22
