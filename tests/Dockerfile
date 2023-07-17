FROM bats/bats:v1.10.0

RUN apk add curl

CMD mkdir /code
WORKDIR /code

COPY batsfiles .

ENTRYPOINT ["/tini", "--", "bash"]
CMD ["bats", "/code/test.bats"]
