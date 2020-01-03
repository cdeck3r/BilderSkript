+++
title = "Documentation Generation"
description = "Docu blog"
date = "2019-12-29"
author = "Christian Decker"
sec = 90
+++

## Docu Blog

The project's documentation is a form of a single-page blog using the [Hugo](https://gohugo.io/) static webpage generator. It lists notes taken during the development and justifies design decisions. The `builder` docker image takes care of the generation utilizing the script, `scripts/make_doc.sh`.

The blog utilizes the [OneDly theme](https://github.com/cdeck3r/OneDly-Theme). This theme is excluded from git versioning because it originates from a separate repository. Usually, one would include it as a [git submodule](https://git-scm.com/docs/git-submodule). However, if it is not present during the runtime of `make_doc.sh`, script will download a copy from the current master branch and places it into the theme subdirectory of the project's `doc_site` directory. Using git is not possible at this moment as the `make_doc.sh` script is not aware that the project directory is under git version control.

The docu blog is available under http://cdeck3r.com/BilderSkript/.
