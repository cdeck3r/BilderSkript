#
# This makefile is for BilderSkript's data preparation
# It calls hugin for each input file
#
# Author: cdeck3r
#

#
# some global variables
#
LOG_DIR=os_path(config["dirs"]["log_dir"])

# select the dataset for processing
# see config.yaml 
datasets_row=datasets.loc[config["data_prep"]["datasets_idx"]]

#
# hugin specific params
#
HUGIN_CMD=os_path(config["data_prep"]["hugin_cmd"])

#
# default HUGIN_PTO_FILE is <hugin_scripts>/<lecture_date>_<lecture>_flat.pto
#
pto_file=datasets_row["pto_flat"]
if pd.isnull(pto_file):
    HUGIN_PTO_FILE=os_path(config["data_prep"]["hugin_scripts"]) \
                    + "/" \
                    + str(datasets_row["lecture_date"]) \
                    + "_" \
                    + datasets_row["lecture"] \
                    + "_flat.pto"
else:
    HUGIN_PTO_FILE=pto_file

#
# default HUGIN_PTO_FILE_PERSPECTIVE is <hugin_scripts>/<lecture_date>_<lecture>_pc.pto
#
pto_file=datasets_row["pto_pc"]
if pd.isnull(pto_file):
    HUGIN_PTO_FILE_PERSPECTIVE=os_path(config["data_prep"]["hugin_scripts"]) \
                    + "/" \
                    + str(datasets_row["lecture_date"]) \
                    + "_" \
                    + datasets_row["lecture"] \
                    + "_pc.pto"
else:
    HUGIN_PTO_FILE_PERSPECTIVE=pto_file


#
# config parameters
# Usage: snakemake --config imgdir=../images/input outdir=../images/output width=500
#
IMG_DIR=os.path.abspath(datasets_row["img_dir"])
OUT_DIR=os.path.abspath(os_path(config["data_prep"]["out_dir"]))
IMG_RESIZE_WIDTH=config["data_prep"]["resize_width"]

#
# params for cropping
#
IMG_SUFFIX="flat_pc_resize_mirror"
CROP_SPEC=datasets_row["crop_spec"]


##########################
#
# Main rules
#
##########################


# collect all image files to specify {imgfile} variable for all target files 
IMG_FILES, = glob_wildcards(IMG_DIR + "/{imgfile}.insp")

# a pseudo-rule that collects the target files
rule data_prep:
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
        "Mirror the image"
    shell:
        "convert -flop \"{input}\" \"{output}\"  "


#
# special rule, not part of the default behavior
# creates additional cropped files 
#
rule crop:
    input:
        expand(OUT_DIR + "/crop/{imgfile}_" + IMG_SUFFIX + "_crop.png", imgfile=IMG_FILES)

rule img_crop_afile:
    input:
        OUT_DIR + "/{imgfile}_" + IMG_SUFFIX + ".png"
    output:
        OUT_DIR + "/crop/{imgfile}_" + IMG_SUFFIX + "_crop.png"
    message:
        "Crop the image"
    shell:
        "convert -crop {CROP_SPEC} \"{input}\" \"{output}\"  "
