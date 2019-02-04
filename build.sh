#!/bin/bash

git submodule init
git submodule update
cd docker-python
git checkout master
cd ..

rm -rfv cellorganizer
