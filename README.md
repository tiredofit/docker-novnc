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
    - [Authentication Options](#authentication-options)
    - [Bot Blocking Options](#bot-blocking-options)
    - [Logging Options](#logging-options)
    - [Compression Options](#compression-options)
    - [DDoS Options](#ddos-options)
    - [Reverse Proxy Options](#reverse-proxy-options)
    - [Container Options](#container-options)
    - [Functionality Options](#functionality-options)
    - [Performance Options](#performance-options)
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

| Alpine Base | Tag            | Debian Base | Tag                |
| ----------- | -------------- | ----------- | ------------------ |
| latest      | `:latest`      | latest      | `:debian-latest`   |
| edge        | `:alpine     ` | Bullseye    | `:debian`          |

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

The container starts up and reads from `/etc/nginx/nginx.conf` for some basic configuration and to listen on port 73 internally for Nginx Status responses. `/etc/nginx/conf.d` contains a sample configuration file that can be used to customize a nginx server block.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory   | Description                                                 |
| ----------- | ----------------------------------------------------------- |
| `/data/ `   | Drop your Datafiles in this Directory to be utilized by the application in question |
| `/www/logs` | Logfiles for Nginx error and Access                         |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |
| [OS Base](https://github.com/tiredofit/docker-debian/) | Customized Image based on Debian Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/) | Nginx webserver image based on either of the above OS |

#### Authentication Options

Advanced - You can choose to request visitors be authenticated before accessing your site. Options are below.

| Parameter                                   | Description                                                                     | Default        |
| ------------------------------------------- | ------------------------------------------------------------------------------- | -------------- |
| `NGINX_AUTHENTICATION_TYPE`                 | Protect the site with `BASIC`, `LDAP`, `LLNG`                                   | `NONE`         |
| `NGINX_AUTHENTICATION_TITLE`                | Challenge response when visiting protected site                                 | `Please login` |
| `NGINX_AUTHENTICATION_BASIC_USER1`          | If `BASIC` chosen enter this for the username to protect site                   | `admin`        |
| `NGINX_AUTHENTICATION_BASIC_PASS1`          | If `BASIC` chosen enter this for the password to protect site                   | `password`     |
| `NGINX_AUTHENTICATION_BASIC_USER2`          | As above, increment for more users                                              |                |
| `NGINX_AUTHENTICATION_BASIC_PASS2`          | As above, increment for more users                                              |                |
| `NGINX_AUTHENTICATION_LDAP_HOST`            | Hostname and port number of LDAP Server - eg  `ldap://ldapserver:389`           |                |
| `NGINX_AUTHENTICATION_LDAP_BIND_DN`         | User to Bind to LDAP - eg   `cn=admin,dc=orgname,dc=org`                        |                |
| `NGINX_AUTHENTICATION_LDAP_BIND_PW`         | Password for Above Bind User - eg   `password`                                  |                |
| `NGINX_AUTHENTICATION_LDAP_BASE_DN`         | Base Distringuished Name - eg `dc=hostname,dc=com`                              |                |
| `NGINX_AUTHENTICATION_LDAP_ATTRIBUTE`       | Unique Identifier Attrbiute -ie  `uid`                                          |                |
| `NGINX_AUTHENTICATION_LDAP_SCOPE`           | LDAP Scope for searching - eg  `sub`                                            |                |
| `NGINX_AUTHENTICATION_LDAP_FILTER`          | Define what object that is searched for (ie  `objectClass=person`)              |                |
| `NGINX_AUTHENTICATION_LDAP_GROUP_ATTRIBUTE` | If searching inside of a group what is the Group Attribute - eg  `uniquemember` |                |
| `NGINX_AUTHENTICATION_LLNG_HANDLER_HOST`    | If `LLNG` chosen use hostname of handler                                        | `llng-handler` |
| `NGINX_AUTHENTICATION_LLNG_HANDLER_PORT`    | If `LLNG` chosen use this port for handler                                      | `2884`         |
| `NGINX_AUTHENTICATION_LLNG_ATTRIBUTE1`      | Syntax: HEADER_NAME, Variable, Upstream Variable - See note below               |                |
| `NGINX_AUTHENTICATION_LLNG_ATTRIBUTE2`      | Syntax: HEADER_NAME, Variable, Upstream Variable - See note below               |                |

When working with `NGINX_AUTHENTICATION_LLNG_ATTRIBUTE2` you will need to omit any `$` chracters from your string. It will be added in upon container startup. Example:
`NGINX_AUTHENTICATION_LLNG_ATTRIBUTE1=HTTP_AUTH_USER,uid,upstream_http_uid` will get converted into `HTTP_AUTH_USER,$uid,$upstream_http_uid` and get placed in the appropriate areas in the configuration.

### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `5900` | VNC        |
| `6080` | noVNC        |

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
