#
# This makefile generates for BilderSkript's documentation
#
# Author: cdeck3r
#


# project's root dir
PROJECT_DIR="/bilderskript"
# main tools installed by docker
SUPPLEMENTAL_DIR="/opt/builder"

#
# important global variables
#
DOCS_DIR=PROJECT_DIR + "/docs"
DOCS_SITE=PROJECT_DIR + "/docs_site"
HUGO=SUPPLEMENTAL_DIR + "/hugo/hugo"
PLANTUML_JAR=SUPPLEMENTAL_DIR + "/plantuml/plantuml.jar"

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
    params:
        docs={DOCS_DIR}
    shell:
        # generate doc
        "{HUGO} --cleanDestinationDir -v -s {DOCS_SITE} -d {params.docs}"

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
