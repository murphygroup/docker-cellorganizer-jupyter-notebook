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
    echo "downloading from web!!"
#   wget -nc --quiet http://www.cellorganizer.org/Downloads/latest/docker/cellorganizer-binaries.tgz
    wget --no-check-certificate 'https://docs.google.com/uc?
    export=download&id=1EBBnSG-_MjOB1Ju1tQg3kvzYlAUD_v0j' -O 'cellorganizer-binaries.tgz'
fi

tar -xvf cellorganizer-binaries.tgz && \
rm cellorganizer-binaries.tgz

#docker build --no-cache -t icaoberg/cellorganizer-jupyter:latest .
docker build -t murphylab/cellorganizer-jupyter:latest .
docker tag murphylab/cellorganizer-jupyter:latest murphylab/cellorganizer-jupyter:mmbios2021
