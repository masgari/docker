base
======================
Ubuntu precise (12.04) configured for UK sources with London time zone.

Installed application and services: 

```
curl, wget, unzip

ssh server
```

```
ssh root@<container-ip>
Password: r
```

Makefile
======================

```make
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

```
