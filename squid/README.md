squid
======================
Squid proxy server (https://help.ubuntu.com/community/Squid) on default port 3128 with access to all 

```
ssh root@<container-ip>
Password: r
```

Makefile
======================

```make
REPO=masgari/squid

.DEFAULT: build
.PHONY: build push all

all: build

build:
	docker build -t $(REPO):3 .
push:
	docker push $(REPO)

run:
	docker run -t -rm $(REPO) $(filter-out $@,$(MAKECMDGOALS)) $(ARGS)

bash:
	docker run -t -i -rm  $(REPO) /bin/bash

```
