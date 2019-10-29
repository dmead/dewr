#!/bin/bash
#
# dewr is a development wrapper
#  instllation:
#   create a symlink to dewr in your path as such
#   ln -s $(pwd)/dewr.sh /usr/local/bin/dewr
# use case:
#    1. you have a project checked out locally
#    2. you want to drop into a stable enviroment for everything except
#       editing
#    3. write yourself a dockerfile, test it with `dewr build`
#       or start with Dockerfile.dev in this repo
# usage:
#     > dewr build
#     > dewr run sh
#
# caveats:
#      1. keep it simple. this is for running your compiler and
#         running tools that you don't want to manage on each dev machine
#      2. changes to your dockerfile require every dev to run dewr build
#         on their enviroments
#      3. tested on MacOS which may have a different permissions model than
#         linux or windows. you may need to specify uid/gid explicitly in linux

DOCKERFILE="Dockerfile.dev"

export IMAGE_TAG=$(echo ${PWD//\//''} | awk '{print tolower($0)}')

if [[ $1 == "run" ]]; then
    docker run                       \
      --rm                           \
      --volume $(pwd):/opt/app       \
      --privileged                   \
      -it $IMAGE_TAG                 \
      $2
elif [[ $1 ==  "build" ]]; then
    docker build                     \
      -f Dockerfile.dev              \
      -t  "$IMAGE_TAG:latest"        \
      .
else
  echo "I can only run or build things"
fi
