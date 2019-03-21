#!/bin/bash

docker run --rm -p 8888:8888 -e JUPYTER_LAB_ENABLE=yes murphygroup/cellorganizer-jupyter
