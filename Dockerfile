FROM docker.io/tiredofit/nginx:alpine-edge
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV APP_USER=app \
    XDG_RUNTIME_DIR=/data \
    CONTAINER_ENABLE_PERMISSIONS=TRUE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_WEBROOT=/usr/share/novnc \
    IMAGE_NAME=tiredofit/firefox \
    IMAGE_REPO_URL=https://github.com/tiredofit/docker-firefox

RUN set -x && \
    addgroup -g 1000 ${APP_USER} && \
    adduser -S -D -H -h /data -s /sbin/nologin -G ${APP_USER} -u 1000 ${APP_USER} && \
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
                terminus-font \
                ttf-dejavu \
                ttf-font-awesome \
                ttf-inconsolata \
                && \
    apk add -t .xeyes-run-deps \
                xeyes \
                && \
    apk add -t .firefox-run-deps \
                firefox \
                && \
    mkdir -p /data && \
    chown -R ${APP_USER}:${APP_USER} /data && \
    sed -i "s|html htm shtml;|html htm shtml js;|g" /etc/nginx/mime.types && \
    rm -rf /var/cache/apk/*

EXPOSE 6080 5900
WORKDIR /data

ADD install/ /
