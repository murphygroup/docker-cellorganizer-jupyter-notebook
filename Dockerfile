FROM jupyter/scipy-notebook

###############################################################################################
MAINTAINER Ivan E. Cao-Berg <icaoberg@andrew.cmu.edu>
LABEL Description="CellOrganizer Docker + Jupyter Notebook"
LABEL Vendor="CellOrganizer"
LABEL Web="http://www.cellorganizer.org"
LABEL Version="v2.8.0"
###############################################################################################

###############################################################################################
# UPDATE OS AND INSTALL TOOLS
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y build-essential git \
    unzip \
    xorg \
    wget \
    tree \
    pandoc \
    curl \
    vim \
    default-jdk
RUN apt-get upgrade -y
###############################################################################################

###############################################################################################
# INSTALL MATLAB MCR 2017 A
USER root
RUN echo "Downloading Matlab MCR 2017a"
RUN mkdir /mcr-install && \
    mkdir /opt/mcr
RUN cd /mcr-install && \
    wget -nc http://ssd.mathworks.com/supportfiles/downloads/R2017a/deployment_files/R2017a/installers/glnxa64/MCR_R2017a_glnxa64_installer.zip && \
    cd /mcr-install && \
    echo "Unzipping container" && \
    unzip -q MCR_R2017a_glnxa64_installer.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    echo "Removing temporary files" && \
    rm -rvf mcr-install
 RUN mv -v /opt/mcr/v92/sys/os/glnxa64/libstdc++.so.6 /opt/mcr/v92/sys/os/glnxa64/libstdc++.so.6.old
    
# CONFIGURE ENVIRONMENT VARIABLES FOR MCR
ENV LD_LIBRARY_PATH /opt/mcr/v92/runtime/glnxa64:/opt/mcr/v92/bin/glnxa64:/opt/mcr/v92/sys/os/glnxa64
ENV XAPPLRESDIR /opt/mcr/v92/X11/app-defaults
###############################################################################################

###############################################################################################
# INSTALL VIM
# CONFIGURE ENVIRONMENT
USER root
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash
ENV USERNAME murphylab
ENV UID 2000
RUN useradd -m -s /bin/bash -N -u $UID $USERNAME
RUN if [ ! -d /home/$USERNAME/ ]; then mkdir /home/$USERNAME/; fi

# PREPARE IDE
USER $USERNAME
WORKDIR /home/$USERNAME/
###############################################################################################

###############################################################################################
# INSTALL BFTOOLS
USER root
RUN wget -nc https://downloads.openmicroscopy.org/latest/bio-formats5.8/artifacts/bftools.zip && \
	unzip bftools.zip && \
	rm -fv bftools.zip && \
	mv -v bftools /opt/
RUN ln -s /opt/bftools/bfconvert /usr/local/bin/bfconvert && \
	ln -s /opt/bftools/showinf /usr/local/bin/showinf && \
	ln -s /opt/bftools/tiffcomment /usr/local/bin/tiffcomment && \
	ln -s /opt/bftools/xmlindent /usr/local/bin/xmlindent && \
	ln -s /opt/bftools/xmlvalid /usr/local/bin/xmlvalid
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER BINARIES
WORKDIR /home/murphylab
USER root
RUN echo "Downloading CellOrganizer v2.8.0" && \
	cd ~/ && \
	wget -nc --quiet http://www.cellorganizer.org/Downloads/v2.8.0/docker/cellorganizer-binaries.tgz && \
	tar -xvf cellorganizer-binaries.tgz && \
	rm cellorganizer-binaries.tgz && \
	mv cellorganizer-binaries /opt && \
	chmod +x /opt/cellorganizer-binaries/img2slml && \
	chmod +x /opt/cellorganizer-binaries/slml2img && \
	chmod +x /opt/cellorganizer-binaries/slml2report && \
	chmod +x /opt/cellorganizer-binaries/slml2info && \
	chmod +x /opt/cellorganizer-binaries/slml2slml && \
	ln -s /opt/cellorganizer-binaries/img2slml /usr/local/bin/img2slml && \
	ln -s /opt/cellorganizer-binaries/slml2img /usr/local/bin/slml2img && \
	ln -s /opt/cellorganizer-binaries/slml2report /usr/local/bin/slml2report && \
	ln -s /opt/cellorganizer-binaries/slml2info /usr/local/bin/slml2info && \
	ln -s /opt/cellorganizer-binaries/slml2slml /usr/local/bin/slml2slml
RUN mkdir /home/murphylab/docker-python && mkdir /home/murphylab/cellorganizer && mkdir /scratch
COPY docker-python /home/murphylab/docker-python
COPY notebooks /home/murphylab/cellorganizer
RUN wget -nc http://www.cellorganizer.org/Downloads/v2.8.0/docker/logo.png && \
	mv -v logo.png /opt/conda/lib/python3.6/site-packages/notebook/static/base/images
COPY cellorganizer /home/murphylab/cellorganizer
RUN ls -lt /home/murphylab
RUN cd /home/murphylab/docker-python && python setup.py install
RUN rm -rf /home/murphylab/docker-python
###############################################################################################

###############################################################################################
USER root
RUN chown -Rv 2000:users /home/murphylab/cellorganizer
RUN chown -Rv 2000:users /scratch
USER murphylab
WORKDIR /home/murphylab/cellorganizer
###############################################################################################
