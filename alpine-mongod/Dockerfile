FROM eason02/alpine:3.6

RUN apk add --no-cache mongodb && \
    rm /usr/bin/mongoperf && \
    mkdir -p /data/db && \
    mkdir -p /data/configdb && \
    mkdir -p /data/log && \ 
    mkdir -p /data/keyfile/

COPY ./configdb/mongod.conf /data/configdb
COPY ./keyfile/keyfile /data/keyfile/

VOLUME /data/db
EXPOSE 27017

CMD ["mongod","-f","/data/configdb/mongod.conf"]
