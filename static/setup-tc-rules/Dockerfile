FROM node:8.16-jessie

RUN mkdir /opt/firedex

COPY ./ /opt/firedex

WORKDIR /opt/firedex/

RUN apt-get update

RUN npm install

CMD ["node", "setup-tc-rules.js"]