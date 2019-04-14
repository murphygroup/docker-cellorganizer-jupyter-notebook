#!/bin/bash

git submodule init
git submodule update
cd cellorganizer-python
git checkout master
cd ..
docker build --no-cache -t murphylab/cellorganizer-jupyter:latest .
docker tag murphylab/cellorganizer-jupyter:latest murphylab/cellorganizer-jupyter:v2.8.0
