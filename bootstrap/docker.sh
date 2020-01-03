#!/bin/sh

set -xe

#insall docker
apk add docker

#install docker-compose
apk add py-pip
apk add python-dev libffi-dev openssl-dev gcc libc-dev make
pip install --no-cache-dir docker-compose