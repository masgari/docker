FROM masgari/thrift

MAINTAINER Mamad Asgari <mammad.asgari@gmail.com>

# non interactive apt
ENV DEBIAN_FRONTEND noninteractive

ENV TESSERACT_VERSION 3.02.02
ENV TESSDATA_VERSION 3.02
ENV TESSDATA_OSD 3.01.osd

ENV DATA_FOLDER /usr/local/share/tessdata
ENV HEADER_FOLDER /usr/local/include/tesseract

# Install required packages
RUN apt-get -q -y update \
    && apt-get -q -y -f install autoconf automake libtool libpng12-dev libjpeg62-dev \
    libgif-dev zlib1g-dev

RUN apt-get -q -y install libtiff4-dev libleptonica-dev
     
# Compile Tesseract
RUN mkdir /opt/tesseract && cd /opt/tesseract \
    && wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-$TESSERACT_VERSION.tar.gz \
    && tar -xzf tesseract-ocr-$TESSERACT_VERSION.tar.gz \
    && cd tesseract-ocr \
    && ./autogen.sh && ./configure && make && make install && ldconfig \
    && cp ccstruct/{blobs.h,ipoints.h, points.h, rect.h, vecfuncs.h} $HEADER_FOLDER \
    && cp ccutil/{clst.h ,elst.h ,lsterr.h ,mfcpch.h ,notdll.h ,tprintf.h} $HEADER_FOLDER \
    && cp ccmain/osdetect.h $HEADER_FOLDER \
    && cp viewer/scrollview.h $HEADER_FOLDER		 		

# Downlod Tesseract data files
RUN cd /opt/tesseract \
    && wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-$TESSDATA_VERSION.eng.tar.gz \
    && tar -xzf tesseract-ocr-$TESSDATA_VERSION.eng.tar.gz \
    && cp tesseract-ocr/tessdata/eng.* $DATA_FOLDER \
    && wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-$TESSDATA_OSD.tar.gz \
    && tar -xzf tesseract-ocr-$TESSDATA_OSD.tar.gz \
    && cp tesseract-ocr/tessdata/osd.traineddata $DATA_FOLDER \
    && cd / && rm -fr /opt/tesseract \
    && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && rm -fr /tmp/*


CMD ["/usr/local/bin/tesseract", "--help"]    
