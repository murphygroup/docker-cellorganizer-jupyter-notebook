#!/bin/bash

git submodule init
git submodule update
cd docker-python
git checkout master
cd ..

wget -nc http://www.cellorganizer.org/Downloads/v2.8.0/docker/cellorganizer-models.tgz && \
	tar -xvf cellorganizer-models.tgz
wget -nc http://www.cellorganizer.org/Downloads/v2.8.0/docker/images/demo2D01.tgz && \
	mkdir -p cellorganizer/images/HeLa/2D/LAMP2 && \
	tar -xvf demo2D01.tgz -C cellorganizer/images/HeLa/2D/LAMP2/
docker build -t $(whoami)/cellorganizer .
rm -rfv cellorganizer
