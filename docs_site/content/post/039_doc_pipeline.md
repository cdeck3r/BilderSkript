+++
title = "[doc.snakefile] Pipeline Generating the Blog"
description = "Creates the docu blog"
date = "2020-03-05"
author = "Christian Decker"
sec = 39
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>


The pipeline `doc.snakefile` generates 

1. UML diagrams using [plantuml](https://plantuml.com/en/)
1. the project's website using [hugo](https://gohugo.io/)

Run the pipeline from within the `builder` container in `/bilderskript/pipelines`

```bash
snakemake doc
```

Run the following script to create reports for all BilderSkript pipelines

```bash
snakemake_report.sh
```