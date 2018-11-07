FROM ubuntu:16.04
LABEL date="October 24, 2018" 
LABEL maintainer="Sara Jones <jonessarae@gmail.com>"

RUN apt-get update && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
    wget \
    unzip \
    software-properties-common &&\

### for java 7    
    add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get install openjdk-7-jdk -y && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    

### picard:1.110
WORKDIR /opt
RUN wget https://sourceforge.net/projects/picard/files/picard-tools/1.110/picard-tools-1.110.zip
RUN unzip picard-tools-1.110.zip
ENV MARKDUPLICATES="/opt/picard-tools-1.110/MarkDuplicates.jar"

COPY Dockerfile /opt

