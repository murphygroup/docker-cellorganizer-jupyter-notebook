#!/bin/bash

git submodule init
git submodule update
cd cellorganizer-python
git checkout master
cd ..
docker build --no-cache -t $(whoami)/cellorganizer-jupyter .

