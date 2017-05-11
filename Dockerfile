FROM platformstories/deploy-cnn-chip-classifier

MAINTAINER Nikki Aldeborgh <nikki.aldeborgh@digitalglobe.com>

RUN apt-get -y update && apt-get -y install git

ENV PROTOUSER 
ENV PROTOPASSWORD 

RUN git clone https://${PROTOUSER}:${PROTOPASSWORD}@github.com/digitalglobe/protogen && \
    cd protogen && \
    git checkout dev && \
    python setup.py install && \
    cd ..

RUN rm /deploy-cnn-chip-classifier.py
 
ADD ./bin /
