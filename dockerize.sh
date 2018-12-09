#!/bin/sh
NAME=android-sdk
docker build \
    -t houtan/$NAME \
    -t houtan/$NAME:`date +%Y-%m-%d` \
    -f ./Dockerfile .

