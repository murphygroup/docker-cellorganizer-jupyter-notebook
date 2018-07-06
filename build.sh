#!/bin/bash

git submodule init
git submodule update
cd docker-python
git checkout master
cd ..

wget -nc http://www.cellorganizer.org/Downloads/v2.7/docker/v2.7.2/cellorganizer-v2.7.2-models.tgz && \
	tar -xvf cellorganizer-v2.7.2-models.tgz && \
	rm -f cellorganizer-v2.7.2-models.tgz

docker build -t $(whoami)/cellorganizer .
