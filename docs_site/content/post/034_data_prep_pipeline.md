+++
title = "[data_prep.snakefile] Pipeline"
description = "Preparing the images from the 360 camera"
date = "2020-03-05"
author = "Christian Decker"
sec = 34
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

The data preparation pipeline, `data_prep.snakefile`, comprises of two phases

1. Configure the pipeline's parameters
    * `config.yaml` defines pipeline specific parameters
    * `datasets.csv` defines the data input and data-specific processing parameters
1. Run the pipeline on the images from the lecture recording

     
### 1. Configuration

The following activity diagram describes the steps to configure the data preparation pipeline. Configuration is stored in `config.yaml` and `dataset.csv`.

**Precondition:**

* `builder` and `hugin-vnc` container up and running
* at least one image from lecture recording available

**Postcondition:**

* images directories set
* `.pto` files created 
* (optionally) crop specification defined

The parameter values from above need to be stored in the `config.yaml` and `dataset.csv` file. The activity diagram indicates to which file each parameter belongs to.

**Commands**

Spin up the `hugin-vnc` container.

```bash
docker-compose up -d hugin-vnc
```

Afterwards, use a vnc client to get Hugin's display and create the `.pto` files. Modify the pipeline's `dataset.csv` and `config.yaml` to tell the scripts where to look for the files. The activity diagram below displays the steps to create the files.

<img src="uml/data_prep_config.png" alt="data prep configuration" width="65%" />

### 2. Run the Pipeline

Finally, the engineer starts the data prep pipeline and the pipeline processes the input images from the *img_dir* and places it in the *out_dir*.

**Precondition:**

* `builder` and `hugin` container up and running
* `.pto` files created
* *img_dir* and *out_dir* image directories set

Parameter values from above are sourced from the the `dataset.csv` file.

**Postcondition:**

* images processed placed in *out_dir*

**Pipeline Start**

The following commands start the pipeline. The activity diagram belows depicts the details of the pipeline run.

Spin up the `builder` and `hugin` container and get an interactive shell to the `builder` container.

```bash
docker-compose up -d builder hugin
docker exec -it bilderskript_builder_1 /bin/bash
```

Within the `builder` container run 

```bash
cd BilderSkript/pipelines
./data_prep.sh
```


<img src="uml/data_prep_run.png" alt="data prep run" width="75%" />