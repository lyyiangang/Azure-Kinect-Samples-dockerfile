#!/usr/bin/env bash

source source.sh

# VOLUMES="-v /home/renat:/home/renat -v $PWD/../src:/src"
VOLUMES=" -v $PWD/../src:/src"

# python -m pyk4a.viewer --vis_color --no_bt --no_depth
# ensure nvidia is your default runtime
docker run --gpus all -ti $PARAMS $VOLUMES $NAME_03 $@