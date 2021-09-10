FROM bash:5.1.8

RUN apk add npm curl

RUN mkdir -p /code
WORKDIR /code

COPY package.json .
RUN npm install --legacy-peer-deps

COPY testscript .
CMD testscript
