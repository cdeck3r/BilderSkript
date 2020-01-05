#
# This makefile is for BilderSkript's data preparation
# It calls hugin for each input file
#
# Author: cdeck3r
#

import os

#
# some global variables
#
PROJECT_DIR="/bilderskript"
LOG_DIR=PROJECT_DIR + "/log"
SCRIPT_DIR=PROJECT_DIR + "/scripts"

HUGIN_CMD=SCRIPT_DIR + "/hugin/hugin.sh"
HUGIN_PTO_FILE=SCRIPT_DIR + "/hugin/image_fullframefish_equirectangular93x70.pto"
HUGIN_PTO_FILE_PERSPECTIVE=SCRIPT_DIR + "/hugin/perspective_control.pto"


#
# config parameters
# Usage: snakemake --config imgdir=../images/input outdir=../images/output width=500
#
IMG_DIR=" ".join( expand("{img_dir}", img_dir=config["imgdir"]) )
IMG_DIR=os.path.abspath(IMG_DIR)
OUT_DIR=" ".join( expand("{out_dir}", out_dir=config["outdir"]) )
OUT_DIR=os.path.abspath(OUT_DIR)
IMG_RESIZE_WIDTH=" ".join( expand("{resize_width}", resize_width=config["width"]) )

##########################
#
# Main rules
#
##########################


# collect all image files to specify {imgfile} variable for all target files 
IMG_FILES, = glob_wildcards(IMG_DIR + "/{imgfile}.insp")

# a pseudo-rule that collects the target files
rule all:
    input: 
         expand(OUT_DIR + "/{imgfile}_flat_pc_resize_mirror.png", imgfile=IMG_FILES)

# standard hugin run for fisheye correction
rule hugin:
    input:
         IMG_DIR + "/{imgfile}.insp"
    output:
         temp(OUT_DIR + "/{imgfile}_flat.png")
    params:
         logfile=LOG_DIR + "/data_prep.log"
    message: 
        "Hugin image processing (fisheye correction)"
    shell:
        "{HUGIN_CMD} \"{HUGIN_PTO_FILE}\" \"{input}\" \"{output}\" >> {params.logfile} 2>&1 "

# hugin run for perspective control
rule hugin_perspective:
    input:
        OUT_DIR + "/{imgfile}_flat.png"
    output:
        temp(OUT_DIR + "/{imgfile}_flat_pc.png")
    params:
         logfile=LOG_DIR + "/data_prep.log"
    message: 
        "Hugin image processing (perspective control)"
    shell:
        "{HUGIN_CMD} \"{HUGIN_PTO_FILE_PERSPECTIVE}\" \"{input}\" \"{output}\" >> {params.logfile} 2>&1 "

# resize the image 
rule img_resize:
    input:
        OUT_DIR + "/{imgfile}_flat_pc.png"
    output:
        temp(OUT_DIR + "/{imgfile}_flat_pc_resize.png")
    message:
        "Resize the image"
    shell:
        "convert -resize {IMG_RESIZE_WIDTH} \"{input}\" \"{output}\" "

# ... and mirror it
rule img_mirror:
    input:
        OUT_DIR + "/{imgfile}_flat_pc_resize.png"
    output:
        OUT_DIR + "/{imgfile}_flat_pc_resize_mirror.png"
    message:
        "Mirrow the image"
    shell:
        "convert -flop \"{input}\" \"{output}\"  "
