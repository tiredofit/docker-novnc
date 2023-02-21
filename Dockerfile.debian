ARG DISTRO=debian
ARG DISTRO_VARIANT=bullseye

FROM tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV APP_USER=app \
    XDG_RUNTIME_DIR=/data \
    CONTAINER_ENABLE_PERMISSIONS=TRUE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED="novnc" \
    NGINX_WEBROOT=/usr/share/novnc \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=tiredofit/novnc \
    IMAGE_REPO_URL=https://github.com/tiredofit/docker-novnc

RUN source /assets/functions/00-container && \
    set -x && \
    #sed -i "s|html htm shtml;|html htm shtml js;|g" /etc/nginx/mime.types && \
    #sed -i "/application\/javascript .*js;/d" /etc/nginx/mime.types && \
    addgroup --gid 1000 ${APP_USER} && \
    adduser --uid 1000 \
            --gid 1000 \
            --gecos "App User" \
            --shell /sbin/nologin \
            --home /data \
#            --disabled-login \
            --disabled-password \
            ${APP_USER} && \
    package update && \
    package upgrade && \
    package install \
                    binutils \
                    dbus \
                    libssl1.1 \
                    locales \
                    openbox \
                    python3 \
                    websockify \
                    x11vnc \
                    x11-apps \
                    xterm \
                    xvfb \
                    && \
    mkdir -p /usr/share/novnc/utils/websockify && \
    curl -sSL https://github.com/novnc/noVNC/archive/master.tar.gz | tar xfz - --strip 1 -C /usr/share/novnc && \
    mv /usr/share/novnc/utils/novnc_proxy /usr/bin/novnc_server && \
    curl -sSL https://github.com/novnc/websockify/archive/master.tar.gz | tar xfz - --strip 1 -C /usr/share/novnc/utils/websockify && \
    mkdir -p /data && \
    chown -R ${APP_USER}:${APP_USER} /data && \
    package cleanup && \
    rm -rf /var/tmp/*

EXPOSE 6080 5900
WORKDIR /data

COPY install/ /
