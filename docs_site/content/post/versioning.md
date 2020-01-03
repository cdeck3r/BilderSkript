+++
title = "Versioning and Repository Management"
description = "Versioning and repo management"
date = "2019-12-29"
author = "Christian Decker"
sec = 85
+++

## Pipeline Code and Data Versioning

The `builder` image takes care of versioning using [git]() and [dvc]().

Pipelines are commonly shared in various volumes. 

## Repository Management

The [project's repository](https://github.com/cdeck3r/BilderSkript) is mounted as separate volume in the `builder` container. As a consequence, only makefiles in the project's root dir are able to commit changes to the repository. Scripts in subdirectories are not aware that the project's root is under git version control. The volumes are organized under the following two mount points.

**Mount point: `/BilderSkriptRepo`**

Scripts which perform pipeline and data versioning start under this mount point. It contains all files and  directories from the project repository:

* `.git/`
* `Dockerfiles/`
* ...
* `docker_compose.yml`
* `README.md`

**Mount point: `/bilderskript`**

Scripts which actually execute pipelines start under this mount point. It contains the following directories:

* `docs/`
* `docs_site/`
* `images/`
* `scripts/`
* `src/`