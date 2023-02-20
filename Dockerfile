FROM alpine:3.17 as builder

LABEL maintainer="Michael Trip <m.trip@atcomputing.nl>"

ENV DEFAULTCMD ksvalidator
# RUN apk update && \
    # apk --no-cache upgrade && \
    # apk --no-cache add python3-dev~=3.10.9 \
        # py3-pip~=22.3.1 \
        # py3-requests~=2.28.1
#
RUN apk update
RUN apk --no-cache upgrade
RUN apk --no-cache add python3-dev~=3.10.9 py3-pip~=22.3.1 py3-requests~=2.28.1

COPY src/requirements.txt /tmp
COPY src/entrypoint.sh /
RUN chmod +x /entrypoint.sh && pip --no-cache-dir install -r /tmp/requirements.txt && adduser -D -u 1001 pykickstart
USER pykickstart

ENTRYPOINT [ "/entrypoint.sh" ]