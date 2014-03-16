Tesseract OCR
======================
Docker container for Tesseract-OCR (https://code.google.com/p/tesseract-ocr/)

Environment variables:
```
ENV DEBIAN_FRONTEND noninteractive

ENV TESSERACT_VERSION 3.02.02
ENV TESSDATA_VERSION 3.02
ENV TESSDATA_OSD 3.01.osd

ENV DATA_FOLDER /usr/local/share/tessdata
ENV HEADER_FOLDER /usr/local/include/tesseract
```


Makefile
======================

```make
REPO=masgari/tesseract

.DEFAULT: build
.PHONY: build push all

all: build

build:
	docker build -t $(REPO):3.0.2 .
push:
	docker push $(REPO)

run:
	docker run -t -rm $(REPO) $(filter-out $@,$(MAKECMDGOALS)) $(ARGS)

bash:
	docker run -t -i -rm  $(REPO) /bin/bash

```
