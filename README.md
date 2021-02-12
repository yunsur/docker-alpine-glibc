[![Docker Stars](https://img.shields.io/docker/stars/yunsur/alpine-glibc.svg?style=flat-square)](https://hub.docker.com/r/yunsur/alpine-glibc/)
[![Docker Pulls](https://img.shields.io/docker/pulls/yunsur/alpine-glibc.svg?style=flat-square)](https://hub.docker.com/r/yunsur/alpine-glibc/)


Alpine GNU C library (glibc) Docker image
=========================================

This image is based on Alpine Linux image, which is only a 5MB image, and contains glibc to enable
proprietary projects compiled against glibc (e.g. OracleJDK, Anaconda) work on Alpine.

This image includes some quirks to make [glibc](https://www.gnu.org/software/libc/) work side by
side with musl libc (default in Alpine Linux). glibc packages for Alpine Linux are prepared by
[Sasha Gerrand](https://github.com/sgerrand) and the releases are published in
[sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) github repo.

Download size of this image is only:

[![](https://images.microbadger.com/badges/image/yunsur/alpine-glibc.svg)](http://microbadger.com/images/yunsur/alpine-glibc "Get your own image badge on microbadger.com")
