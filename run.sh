#!/bin/bash

if [ ! -d data ]; then
	mkdir data
fi

docker run --rm -p 8888:8888 -v data:/home/murphylab/cellorganizer/data -e JUPYTER_LAB_ENABLE=yes murphylab/cellorganizer-jupyter
