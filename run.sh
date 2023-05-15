#!/bin/bash

if [ ! -d ~/Desktop/CellOrganizer-Docker ]; then
        DIRECTORY=$(pwd)
      ####################################################################################################
	    # icaoberg - this creates temporary folder on Desktop
	    mkdir -p ~/Desktop/CellOrganizer-Docker
	    chmod a+rwx -R ~/Desktop/CellOrganizer-Docker
	    cd ~/Desktop/CellOrganizer-Docker
      ####################################################################################################
	cd $DIRECTORY
fi

############################################################################################################
docker run --rm -p 8888:8888 \
	-v ~/Desktop/CellOrganizer-Docker:/home/murphylab/cellorganizer/local \
	--memory="4g" \
	--cpus=2 \
	-e JUPYTER_LAB_ENABLE=yes \
	murphylab/cellorganizer-jupyter:dev
############################################################################################################
