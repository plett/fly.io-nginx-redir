FROM bash:5.1.8

RUN apk add npm curl

WORKDIR /

COPY package.json .
RUN npm install --legacy-peer-deps

COPY testscript .
CMD /testscript
