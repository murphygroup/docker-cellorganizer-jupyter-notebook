#!/bin/bash

if [ ! -d ~/Desktop/mmbios2022 ]; then
        DIRECTORY=$(pwd)
      ####################################################################################################
	    # icaoberg - this creates temporary folder on Desktop
	    mkdir -p ~/Desktop/mmbios2022
	    chmod a+rwx -R ~/Desktop/mmbios2022
	    cd ~/Desktop/mmbios2022
      ####################################################################################################
	cd $DIRECTORY
fi

############################################################################################################
docker run --rm -p 8888:8888 \
	-v ~/Desktop/mmbios2022:/home/murphylab/cellorganizer/local \
	--memory="12g" \
	--cpus=6 \
	-e JUPYTER_LAB_ENABLE=yes \
	murphylab/cellorganizer-jupyter
############################################################################################################
