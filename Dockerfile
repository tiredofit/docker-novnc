FROM tiredofit/nginx:alpine-edge
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV APP_USER=app \
    XDG_RUNTIME_DIR=/data \
    CONTAINER_ENABLE_PERMISSIONS=TRUE \
    IMAGE_NAME=tiredofit/novnc \
    IMAGE_REPO_URL=https://github.com/tiredofit/docker-novnc

RUN set -x && \
    addgroup -g 1000 ${APP_USER} && \
    adduser -S -D -H -h /dev/null -s /sbin/nologin -G ${APP_USER} -u 1000 ${APP_USER} && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add -t .x-run-deps \
                binutils \
                dbus \
                gcompat \
                git \
                openbox \
                novnc \
                websockify \
                xvfb \
                x11vnc \
                && \
    apk add -t .base-fonts \
                font-noto \
                font-noto-extra \
                gtk+3.0-dev \
                terminus-font \
                ttf-dejavu \
                ttf-font-awesome \
                ttf-inconsolata \
                && \
    apk add -t .xeyes-run-deps \
                xeyes \
                && \
    mkdir -p /data && \
    chown -R ${APP_USER}:${APP_USER} /data && \
    rm -rf /var/cache/apk/*

EXPOSE 6080 5900

ADD install/ /
