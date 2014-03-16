#!/bin/sh -e
/usr/sbin/sshd -D &

#run last command in foreground to keep the container alive
/opt/elasticsearch/bin/elasticsearch


