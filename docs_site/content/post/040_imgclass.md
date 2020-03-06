+++
title = "Train the Blackboard Image Classifier"
description = "Train an image classifier using Ludwig"
date = "2020-03-05"
author = "Christian Decker"
sec = 40
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

The image classifier detects the blackboard's state of writing. It is an interesting BilderSkript context to know whether the writing on the blackboard fills out the blackboard completely, partially, or alternatively, the blackboard is empty.

### Experiment

We learn a model, a classifier, which maps images to class labels, e.g. full, partial, empty.

* utilizes the Ludwig docker container
* runs from command line; 
* script tests whether the container already runs and if appropriate spins it up 
* utilizes [comet.ml](comet.ml) to store experiment results
* manually shutdown the container 

For utilizing [comet.ml](comet.ml) you need to provide a `.comet.env` file in the project's directory. The file conatins the API key and the comet's project name.

**Walkthrough**

Start an experiment from `scripts/ludwig`.

**STEP 1:** Prepare the input dataset

Precondition:

* `.png' images as input for training the model
* within the `<training image path>` directory the images are organized in subdirs, where subdir names are the class labels 
* experiment name, e.g. *stats_lecture*

Command:

```bash
./ludwig_experiment.sh datacsv <experiment name> <training image path>
```

Postcondition:

* directory created: `ludwig/experiements/<experiment name>`
* directory contains `<experiment name>.csv`, which links images to class labels

**STEP 2:** Learn the model

Precondition: see above

Command:

```bash
./ludwig_experiment.sh experiment <experiment name> <training image path>
```

Postcondition:

* Results available in `ludwig/experiements/<experiment name>/results` 
* [comet.ml](comet.ml) website contains experiment's results

**STEP 3:** Visualize and Shutdown

Precondition: the experiment name from above

Command:

```bash
./ludwig_experiment.sh visualize <experiment name> 
./ludwig_experiment.sh shutdown <experiment name> 
```

Postcondition:

* [comet.ml](comet.ml) website contains for addtional images from the experiment run
* the Ludwig container is removed.


### Multi Experiments

Multi experiements are repeated experiements which varying parameters. Particularly, we vary the parameters for the image pre-processing.

Start a multi experiment from `scripts/ludwig`. All directories created during an regular experiment are prefixed by `exp<num>_` indicating the run number within the multi experiment.

Precondition: 

* see initial preconditions of a single experiment 
* edit `ludwig_multi_experiments.sh` for 
    * training image path
    * parameters to to loop through

Command:

```bash
./ludwig_multi_experiments.sh <experiment root name>
```

Postcondition:

* directories with results created: `ludwig/experiements/exp<num>_<experiment root name>`
* [comet.ml](comet.ml) website contains all experiments' results


### Training Process

The following activity diagram illustrates the overall sequence of actions for running one or more experiments. The swimlane `Experiments` depicts all artifacts which relate to an experiment. When an experiment is repeated with different parameters the filtered images, the datacsv file and the resulting model are created under the new experiment name.

<img src="uml/ludwig_multi_exp" alt="Ludwig Multi Experiments" />
