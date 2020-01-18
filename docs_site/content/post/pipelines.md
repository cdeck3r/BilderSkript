+++
title = "Pipelines"
description = "Pipelines as fundamental functions"
date = "2020-01-04"
author = "Christian Decker"
sec = 32
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

Pipelines are the fundamental building blocks of the BilderSkript system. 

### Pipeline Definitions

The term pipeline is heavily used in machine learning (ML). It generally refers to a sequence of steps to run in order to perform transformations. There are various kinds of pipelines, e.g. data pipelines, machine learning pipelines, deployment pipelines and others. Depending on the pipeline type, it takes a a certain ressource type as input and produces output ressources by the application of the pipeline's transformation steps. For instance, a data pipeline takes data files as an input and prepares them to be fed into a machine learning algorithm of the ML pipeline.

BilderSkript stores pipelines in the `pipelines` volume usually accessed under `/bilderscript/pipelines`. They are encoded as snakemake makefiles for version control.

### Snakemake

[Snakemake](https://snakemake.readthedocs.io/en/stable/) is a workflow management system to implement data analysis pipelines.

Snakemake compares the input and output ressources. These ressources are files. If the modification date of any of the input files is newer than the output file, snakemake runs the shell command. This behavior is encoded as rules, which transform input files into output files. All rules of a pipeline are defined in a snakefile. We list some important snakemake commands.

Run the snakemake pipeline
```bash
snakemake -s <snakefile>
```

Generate a report
```bash
snakemake -s <snakefile> --report <snakefile.html>
```

Generate a summary table displaying the current state of input and output files.
```bash
snakemake -s <snakefile> --summary
```

Before the snakefile is run, snakemake generates a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph) which shows the dependencies. This command visualizes the DAG.
```bash
snakemake -s <snakefile> --dag | dot -Tpng > snakefile.png
```


### Important BilderSkript Pipelines

The pipelines are named after their snakefile.

* **[doc.snakefile](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/doc.snakefile):** describes the pipeline for documentation generations. You may view the pipeline's [report](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/doc.snakefile.html).

* **[data_prep.snakefile](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.snakefile):** prepares the image files for the ML pipeline. It's a complex pipeline because it utilizes interprocess communication (IPC) with the `hugin` container. `data_prep.snakefile` requires the following parameters:
    * imgdir: the directory where the camera images are located
    * outdir: the directory where prep'ed images as a result of the pipeline execution are stored

    The pipeline's default behavior is started by the [`data_prep.sh`](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.sh) script. The pipeline's DAG is shown in [`data_prep.snakefile.png`](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.snakefile.png)


### Data Prep Pipeline

The data preparation pipeline comprises of two phases

1. Configure the pipeline's parameters
1. Run the pipeline on the images from the lecture recording

#### 1. Configuration

The following activity diagram describes the steps to configure the data preparation pipeline.

**Precondition:**

* `builder` and `hugin` container up and running
* at least one image from lecture recording available

**Postcondition:**

* images directories set
* `.pto` files created 

<img src="uml/data_prep_config.png" alt="data prep configuration" width="65%" />

#### 2. Run the Pipeline

Finally, the egnineer starts the data prep pipeline and the pipeline processes the input images from the _imgdir_ and places it in the _outdir_.

**Precondition:**

* `builder` and `hugin` container up and running
* `.pto` files created
* _imgdir_ and _outdir_ image directories set

**Postcondition:**

* images processed placed in _outdir_

<img src="uml/data_prep_run.png" alt="data prep run" width="75%" />


### Doc Pipeline

This pipeline generates 

1. UML diagrams using [plantuml](https://plantuml.com/en/)
1. the project's website using [hugo](https://gohugo.io/)

Run the pipeline in `/bilderskript/pipelines`

```bash
snakemake doc
```
