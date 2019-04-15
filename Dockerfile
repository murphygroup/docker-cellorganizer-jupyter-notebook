###############################################################################################
# ___   ____ _      _ _ ___   ____ ___         __ _
#  | |\ |||_|_)|\/||_| \ |  /\ ||_  | |\/| /\ /__|_
# _|_| \|||_| \|  ||_|_/_|_/--\||_ _|_|  |/--\\_||_
###############################################################################################

FROM murphylab/matlabmcr2018b-jupyter:18.04 as intermediate

###############################################################################################
# INSTALL BFTOOLS
USER root
RUN wget --quiet -nc https://downloads.openmicroscopy.org/latest/bio-formats5.8/artifacts/bftools.zip && \
	unzip bftools.zip && \
	rm -fv bftools.zip && \
	mv -v bftools /opt/
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER BINARIES
WORKDIR /home/murphylab
USER root
RUN echo "Downloading CellOrganizer v2.8.0" && \
	cd ~/ && \
	wget -nc --quiet http://www.cellorganizer.org/Downloads/v2.8.0/docker/cellorganizer-binaries-matlabmcr2018b.tgz && \
	tar -xvf cellorganizer-binaries-matlabmcr2018b.tgz && \
	rm cellorganizer-binaries-matlabmcr2018b.tgz && \
	mv cellorganizer-binaries /opt

RUN mkdir /home/murphylab/cellorganizer-python && mkdir /home/murphylab/cellorganizer
COPY cellorganizer-python /home/murphylab/cellorganizer-python
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER IMAGES FOR DEMO2D01
RUN wget --quiet -nc http://www.cellorganizer.org/Downloads/v2.8.0/docker/images/demo2D01.tgz && \
	mkdir -p cellorganizer/images/HeLa/2D/LAMP2 && \
	tar -xvf demo2D01.tgz -C cellorganizer/images/HeLa/2D/LAMP2/ && \
	rm -fv demo2D01.tgz
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER 3D Diffeomorphic Models
RUN wget --quiet -nc http://www.cellorganizer.org/Downloads/v2.8.0/docker/cellorganizer-models.tgz && \
	mkdir cell-models && tar -xvf cellorganizer-models.tgz -C cell-models && \
	mkdir -p cellorganizer/models/3D/diffeomorphic && \
        mkdir -p cellorganizer/models/2D/HeLa_PCA && \
        mv -v cell-models/cellorganizer/models/2D/HeLa_PCA/* cellorganizer/models/2D/HeLa_PCA && \
        mv -v cell-models/cellorganizer/models/2D/*.mat cellorganizer/models/2D/  && \
        mv -v cell-models/cellorganizer/models/3D/*.mat cellorganizer/models/3D/  && \
        mv -v cell-models/cellorganizer/models/3D/diffeomorphic/* cellorganizer/models/3D/diffeomorphic && \
        rm cellorganizer/models/3D/diffeomorphic/cell_model_nuc_align.mat && \
	rm -rf cellorganizer-models.tgz cell-models
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER NOTEBOOKS
COPY files /home/murphylab/cellorganizer
###############################################################################################

###############################################################################################
# COPY CELLORGANIZER LOGO TO JUPYTER NOTEBOOK
RUN wget --quiet -nc http://www.cellorganizer.org/Downloads/v2.8.0/docker/logo.png && \
	mv -v logo.png /opt/conda/lib/python3.7/site-packages/notebook/static/base/images
###############################################################################################

###############################################################################################
#  _    ___   _       _       ___         __ _
# |_)| | | | | \ |\ ||_\    /  | |\/| /\ /__|_
# |_)|_|_|_|_|_/ | \||_ \/\/  _|_|  |/--\\_||_
#
###############################################################################################

FROM murphylab/matlabmcr2018b-jupyter:18.04

###############################################################################################
MAINTAINER Ivan E. Cao-Berg <icaoberg@andrew.cmu.edu>
LABEL Description="CellOrganizer + Jupyter Notebook"
LABEL Vendor="CellOrganizer"
LABEL Web="http://www.cellorganizer.org"
LABEL Version="v2.8.0"
###############################################################################################

###############################################################################################
# COPY BFTOOLS FROM INTERMEDIATE TO FINAL IMAGE
USER root
COPY --from=intermediate /opt/bftools /opt/bftools
RUN ln -s /opt/bftools/bfconvert /usr/local/bin/bfconvert && \
	ln -s /opt/bftools/showinf /usr/local/bin/showinf && \
	ln -s /opt/bftools/tiffcomment /usr/local/bin/tiffcomment && \
	ln -s /opt/bftools/xmlindent /usr/local/bin/xmlindent && \
	ln -s /opt/bftools/xmlvalid /usr/local/bin/xmlvalid

# COPY CELLORGANIZER BINARIES FROM INTERMEDIATE TO FINAL IMAGE
COPY --from=intermediate /opt/cellorganizer-binaries /opt/cellorganizer-binaries
RUN	chmod +x /opt/cellorganizer-binaries/img2slml && \
	chmod +x /opt/cellorganizer-binaries/slml2img && \
	chmod +x /opt/cellorganizer-binaries/slml2report && \
	chmod +x /opt/cellorganizer-binaries/slml2info && \
	chmod +x /opt/cellorganizer-binaries/slml2slml && \
	ln -s /opt/cellorganizer-binaries/img2slml /usr/local/bin/img2slml && \
	ln -s /opt/cellorganizer-binaries/slml2img /usr/local/bin/slml2img && \
	ln -s /opt/cellorganizer-binaries/slml2report /usr/local/bin/slml2report && \
	ln -s /opt/cellorganizer-binaries/slml2info /usr/local/bin/slml2info && \
	ln -s /opt/cellorganizer-binaries/slml2slml /usr/local/bin/slml2slml

# COPY HOME DIRECTORY FROM INTERMEDIATE TO FINAL IMAGE
COPY --from=intermediate /home/murphylab /home/murphylab

# INSTALL CELLORGANIZER FOR PYTHON
RUN mkdir /scratch
RUN cd /home/murphylab/cellorganizer-python && python setup.py install
RUN rm -rf /home/murphylab/cellorganizer-python

# MOVE LOGO FROM INTERMEDIATE TO FINAL IMAGE
COPY --from=intermediate /opt/conda/lib/python3.7/site-packages/notebook/static/base/images/logo.png /opt/conda/lib/python3.7/site-packages/notebook/static/base/images/logo.png
###############################################################################################

##############################################################################################\
# GET READY!
USER root
RUN chown -Rv 1001:users /home/murphylab/cellorganizer
RUN chown -Rv 1001:users /scratch
USER murphylab
WORKDIR /home/murphylab/cellorganizer
##############################################################################################
