Thrift 0.8.0 Docker container
=============================
Default command is thrift


Makefile
======================

```make

REPO=masgari/thrift

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
