FROM ubuntu:16.04
LABEL date="October 11, 2018"
LABEL maintainer="Sara Jones <jonessarae@gmail.com>"

RUN apt-get update && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
    zlib1g-dev \
    libgomp1 

### star:2.4.0g1
ADD https://github.com/alexdobin/STAR/archive/STAR_2.4.0g1.tar.gz /opt
WORKDIR /opt
RUN tar xvzf STAR_2.4.0g1.tar.gz
RUN cp /opt/STAR-STAR_2.4.0g1/bin/Linux_x86_64/STAR /usr/local/bin

COPY Dockerfile /opt 

