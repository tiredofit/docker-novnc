ARG DISTRO=alpine
ARG DISTRO_VARIANT=edge

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV APP_USER=app \
    XDG_RUNTIME_DIR=/data \
    CONTAINER_ENABLE_PERMISSIONS=TRUE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED="novnc" \
    NGINX_WEBROOT=/usr/share/novnc \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=tiredofit/firefox \
    IMAGE_REPO_URL=https://github.com/tiredofit/docker-firefox

RUN source /assets/functions/00-container && \
    set -x && \
    #sed -i "s|html htm shtml;|html htm shtml js;|g" /etc/nginx/mime.types && \
    #sed -i "/application\/javascript .*js;/d" /etc/nginx/mime.types && \
    addgroup -g 1000 ${APP_USER} && \
    adduser -S -D -H -h /data -s /sbin/nologin -G ${APP_USER} -u 1000 ${APP_USER} && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    package update && \
    package upgrade && \
    package add .x-run-deps \
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
    package add .base-fonts \
                            font-noto \
                            font-noto-extra \
                            terminus-font \
                            ttf-dejavu \
                            ttf-font-awesome \
                            ttf-inconsolata \
                            && \
    package add -t .xeyes-run-deps \
                            xeyes \
                            && \
    mkdir -p /data && \
    chown -R ${APP_USER}:${APP_USER} /data && \
    package cleanup

EXPOSE 6080 5900
WORKDIR /data

COPY install/ /
