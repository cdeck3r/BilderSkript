#
# This docker image contains 
# * python3
# * git, dvc
# * mlflow
# * supplemental: hugo, slackr, plantuml
#

FROM ubuntu:18.10

MAINTAINER cdeck3r

ENV SUPPLEMENTAL_DIR=/opt/builder \
    INSTALL_SCRIPT=install_builder_supplementals.sh

USER root

#
# add other things if required
#

#
# standard tools
#
RUN apt-get update && apt-get install -y \
        build-essential \
        default-jre \
        socat iproute2 lsof \
        python3 python3-pip python3-setuptools \
        libxml2-dev libxslt-dev python3-dev python3-lxml \
        git \
        curl \
        wget \
        unzip \
        graphviz libgraphviz-dev pkg-config \
        imagemagick imagemagick-doc \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

#
# data science tools
#
RUN	pip3 install \
    dvc \
    snakemake \
    mlflow \
    pygraphviz \
    pygments

#
# supplemental software
#
COPY ${INSTALL_SCRIPT} /tmp
RUN mkdir -p ${SUPPLEMENTAL_DIR} \
    && cp /tmp/${INSTALL_SCRIPT} $SUPPLEMENTAL_DIR \
    && ${SUPPLEMENTAL_DIR}/${INSTALL_SCRIPT}

WORKDIR ${SUPPLEMENTAL_DIR}

CMD ["/bin/bash"]