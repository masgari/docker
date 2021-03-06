# To boot a fancy LXC container with upstart we need some extra stuff:
#
# - enable all repositories
# - Re configure some packages
# - Disable some services at boot
# - Configure locales
# - adding a cleanup/startup job which does a lot of magic
#    see ./lxc-setup.conf & ./lxc-cleanup.sh & ./lxc-stop.conf
#
# Useful links:
# http://linux-vserver.org/Upstart_issues
# http://upstart.ubuntu.com/wiki/Debugging
#
FROM ubuntu:latest
MAINTAINER Mathieu Le Marec Pasquet <kiorky@cryptelium.net>
ENV DEBIAN_FRONTEND noninteractive
#
# resolvconf & fuse need some love to run in a container
# mitigate half configured packages by installing them separatly
#
RUN rm -f /etc/init/resolvconf.conf
#ADD ntp_postinst /root/ntp_postinst
# cleanup on (re)start / setup console / maintain services
#ADD lxc-cleanup.sh /sbin/lxc-cleanup.sh
RUN FROZEN_PACKAGES=$(grep FROZEN_PACKAGES= /sbin/lxc-cleanup.sh | awk -F'"' '{print $2}'|sed -re 's/"//g') &&\
    echo "lxc" > /run/container_type &&\
    sed -re 's/ main$/ main restricted universe multiverse/g' -e "s:/archive\.:/fr.archive\.:g" -i /etc/apt/sources.list &&\
    echo "$FROZEN_PACKAGES on hold" &&\
    for i in $FROZEN_PACKAGES;do\
      echo $i hold | dpkg --set-selections;\
    done&&\
    grep "deb " /etc/apt/sources.list|sed -re "s/^deb /deb-src /g" >> /etc/apt/sources.list &&\
    apt-get -q update && apt-get upgrade -y --force-yes &&\
    apt-get install -y --force-yes libfuse2 apt-utils &&\
    if [ ! -e "/root/debbuild" ];then mkdir -pv /root/debbuild;fi &&\
    mv /root/ntp_postinst /root/debbuild &&\
    cd /root/debbuild;\
    nf=/etc/network/interfaces;
    for i in resolvconf fuse ntp;do \
      mkdir -p $i && cd $i &&\
      apt-get download -y $i &&\
      dpkg-deb -X $i*deb build &&\
      dpkg-deb -e $i*deb build/DEBIAN && \
      rm *deb && cd ..;done &&\
    cp /root/debbuild/ntp_postinst /root/debbuild/ntp/build/DEBIAN/postinst &&\
    echo "#!/bin/bash"   >/root/debbuild/resolvconf/build/DEBIAN/postinst &&\
    echo "exit 0"       >>/root/debbuild/resolvconf/build/DEBIAN/postinst &&\
    echo ""             >>/root/debbuild/resolvconf/build/DEBIAN/postinst &&\
    echo "#!/bin/bash"   >/root/debbuild/fuse/build/DEBIAN/postinst &&\
    echo "#exit 0"      >>/root/debbuild/fuse/build/DEBIAN/postinst &&\
    echo ""             >>/root/debbuild/fuse/build/DEBIAN/postinst &&\
    for i in fuse resolvconf ntp;do\
      cd /root/debbuild/$i/build&&\
      dpkg-deb -b . /root/debbuild/$i.deb;\
    done&&\
    apt-get install -y $(dpkg-deb -I /root/debbuild/ntp.deb |egrep "^\s*Depends:"|sed -re "s/\([^\)]+\)//g" -e "s/,//g" -e "s/Depends://g") &&\
    for i in fuse resolvconf ntp;do\
      dpkg -i /root/debbuild/$i.deb&&\
      echo $i hold | dpkg --set-selections;\
    done&&\
    apt-get -fy install &&\
    apt-get install -y --force-yes apport;\
    apt-get install -y --force-yes acpid;\
    apt-get install -y --force-yes cron;\
    apt-get install -y --force-yes dialog;\
    apt-get install -y --force-yes git-core;\
    apt-get install -y --force-yes language-pack-en;\
    apt-get install -y --force-yes language-pack-fr;\
    apt-get install -y --force-yes locales;\
    apt-get install -y --force-yes logrotate;\
    apt-get install -y --force-yes man;\
    apt-get install -y --force-yes man-db;\
    apt-get install -y --force-yes libopts25;\
    apt-get install -y --force-yes manpages;\
    apt-get install -y --force-yes manpages-de;\
    apt-get install -y --force-yes manpages-fr;\
    apt-get install -y --force-yes net-tools;\
    apt-get install -y --force-yes openssh-server;\
    apt-get install -y --force-yes python-software-properties;\
    apt-get install -y --force-yes rsyslog;\
    apt-get install -y --force-yes screen;\
    apt-get install -y --force-yes snmpd;\
    apt-get install -y --force-yes ssh;\
    apt-get install -y --force-yes sudo;\
    apt-get install -y --force-yes tmux;\
    apt-get install -y --force-yes tree;\
    apt-get install -y --force-yes tzdata;\
    apt-get install -y --force-yes ubuntu-minimal;\
    apt-get install -y --force-yes ubuntu-standard;\
    apt-get install -y --force-yes vim;\
    rm -rf /var/cache/apt/archives/*deb;
# Move those service away and make sure even if an upgrade spawn again
# the servvice file to mark it as-no-starting
# cleanup on (re)start / setup console / maintain services
ADD lxc-setup.conf /etc/init/lxc-setup.conf
ADD lxc-stop.conf /etc/init/lxc-stop.conf

RUN cd /;\
    for i in openssh-server cron logrotate;do dpkg-reconfigure --force $i;done;\
    for i in /lib/init/fstab /etc/fstab;do echo > $i;done;\
    /usr/sbin/update-rc.d -f ondemand remove;\
    useradd --create-home -s /bin/bash ubuntu;\
    sudo_version=$(dpkg-query -W -f='${Version}' sudo);\
    if dpkg --compare-versions $sudo_version gt "1.8.3p1-1"; then\
        groups="sudo";\
    else\
        groups="sudo admin";\
    fi;\
    for group in $groups;do\
        groupadd --system $group >/dev/null 2>&1 || true;\
        adduser ubuntu $group >/dev/null 2>&1 || true;\
    done;\
    echo "ubuntu:ubuntu" | chpasswd;\
    echo>/etc/locale.gen;\
    echo "en_US.UTF-8 UTF-8">>/etc/locale.gen;\
    echo "en_US ISO-8859-1">>/etc/locale.gen;\
    echo "de_DE.UTF-8 UTF-8">>/etc/locale.gen;\
    echo "de_DE ISO-8859-1">>/etc/locale.gen;\
    echo "de_DE@euro ISO-8859-15">>/etc/locale.gen;\
    echo "fr_FR.UTF-8 UTF-8">>/etc/locale.gen;\
    echo "fr_FR ISO-8859-1">>/etc/locale.gen;\
    echo "fr_FR@euro ISO-8859-15">>/etc/locale.gen;\
    echo 'LANG="fr_FR.utf8"'>/etc/default/locale;\
    echo "export LANG=\${LANG:-fr_FR.UTF-8}">>$d/etc/profile.d/0_lang.sh;\
    /usr/sbin/locale-gen;\
    /usr/sbin/locale-gen fr_FR.UTF-8;\
    /usr/sbin/locale-gen de_DE.UTF-8;\
    update-locale LANG=fr_FR.UTF-8;\
    sed -re "s/PasswordAuthentication\s.*/PasswordAuthentication yes/g" -i /etc/ssh/sshd_config;\
    /sbin/lxc-cleanup.sh
CMD ["/sbin/init"]
