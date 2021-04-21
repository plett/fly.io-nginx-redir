FROM bash:5.1.4
RUN apk add npm curl
COPY package.json .
RUN npm install
COPY testscript .
CMD /testscript
