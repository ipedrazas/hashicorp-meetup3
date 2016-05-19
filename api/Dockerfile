FROM alpine:3.3
MAINTAINER Ivan Pedrazas <ipedrazas@gmail.com>

RUN apk add --update \
      python \
      py-pip \
      bash \
       && \
      pip install flask

COPY . /app


CMD [ "python", "/app/meetup.py" ]
