#!/bin/sh
DIRNAME=$(realpath `dirname $0`)
NAME=$(basename $DIRNAME)
PARENTDIR=$(realpath $DIRNAME/..)
ORG=overhandtech

echo "Building $ORG/$NAME"
docker build \
    -t $ORG/$NAME \
    -t $ORG/$NAME:`date +%Y-%m-%d` \
    -f ./Dockerfile .

