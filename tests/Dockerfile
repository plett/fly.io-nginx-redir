FROM bats/bats:1.8.2

RUN apk add curl

CMD mkdir /code
WORKDIR /code

COPY batsfiles .

ENTRYPOINT ["/tini", "--", "bash"]
CMD ["bats", "/code/test.bats"]
