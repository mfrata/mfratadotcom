FROM node:12

RUN mkdir -p /usr/src/app
ENV PORT 3000

WORKDIR /usr/src/app

COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app

RUN yarn install

COPY next.config.js /usr/src/app
COPY theme.config.js /usr/src/app
