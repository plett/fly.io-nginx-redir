FROM bash:5.1.8
RUN apk add npm curl
COPY package.json .
RUN npm install
COPY testscript .
CMD /testscript
