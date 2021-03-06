#
# This makefile generates for BilderSkript's documentation
#
# Author: cdeck3r
#

#
# variables from config.yaml
#
DOCS_DIR=os.path.join(*config["doc"]["docs_dir"])
DOCS_SITE=os.path.join(*config["doc"]["docs_site"])
HUGO=os.path.join(*config["doc"]["hugo"])
PLANTUML_JAR=os.path.join(*config["doc"]["plantuml_jar"])


#
# variables for files
#
# these are the files we check for modifications
POST_FILES, = glob_wildcards(DOCS_SITE + "/content/post/{postfile}.md")
# UML file creation
UML_FILES, = glob_wildcards(DOCS_SITE + "/content/uml/{umlfile}.txt")
# img files
IMG_FILES, = glob_wildcards(DOCS_SITE + "/content/img/{imgfile}")

# to generate the doc we need
# 1. all UML .png files from plantuml descriptions
# 2. all .md files
rule doc:
    input:
        expand(DOCS_SITE + "/content/uml/{umlfile}.png", umlfile=UML_FILES),
        expand(DOCS_SITE + "/content/post/{postfile}.md", postfile=POST_FILES),
        expand(DOCS_SITE + "/content/img/{imgfile}", imgfile=IMG_FILES),
        DOCS_SITE + "/content/imprint-gdpr/gdpr.md", 
        DOCS_SITE + "/content/imprint-gdpr/imprint.md", 
        DOCS_SITE + "/config.toml"
    output:
        DOCS_DIR + "/index.html"
    shell:
        # generate doc
        "{HUGO} --cleanDestinationDir -v -s {DOCS_SITE} -d {DOCS_DIR}"

# this rule generates the plantuml diagrams
rule plantuml:
     input:
        DOCS_SITE + "/content/uml/{umlfile}.txt"
     output:
        DOCS_SITE + "/content/uml/{umlfile}.png"
     params:
        outdir=DOCS_SITE + "/content/uml"
     shell:
        "java -jar {PLANTUML_JAR} -tpng -v -o {params.outdir} {input}"

