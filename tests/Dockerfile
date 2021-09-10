FROM bats/bats:v1.4.1

RUN apk add curl

CMD mkdir /code
WORKDIR /code

COPY batsfiles .

ENTRYPOINT ["/tini", "--", "bash"]
CMD ["bats", "/code/test.bats"]
