FROM node:7.4.0
MAINTAINER Nick Chistyakov "nick@6river.com"
ENV RELEASED_AT 2017-02-22

# Node settings
ENV NODE_PATH "$NODE_PATH:./"
ENV NODE_ENV production

# Pusher settings
ENV PUSHER_APP_ID "Your App ID"
ENV PUSHER_KEY "Your Key"
ENV PUSHER_SECRET "Your Secret"
ENV PUSHER_API_HOST "api.pusherapp.com"
ENV PUSHER_API_PORT 443
ENV PUSHER_API_SCHEME https

# External API urls
ENV WFM_URL "http://wm/v1"
ENV TC_URL "http://tc/v1"
ENV AM_URL "http://am/v1"
ENV MM_URL "http://map/v1"

ENV LOGSENE_TOKEN ""

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN npm rebuild

CMD ["node", "."]

