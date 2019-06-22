FROM node:10-stretch

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install python
RUN apt update && apt install build-essential

# add dumb-init
#ENV INIT_VER="1.2.2"
#ENV INIT_SUM="37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9"
#ADD https://github.com/Yelp/dumb-init/releases/download/v${INIT_VER}/dumb-init_${INIT_VER}_amd64 /dumb-init
#RUN echo "$INIT_SUM  /dumb-init" | sha256sum -c -
#RUN chmod +x /dumb-init

# Setup node envs
ENV NODE_ENV production

# Install dependencies
COPY ./package.json /usr/src/app/
RUN npm install && npm install statsd-zabbix-backend && npm cache clean --force

# Copy required src
COPY . /usr/src/app

# Expose required ports
EXPOSE 8125/udp
EXPOSE 8126

# Start statsd
ENTRYPOINT [ "node", "stats.js", "config.js" ]
