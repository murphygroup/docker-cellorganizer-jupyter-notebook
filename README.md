# docker-cellorganizer-jupyter-notebook

[![Build Status](https://travis-ci.org/murphygroup/docker-cellorganizer-jupyter-notebook.svg?branch=master)](https://travis-ci.org/murphygroup/docker-cellorganizer-jupyter-notebook)
[![Release Status](https://img.shields.io/badge/release-v2.8.0-red.svg)](http://www.cellorganizer.org/)
[![GitHub issues](https://img.shields.io/github/issues/murphygroup/docker-cellorganizer-jupyter-notebook.svg)](https://github.com/murphygroup/docker-cellorganizer-jupyter-notebook/issues)
[![GitHub forks](https://img.shields.io/github/forks/murphygroup/docker-cellorganizer-jupyter-notebook.svg)](https://github.com/murphygroup/docker-cellorganizer-jupyter-notebook/network)
[![GitHub stars](https://img.shields.io/github/stars/murphygroup/docker-cellorganizer-jupyter-notebook.svg)](https://github.com/murphygroup/docker-cellorganizer-jupyter-notebook/stargazers)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/licenses/quick-guide-gplv3.en.html)

## About CellOrganizer 

![CellOrganizer Logo](http://www.cellorganizer.org/wp-content/uploads/2017/08/CellOrganizerLogo2-250.jpg)

The [CellOrganizer](http://cellorganizer.org/) project provides tools for

* learning generative models of cell organization directly from images
* storing and retrieving those models
* synthesizing cell images (or other representations) from one or more models

Model learning captures variation among cells in a collection of images. Images used for model learning and instances synthesized from models can be two- or three-dimensional static images or movies.

[CellOrganizer](http://cellorganizer.org/) can learn models of

* cell shape
* nuclear shape
* chromatin texture
* vesicular organelle size, shape and position
* microtubule distribution.

These models can be conditional upon each other. For example, for a given synthesized cell instance, organelle position is dependent upon the cell and nuclear shape of that instance.

Cell types for which generative models for at least some organelles have been built include human HeLa cells, mouse NIH 3T3 cells, and Arabidopsis protoplasts. Planned projects include mouse T lymphocytes and rat PC12 cells.

### CellOrganizer v2.8.0

#### Features
* Added improved model for generating protein distributions during T cell synapse formation that only requires annotation of cell couples at a single time point model and improves synapse alignment. Includes training, synthesis and info demos.
* Added outline PCA model for 2D cell and nuclear shapes. Includes training, synthesis and info demos.
* Added SPHARM-RPDM model for 3D cell and nuclear shapes (see https://doi.org/10.1093/bioinformatics/bty983). Includes training, synthesis and info demos.

#### Fixes 
* Fixed issues with options.train.flag. Valid options should be nuclear, cell, framework, and protein.

#### Enhancements
* Modularized and cleaned up img2slml.

#### Demo List

The following demo scripts are included in the image. 

| Demo Name| Training | Synthesis |
|----------|----------|-----------|
| demo2D00 |          |            X            |
| demo2D01 |            X           |           |
| demo3D00 |          |            X            |
| demo3D11 |            X           |           |
| demo3D12 |            X           |           |

The demos in the table above are the same demos included in the Matlab distribution.

## Docker

### Installing Docker

Installing Docker is beyond the scope of this document. To learn about Docker Community Edition (CE), click [here](https://www.docker.com/community-edition).

* To install Docker-for-Mac, click [here](https://docs.docker.com/docker-for-mac/install/).
* To install Docker-for-Windows, click [here](https://docs.docker.com/docker-for-windows/install/).

### Installing Kitematic

The easiest way to download an image and run a container is to use [Kitematic](https://kitematic.com/).

* To install Kitematic, click [here](https://kitematic.com/docs/).

### About the Docker container

#### Downloading image and running container using Kitematic

Running Kitematic will open a window that looks like this

![Kitematic](https://raw.githubusercontent.com/murphygroup/docker-cellorganizer/master/images/kitematic.png)

Use the searchbar to search for `cellorganizer`

![CellOrganizer](https://raw.githubusercontent.com/murphygroup/docker-cellorganizer/master/images/cellorganizer.png)

and click `Create`.

#### Downloading image and running container


To build an image using the `Dockerfile` in this repository, run the command

```
➜ docker build -t "murphylab/cellorganizer" .
```

The previous step should build an image

```
➜  docker container ls -a

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
48dde52f2bc8        murphylab/cellorganizer     "/bin/bash -c 'pyt..."   45 seconds ago      Exited (0) 39 seconds ago                         frosty_wescoff
```

To run a container using the image above

```
➜  docker run -i -t murphylab/cellorganizer
```

#### Additional files

The container comes with

* CellOrganizer binaries
* [Generative models](http://www.cellorganizer.org/model_repository/)
* [Murphy Lab 2D/3D HeLa datasets](http://murphylab.web.cmu.edu/data/)
* [BioFormats tools](https://downloads.openmicroscopy.org/bio-formats/)
* [vim-as-an-IDE](https://github.com/icaoberg/vim-as-an-ide)

---

Support for [CellOrganizer](http://cellorganizer.org/) has been provided by grants GM075205, GM090033 and GM103712 from the [National Institute of General Medical Sciences](http://www.nigms.nih.gov/), grants MCB1121919 and MCB1121793 from the [U.S. National Science Foundation](http://nsf.gov/), by a Forschungspreis from the [Alexander von Humboldt Foundation](http://www.humboldt-foundation.de/), and by the [Freiburg Institute for Advanced Studies](http://www.frias.uni-freiburg.de/lifenet?set_language=en).

[![MMBioS](https://i1.wp.com/www.cellorganizer.org/wp-content/uploads/2017/08/MMBioSlogo-e1503517857313.gif?h=60)](http://www.mmbios.org)

Copyright © 2007-2019 by the [Murphy Lab](http://murphylab.web.cmu.edu) at the [Computational Biology Department](http://www.cbd.cmu.edu) in [Carnegie Mellon University](http://www.cmu.edu)
