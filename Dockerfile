FROM node:6.10.3-alpine

ENV GLIBC 2.23-r3

# install glibc
RUN apk update && apk add --no-cache openssl ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk && \
    apk add --no-cache glibc-$GLIBC.apk && rm glibc-$GLIBC.apk && \
    ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

# install docker-compose
RUN apk update && apk add curl
RUN curl -o /usr/local/bin/docker-compose -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` \
	&& chmod +x /usr/local/bin/docker-compose

# install eq8store
WORKDIR /opt/eq8store

COPY ./defaults.json /opt/eq8store/defaults.json
COPY ./bin /opt/eq8store/bin
COPY package.json /opt/eq8store/package.json
RUN npm link --production

COPY ./docker-compose.yml /opt/eq8store/docker-compose.yml

COPY ./index.js /opt/eq8store/index.js
COPY ./lib /opt/eq8store/lib

CMD eq8store
