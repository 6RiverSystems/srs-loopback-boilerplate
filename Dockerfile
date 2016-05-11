FROM node:6
MAINTAINER Nick Chistyakov "nick@6river.com"
ENV RELEASED_AT 2016-05-03

ENV NODE_ENV production
ENV WFM_URL "http://wfm/v1"
ENV AM_URL "http://am/v1"
ENV NODE_PATH "$NODE_PATH:./"

# Declare build arguments
ARG GIT_SSH_KEY

RUN mkdir -p /root/.ssh

# Import private key from environment variable
RUN echo $GIT_SSH_KEY | base64 --decode > /root/.ssh/id_rsa
# Make private key as read only
RUN chmod 400 /root/.ssh/id_rsa
# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add bitbuckets key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install

# Removing deploy SSH keys
RUN rm -rf /root/.ssh

COPY . /usr/src/app

CMD ["node", "."]

