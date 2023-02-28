#!/bin/bash

if [ ! -d ~/Desktop/CellOrganizerDocker ]; then
        DIRECTORY=$(pwd)
      ####################################################################################################
	    # icaoberg - this creates temporary folder on Desktop
	    mkdir -p ~/Desktop/mmbios2021
	    chmod a+rwx -R ~/Desktop/CellOrganizerDocker
	    cd ~/Desktop/CellOrganizerDocker
      ####################################################################################################
	cd $DIRECTORY
fi

############################################################################################################
docker run --rm -p 8888:8888 \
	-v ~/Desktop/CellOrganizerDocker:/home/murphylab/cellorganizer/local \
	--memory="4g" \
	--cpus=2 \
	-e JUPYTER_LAB_ENABLE=yes \
	murphylab/cellorganizer-jupyter:dev
############################################################################################################
