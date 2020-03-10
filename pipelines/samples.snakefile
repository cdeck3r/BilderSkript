#
# This snakefile randomly selects input images 
# to create reduced samples set from each lecture recording.
#
# Author: cdeck3r
#

import pandas as pd
import os, random
from collections import namedtuple
from itertools import zip_longest

# select the dataset for processing
# see config.yaml 
num_samples=config["samples"]["num_samples"]
samples_seed=config["samples"]["seed"]
SAMPLES_DIR=os.path.abspath(os_path(config["samples"]["samples_dir"]))
IMAGES_DIR=os_path(config["dirs"]["images_dir"])

#datasets = pd.read_table("datasets.csv", sep=";")
#num_samples = 2
#samples_seed=1234
#SAMPLES_DIR="/bilderskript/images/samples"
#IMAGES_DIR="/bilderskript/images"

"""
    Samples image files from directories and returns them as list of tuples with their respective directory name for each image
"""
def image_samples():
    # we need reproducibility 
    random.seed(samples_seed)
    imgsamples=list()

    sampleimage = namedtuple("sampleimage", ["imgdirname", "imgfile"])
    for index, row in datasets.iterrows():
        try:
            img_dir = os.path.abspath(row["img_dir"])
            filelist = [x.name for x in os.scandir(img_dir) if x.is_file()]
            images = random.sample(filelist, min(num_samples, len(filelist)))
            imgdirname = os.path.basename(img_dir)
        except FileNotFoundError:
            continue
        for d, f in zip_longest([imgdirname],images, fillvalue=imgdirname):
            s=sampleimage(imgdirname=d, imgfile=f)
            imgsamples.append(s)
    return imgsamples

# collect the output files
rule samples:
    input:
        expand(SAMPLES_DIR + "/{imgs.imgdirname}" + "/{imgs.imgfile}", imgs=image_samples())

rule copy_sample_image:
    input:
        IMAGES_DIR + "/{imagedirname}" + "/{imgfile}"
    output:
        SAMPLES_DIR + "/{imagedirname}" + "/{imgfile}"
    message:
        "Copy randomly selected image"
    shell:
        "cp \"{input}\" \"{output}\""