# github.com/tiredofit/docker-novnc


[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-novnc?style=flat-square)](https://github.com/tiredofit/docker-novnc/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-novnc/build?style=flat-square)](https://github.com/tiredofit/docker-novnc/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/novnc.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/novnc/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/novnc.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/novnc/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *

## About

This will build a Docker image for [NoVNC](https://github.com/novnc/noVNC), to allow Linux GUI applications be displayed via a web browser


*    Debian and Alpine Variants
*    Ability to utilize authentication via various methods

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/novnc) and is the recommended method of installation.

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Alpine Base | Tag            | Debian Base | Tag              |
| ----------- | -------------- | ----------- | ---------------- |
| latest      | `:latest`      | latest      | `:debian-latest` |
| edge        | `:alpine     ` | Bullseye    | `:debian`        |

```bash
docker pull tiredofit/novnc:(imagetag)
```
#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v6`, `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary
### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory   | Description                                                                         |
| ----------- | ----------------------------------------------------------------------------------- |
| `/data/ `   | Drop your Datafiles in this Directory to be utilized by the application in question |
| `/www/logs` | Logfiles for Nginx error and Access                                                 |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                                           |
| ------------------------------------------------------ | ----------------------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux                |
| [OS Base](https://github.com/tiredofit/docker-debian/) | Customized Image based on Debian Linux                |
| [Nginx](https://github.com/tiredofit/docker-nginx/)    | Nginx webserver image based on either of the above OS |

#### Container Options

| Parameter           | Description                                                                    | Default    |
| ------------------- | ------------------------------------------------------------------------------ | ---------- |
| `DISPLAY_MODE`      | Choose `auto`, `scale`, `remote` or `none` for display resizing to the browser | `scale`    |
| `RESOLUTION`        | Resolution of the Application via webbrowser                                   | `1280x720` |
| `NOVNC_LISTEN_PORT` | The Web browsing listening port                                                | `6080`     |
| `VNC_LISTEN_PORT`   | The Web browsing listening port                                                | `5900`     |
| `VNC_PASSWORD`      | (optional) Basic Password for authentication                                   |            |

** For more advanced authentication see the [Nginx](https://github.com/tiredofit/docker-nginx/) image.

### Networking

The following ports are exposed.

| Port   | Description |
| ------ | ----------- |
| `5900` | VNC         |
| `6080` | noVNC       |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
## References

* https://github.com/novnc/novnc/
