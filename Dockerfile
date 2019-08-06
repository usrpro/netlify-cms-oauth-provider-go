FROM golang:1.12 as build

ENV GO112MODULE=on

ADD go.mod go.sum /build/ 
WORKDIR /build
RUN go get -v
ADD main.go /build/
RUN go build -v

##########################################################################
FROM debian:stretch-slim

RUN apt-get -y update \
    && apt-get -y install ca-certificates \
    && rm -rf /var/lib/apt/lists

COPY --from=build /build/netlify-cms-oauth-provider-go /usr/local/bin/netlify-cms-oauth-provider-go
ENV HOST=":80"
EXPOSE 80

ENTRYPOINT ["netlify-cms-oauth-provider-go"]
