+++
title = "Docker Container Toolchain"
description = "Technical system design"
date = "2019-12-29"
author = "Christian Decker"
sec = 30
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

### Docker Images and Volumes

Docker images contain the various software pipelines from the tool chain. The  responsibilities within the overall system design motivate the system boundaries induced by the distribution of pipelines across docker images. The following table list the docker images and their respective pipeline functionalities.

| Image         | Pipeline      | Notes         |
| ------------- | ------------- | ------------- |
| vscode        | n/a           | IDE VS code   |
| builder       | Build         | makefile, doc, versioning via git and dvc, mlflow exp.|
| hugin         | Data prep     | image data preparation using [hugin](http://hugin.sourceforge.net/) |
| hugin-vnc     | n/a           | like hugin, but provides VNC server for GUI interaction |
| mrcnn         | ML training   | object detection |
| ludwig        | ML training   | classification |
| cicd          | Deployment pipeline | not yet implemented |


When started as docker containers, they run scripts and communicate with each other utilizing shared volumes on the filesystem. The image below illustrates the docker toolchain.

<img src="uml/docker_toolchain.png" alt="docker toolchain" />
  
The most important volumes are:

* ${APP_ROOT}/ipc : used to store sockets for IPCs between containers 
* ${APP_ROOT}/pipelines : contains all BilderSkript pipelines
* ${APP_ROOT}/images : data directory
* ${APP_ROOT}/src : stores source codes
* ${APP_ROOT}/scripts : scripts 
* ${APP_ROOT}/ludwig : stores experiments, models and prediction 
* ${APP_ROOT}/vscode : maintains the state of VS code
* ${APP_ROOT}/docs :  github's webserver serves the docu blog from this directory
* ${APP_ROOT}/docs_site : the docu blog's source

By default `${APP_ROOT}` is set to `/bilderskript`. For instance, one accesses the pipeline scripts under `/bilderskript/pipelines`.

### Build and Startup

[Docker Compose](https://docs.docker.com/compose/) creates all images, containers and volumes. The configuration is defined in the [docker-compose.yml](https://github.com/cdeck3r/BilderSkript/blob/master/docker-compose.yml) file

Building all images using the following command

```bash
docker-compose build
```

Start a container from `builder` image  and get a `bash` shell. The default container name is `bilderskript_builder_1`

```bash
docker-compose up -d builder
docker exec -it bilderskript_builder_1 /bin/bash
```
