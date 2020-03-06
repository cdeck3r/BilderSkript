+++
title = "BilderSkript Pipelines"
description = "Pipelines as fundamental functions"
date = "2020-02-24"
author = "Christian Decker"
sec = 33
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>


The BilderSkript pipelines follow the guidelines of [The Snakemake-Workflows project](https://github.com/snakemake-workflows/docs). There is a central `Snakemake` file which includes the configuration and the concrete workflows for the data and ML pipelines.

The workflow's design separates the pipeline specific parameters from the dataset specific ones. A separate file stores each parameter set

* `config.yaml` contains the pipeline specific parameters. This file exists only once and contains the parameters for all pipelines.
* `dataset.csv` stores the parameters relevant for the dataset a pipeline processes. There may be several of these files, one for each class of data for a pipeline. There is no fixed schema. The file's name depends on the content and the pipeline, which sources the file. A pipeline which processes various ML models may utilize a `models.csv` file to store the set of available models and additional parameters for each model.

The approach increases the flexibility to apply the pipelines to various datasets. The figure below depicts this separation

<img src="uml/workflow_design.png" alt="workflow design for all pipelines" />

The pipelines are named after their snakefile. All pipelines files stay in the `/bilderskript/pipelines` directory relative to the BilderSkript's project dir.

* **[doc.snakefile](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/doc.snakefile):** describes the pipeline for documentation generations. You may view the pipeline's [report](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/doc.snakefile.html).

* **[data_prep.snakefile](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.snakefile):** prepares the image files for the ML pipeline. It's a complex pipeline because it utilizes interprocess communication (IPC) with the `hugin` container. You may view the pipeline's [report](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.snakefile.html).
`data_prep.snakefile` requires parameters in `config.yaml`:
    * datasets_idx: line in `datasets.csv` defining the data to process
    * out_dir: the directory where prep'ed images as a result of the pipeline execution are stored

    The pipeline's default behavior is started by the [`data_prep.sh`](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.sh) script. The pipeline's rule DAG is shown in [`data_prep.snakefile.png`](https://github.com/cdeck3r/BilderSkript/blob/master/pipelines/data_prep.snakefile.png)

* **ludwig.snakefile:** detects the blackboard's state of writing, i.e. whether the writing on the blackboard fills out the blackboard completely, partially, or alternatively, the blackboard is empty. 

    The pipeline's default behavior is started by the [`ludwig.sh`]


Run the following script to create reports for all BilderSkript pipelines

```bash
snakemake_report.sh
```
