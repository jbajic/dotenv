FROM debian:11 AS builder
RUN apk add build-base
WORKDIR /home
COPY hello.c .
RUN gcc -Wall hello.c -o hello

FROM alpine
WORKDIR /home
COPY --from=builder /home/hello .
ENTRYPOINT ["./hello"]
