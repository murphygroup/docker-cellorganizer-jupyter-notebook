FROM jupyter/scipy-notebook

###############################################################################################
MAINTAINER Ivan E. Cao-Berg <icaoberg@andrew.cmu.edu>
LABEL Description="MATLAB MCR"
LABEL Vendor="Murphy Lab in the Computational Biology Department at Carnegie Mellon University"
LABEL Web="http://murphylab.cbd.cmu.edu"
LABEL Version="2017a"
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
    vim
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
    
# CONFIGURE ENVIRONMENT VARIABLES FOR MCR
ENV LD_LIBRARY_PATH /opt/mcr/v92/runtime/glnxa64:/opt/mcr/v92/bin/glnxa64:/opt/mcr/v92/sys/os/glnxa64
ENV XAPPLRESDIR /opt/mcr/v92/X11/app-defaults
###############################################################################################

###############################################################################################
# INSTALL VIM
# CONFIGURE ENVIRONMENT
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash
ENV USERNAME murphylab
ENV UID 2000
RUN useradd -m -s /bin/bash -N -u $UID $USERNAME
RUN if [ ! -d /home/$USERNAME/ ]; then mkdir /home/$USERNAME/; fi

# PREPARE IDE
USER $USERNAME
WORKDIR /home/$USERNAME/
RUN git clone https://github.com/icaoberg/vim-as-an-ide.git && mv vim-as-an-ide/vimrc.vim ~/.vimrc && rm -rf vim-as-an-ide
RUN mkdir ~/.vim && git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
RUN git clone https://github.com/Yggdroot/duoduo.git && mv duoduo/colors ~/.vim/ && rm -rf duoduo
RUN sed -i 's/solarized/duoduo/g' ~/.vimrc
RUN sed -i 's/nerdtree_tabs_open_on_console_startup = 0/nerdtree_tabs_open_on_console_startup = 1/g' ~/.vimrc
RUN vim +PluginInstall +qall
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER BINARIES
WORKDIR /home/murphylab
USER root
RUN echo "Downloading CellOrganizer v2.7.2" && \
	cd ~/ && \
	wget -nc --quiet http://www.cellorganizer.org/Downloads/v2.7/docker/v2.7.2/cellorganizer-v2.7.2-binaries.tgz && \
	tar -xvf cellorganizer-v2.7.2-binaries.tgz && \
	rm cellorganizer-v2.7.2-binaries.tgz && \
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
###############################################################################################

###############################################################################################
USER murphylab
RUN echo "Downloading models" && \
	wget -nc --quiet http://www.cellorganizer.org/Downloads/v2.7/docker/v2.7.2/cellorganizer-v2.7.2-models.tgz && \
	tar -xvf cellorganizer-v2.7.2-models.tgz && \
	rm -f cellorganizer-v2.7.2-models.tgz
RUN chown -Rv murphylab:users /home/murphylab/cellorganizer
USER murphylab
###############################################################################################
