base
======================
Ubuntu precise (12.04) configured for GB sources with London time zone.
Installed application and services: 
curl, wget, unzip
ssh server

Default user: root
Password: r

Makefile
======================
REPO=masgari/base

.DEFAULT: build
.PHONY: build push all

all: build

build:
	docker build -t $(REPO):precise .
push:
	docker push $(REPO)

run:
	docker run -t -rm $(REPO) $(filter-out $@,$(MAKECMDGOALS)) $(ARGS)

bash:
	docker run -t -i -rm  $(REPO) /bin/bash


