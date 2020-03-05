+++
title = "Documentation Generation"
description = "Docu blog"
date = "2019-12-29"
author = "Christian Decker"
sec = 90
+++

### Docu Blog

The project's documentation is a form of a single-page blog using the [Hugo](https://gohugo.io/) static webpage generator. It lists notes taken during the development and justifies design decisions. The `builder` docker image takes care of the generation utilizing the `snakemake` script, [`pipelines/doc.snakemake`](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/doc.snakemake).

The blog utilizes the [OneDly theme](https://github.com/cdeck3r/OneDly-Theme). This theme is excluded from git versioning because it originates from a separate repository. One include it as a [git submodule](https://git-scm.com/docs/git-submodule). 

```
cd docs_site
git add submodule https://github.com/cdeck3r/OneDly-Theme.git themes/onedly
```

The pipeline `doc.snakemake` generates the complete documentation calling

```
cd /bilderskript/pipelines
snakemake -s doc.snakemake
```

The docu blog is available under http://cdeck3r.com/BilderSkript/.
