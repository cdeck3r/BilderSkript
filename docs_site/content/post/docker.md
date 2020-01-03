+++
title = "Docker Container Toolchain"
description = "Technical system design"
date = "2019-12-29"
author = "Christian Decker"
sec = 30
+++


Docker images contain the various software pipelines from the tool chain. The various responsibilities within the overall system design motivate the system boundaries induced by the distribution of pipelines across docker images. The following table list the docker images and their respective pipeline functionalities.

| Image         | Pipeline      | Notes  		|
| ------------- | ------------- | ------------- |
| builder       | Build 		| makefile, doc, versioning via git and dvc, mlflow exp.|
| hugin      	| Data prep     | image data preparation |
| ludwig 		| ML training   | training and experimentation |
| cicd			| Deployment pipeline | not yet implemented |


... pipeline

