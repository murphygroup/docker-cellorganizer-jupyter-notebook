###############################################################################################
# ___   ____ _      _ _ ___   ____ ___         __ _
#  | |\ |||_|_)|\/||_| \ |  /\ ||_  | |\/| /\ /__|_
# _|_| \|||_| \|  ||_|_/_|_/--\||_ _|_|  |/--\\_||_
###############################################################################################

FROM murphylab/matlabmcr2019b-jupyter:latest as intermediate

###############################################################################################
# INSTALL BFTOOLS
USER root
RUN wget --quiet --no-check-certificate -nc https://downloads.openmicroscopy.org/bio-formats/6.5.0/artifacts/bftools.zip && \
	unzip bftools.zip && \
	rm -fv bftools.zip && \
	mv -v bftools /opt/
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER BINARIES
USER root
RUN mkdir /home/murphylab/cellorganizer-python && mkdir /home/murphylab/cellorganizer
WORKDIR /home/murphylab
ADD cellorganizer-python /home/murphylab/cellorganizer-python
###############################################################################################

###############################################################################################
# INSTALL CELLORGANIZER NOTEBOOKS
# no need for old notebook files
COPY files /home/murphylab/cellorganizer
###############################################################################################

###############################################################################################
# COPY CELLORGANIZER LOGO TO JUPYTER NOTEBOOK
RUN wget --quiet -nc http://www.cellorganizer.org/Downloads/latest/docker/logo.png && \
	mv -v logo.png /opt/conda/lib/python3.7/site-packages/notebook/static/base/images
###############################################################################################

###############################################################################################
#  _    ___   _       _       ___         __ _
# |_)| | | | | \ |\ ||_\    /  | |\/| /\ /__|_
# |_)|_|_|_|_|_/ | \||_ \/\/  _|_|  |/--\\_||_
#
###############################################################################################

FROM murphylab/matlabmcr2019b-jupyter:latest
#FROM python:3.9-slim
#FROM ubuntu
###############################################################################################
MAINTAINER Ivan E. Cao-Berg <icaoberg@andrew.cmu.edu>
LABEL Description="CellOrganizer + Jupyter Notebook"
LABEL Vendor="CellOrganizer"
LABEL Web="http://www.cellorganizer.org"
LABEL Version="v2.9.0"
###############################################################################################
#create new user
#ARG USER_ID
#ARG GROUP_ID

#RUN addgroup --gid $GROUP_ID user
#RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
#USER user
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
ADD cellorganizer-binaries /opt/cellorganizer-binaries/.
RUN	chmod +x /opt/cellorganizer-binaries/img2slml && \
	chmod +x /opt/cellorganizer-binaries/slml2img && \
	chmod +x /opt/cellorganizer-binaries/slml2report && \
	chmod +x /opt/cellorganizer-binaries/slml2info && \
	chmod +x /opt/cellorganizer-binaries/slml2slml && \
	chmod +x /opt/cellorganizer-binaries/image2SPHARMparameterization && \
	chmod +x /opt/cellorganizer-binaries/img2shapespace && \
	chmod +x /opt/cellorganizer-binaries/SPHARMparameterization2image && \
	chmod +x /opt/cellorganizer-binaries/SPHARMparameterization2mesh && \
	ln -s /opt/cellorganizer-binaries/img2slml /usr/local/bin/img2slml && \
	ln -s /opt/cellorganizer-binaries/slml2img /usr/local/bin/slml2img && \
	ln -s /opt/cellorganizer-binaries/slml2report /usr/local/bin/slml2report && \
	ln -s /opt/cellorganizer-binaries/slml2info /usr/local/bin/slml2info && \
	ln -s /opt/cellorganizer-binaries/slml2slml /usr/local/bin/slml2slml && \
	ln -s /opt/cellorganizer-binaries/image2SPHARMparameterization /usr/local/bin/image2SPHARMparameterization && \
	ln -s /opt/cellorganizer-binaries/img2shapespace /usr/local/bin/img2shapespace && \
	ln -s /opt/cellorganizer-binaries/SPHARMparameterization2image /usr/local/bin/SPHARMparameterization2image && \
	ln -s /opt/cellorganizer-binaries/SPHARMparameterization2mesh /usr/local/bin/SPHARMparameterization2mesh

# PIP INSTALL
ADD cellorganizer-python/requirements.txt /home/murphylab/cellorganizer-python/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r /home/murphylab/cellorganizer-python/requirements.txt
  
# COPY HOME DIRECTORY FROM INTERMEDIATE TO FINAL IMAGE
COPY --from=intermediate /home/murphylab /home/murphylab

# INSTALL CELLORGANIZER FOR PYTHON
# RUN ln -s /usr/local/bin/python3 /usr/local/bin/python
RUN mkdir /scratch
RUN cd /home/murphylab/cellorganizer-python && python setup.py install
RUN rm -rf /home/murphylab/cellorganizer-python

# add version txt
ADD cellorganizer-python/cellorganizer/version.txt /opt/conda/lib/python3.7/site-packages/cellorganizer/version.txt

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
