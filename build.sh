#!/bin/bash

if [ ! -d cellorganizer-python ]; then
	mkdir cellorganizer-python
fi
git submodule init
git submodule update
cd cellorganizer-python
git checkout master
cd ..

if [ ! -f cellorganizer-binaries.tgz ]; then
    wget -nc --quiet http://www.cellorganizer.org/Downloads/latest/docker/cellorganizer-binaries.tgz
fi

tar -xvf cellorganizer-binaries.tgz && \
rm cellorganizer-binaries.tgz

#docker build --no-cache -t icaoberg/cellorganizer-jupyter:latest .
docker build -t murphylab/cellorganizer-jupyter:latest .
docker tag murphylab/cellorganizer-jupyter:latest murphylab/cellorganizer-jupyter:v2.9.0
