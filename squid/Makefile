REPO=masgari/squid

.DEFAULT: build
.PHONY: build push all

all: build

build:
	docker build -rm -t $(REPO):1.0 .
push:
	docker push $(REPO)

run:
	docker run -t -rm $(REPO) $(filter-out $@,$(MAKECMDGOALS)) $(ARGS)

bash:
	docker run -t -i -rm  $(REPO) /bin/bash
