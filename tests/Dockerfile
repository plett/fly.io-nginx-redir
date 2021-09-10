FROM bash:5.1.8
RUN apk add npm curl
# this is a noop comment
COPY package.json .
RUN npm install
COPY testscript .
CMD /testscript
