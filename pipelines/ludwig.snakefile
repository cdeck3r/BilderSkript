#
# This makefile is for BilderSkript's image classification
# It calls Uber's ludwig for each model and a set of image files
#
# Author: cdeck3r
#

#
# some global variables
#
LOG_DIR=os_path(config["dirs"]["log_dir"])

# select the model for prediction
# and some info from the dataset 
# see config.yaml 
try:
    # allow overwrite via command line
    models_idx=config["models_idx"]
except:
    models_idx=config["ludwig"]["models_idx"]
models_row=models.loc[models_idx]
datasets_row=datasets.loc[config["data_prep"]["datasets_idx"]]

#
# ludwig specific params
#
LUDWIG_CMD=os_path(config["ludwig"]["ludwig_cmd"])

#
# config parameters
#
LUD_DATASET_NAME=str(datasets_row["lecture_date"]) \
                + "_" \
                + datasets_row["lecture"]
LUD_OUT_DIR=os.path.abspath(os_path(config["ludwig"]["out_dir"]) \
                + "/" \
                + LUD_DATASET_NAME \
                + "/" \
                + "results_model_" + str(models_idx) )
LUD_IMG_DIR=os.path.abspath(os_path(config["data_prep"]["out_dir"]))
LUD_IMG_DIR_FILTER=os.path.abspath(os_path(config["data_prep"]["out_dir"])+"_filter")
LUD_DATA_DIR=os.path.dirname(LUD_OUT_DIR)
LUD_MODEL_PATH=os.path.abspath(models_row["model_path"])
IMG_FILTER_SPEC=models_row["img_filter_spec"]
LUD_PRED_HDR='image_path,class_label,class_probability,UNK_prob,empty_prob,full_prop,partial_prob'

##########################
#
# Main rules
#
##########################


# collect all image files to specify {imgfile} variable for all target files 
LUD_IMG_FILES, = glob_wildcards(LUD_IMG_DIR + "/{imgfile}.png")

# a pseudo-rule that collects the target files
rule ludwig:
    input:
        LUD_OUT_DIR + "/prediction.csv"
        

# apply filter to each image as 
# pre-processing for image classification
rule filter_image:
    input:
        LUD_IMG_DIR + "/{imgfile}.png"
    output:
        temp(LUD_IMG_DIR_FILTER + "/{imgfile}_filter.png")
    message: 
        "Ludwig processing (filter image)"
    shell:
        "convert {IMG_FILTER_SPEC} {input} {output}"


# create data_csv file for ludwig
rule ludwig_data_csv:
    input:
        expand(LUD_IMG_DIR_FILTER + "/{imgfile}_filter.png", imgfile=LUD_IMG_FILES)
    output:
        LUD_DATA_DIR + "/data_csv.csv"
    params:
         logfile=LOG_DIR + "/ludwig.log"
    message: 
        "Ludwig processing (create data_csv)"
    run:
        with open(output[0], "w+") as datacsv:
            # header 
            datacsv.write("image_path\n")
            # content: one file path per line
            for f in input:
                datacsv.write("%s\n" % f)


# predict images in data_csv 
rule ludwig_predict:
    input:
        rules.ludwig_data_csv.input,
        data_csv = LUD_DATA_DIR + "/data_csv.csv"        
    output:
        LUD_OUT_DIR + "/class_predictions.csv",
        LUD_OUT_DIR + "/class_probability.csv",
        LUD_OUT_DIR + "/class_probabilities.csv"
    params:
         logfile=LOG_DIR + "/ludwig.log"
    message: 
        "Ludwig processing (predict data)"
    shell:
        "{LUDWIG_CMD} \"{input.data_csv}\" \"{LUD_MODEL_PATH}\" \"{LUD_OUT_DIR}\" \"{params.logfile}\""

# strip header from data_csv.csv
# and obtain img_src.csv
rule img_src:
    input:
        LUD_DATA_DIR + "/data_csv.csv",
        rules.ludwig_predict.output
    output:
        LUD_OUT_DIR + "/img_src.csv"
    shell:
        "sed '1d' {input[0]} > {output}"
        
# join the data_csv file with the prediction results files
rule join_data_and_results:
    input:
        rules.img_src.output, 
        rules.ludwig_predict.output
    output:
        LUD_OUT_DIR + "/prediction.csv"
    params:
         logfile=LOG_DIR + "/ludwig.log"
    message: 
        "Join data_csv and results (join data)"
    shell:
        "paste -d , {input} | tr -d '\r' > {output} \
        && sed -i 1i\"{LUD_PRED_HDR}\" {output}"
    