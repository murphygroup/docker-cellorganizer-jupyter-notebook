#!/bin/bash

if [ ! -d data ]; then
	mkdir data
	wget -nc http://murphylab.web.cmu.edu/data/TcellModels/LATFull.tgz
	tar -xvf LATFull.tgz
	rm -fv LATFull.tgz

	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/multitiff/cellorganizer_full_image_collection.zip
	unzip cellorganizer_full_image_collection.zip
	rm -fv cellorganizer_full_image_collection.zip
fi

docker run --rm -p 8888:8888 -v data:/home/murphylab/cellorganizer/local -e JUPYTER_LAB_ENABLE=yes murphylab/cellorganizer-jupyter
