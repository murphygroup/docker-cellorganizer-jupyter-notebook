# Purpose

This repository is used to build the docker container used for CellOrganizer. 

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

## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, [email](mailto:cellorganizer-dev@compbio.cmu.edu), or any other method with the owners of this repository before making a change.

---

Support for [CellOrganizer](http://cellorganizer.org/) has been provided by grants GM075205, GM090033 and GM103712 from the [National Institute of General Medical Sciences](http://www.nigms.nih.gov/), grants MCB1121919 and MCB1121793 from the [U.S. National Science Foundation](http://nsf.gov/), by a Forschungspreis from the [Alexander von Humboldt Foundation](http://www.humboldt-foundation.de/), and by the [Freiburg Institute for Advanced Studies](http://www.frias.uni-freiburg.de/lifenet?set_language=en).

[![MMBioS](https://i1.wp.com/www.cellorganizer.org/wp-content/uploads/2017/08/MMBioSlogo-e1503517857313.gif?h=60)](http://www.mmbios.org)

Copyright (c) 2007-2019 by the [Murphy Lab](http://murphylab.web.cmu.edu) at the [Computational Biology Department](http://www.cbd.cmu.edu) in [Carnegie Mellon University](http://www.cmu.edu)
