FROM alpine:3.3
MAINTAINER Ivan Pedrazas <ipedrazas@gmail.com>

RUN apk add --update \
      bash curl
COPY . /app

ENV KEY=meetup

RUN chmod +x /app/entrypoint.sh


CMD [ "bash",  "-c", "/app/entrypoint.sh"]

