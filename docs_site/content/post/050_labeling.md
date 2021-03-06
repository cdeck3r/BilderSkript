+++
title = "Labeling"
description = "Generate training data"
date = "2020-01-05"
author = "Christian Decker"
sec = 50
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

This activity assigns names or descriptors to components within an image. Any supervised ML algorithm requires labeled data for training. Successfully trained on the labeled data, the ML algorithm is afterwards enabled to identify and name similar components in images which do not have labels.

Labeling is usually done manually. A user marks regions within images and assigns labels therewith identifying objects in the image. Labeled data is not questioned and provides the algorithm with ground truth data. 

**Problem**

> BilderSkript delivers images from various lectures. We will need to repeat the labeling process to find appropriate features which let the ML based object identification algorithm generalize sufficiently well in order to identify objects in recordings from other lectures.

### Tool Support

Labeling objects within images has a long history in the computer vision research community. For ML-based products there are a couple of online services available which support labeling activties distributed across a crowd workers, integrate semi-automated quality checks and other functions when it come to large-scale applications.

Quora list not-complete list of labeling tools and services; some are comercial, some are open-source. Check out https://www.quora.com/What-is-the-best-image-labeling-tool-for-object-detection.

For BilderSkript we found the following open tools tools attractive and discuss them briefly.

* [ImgLab](https://github.com/NaturalIntelligence/imglab): web based tool; Online service for immediate use available under https://imglab.in
* [LabelImg](https://github.com/tzutalin/labelImg): the classic one, often mentioned on towardsdatascience.com. Google finds [approx. 45 hits](https://www.google.com/search?client=firefox-b-d&ei=bDQSXqO0GYPVkwXNm6W4CA&q=%22labelimg%22+site%3Atowardsdatascience.com&oq=%22labelimg%22+site%3Atowardsdatascience.com&gs_l=psy-ab.3...24037.25167..25364...0.2..0.96.176.2......0....1..gws-wiz.......0i71.uuzGcOFEKy4&ved=0ahUKEwijmq3DlO3mAhWD6qQKHc1NCYcQ4dUDCAo&uact=5). It is a desktop tool. 
* [Alp's Labeling Tool (ALT)](https://alpslabel.wordpress.com/): more than just a labeling tool; it's a desktop tool for Windows as well as Linux / Ubuntu.
* [Computer Vision Annotation Tool (CVAT)](https://github.com/opencv/cvat): web based online tool. Works with videos, too. Apart from the web GUI, there is also a REST API to programmatically access the tool. 

### ImgLab to annotate Labels

BilderSkript utilizes the [ImgLab](https://github.com/NaturalIntelligence/imglab) for label annotations. The web based tool exports label annotation in multiple formats 

* dlib XML
* dlib pts
* Pascal VOC: [standardized](http://host.robots.ox.ac.uk/pascal/VOC/), however, the annotation data export only works for the current image. One needs to proceed to next image to export the next image's annotation.
* COCO: [standardized](http://cocodataset.org/#format-data), however, the exportet annotation text seems to be incomplete

The dlib XML format originates from the [dlib toolkit](http://dlib.net/) containing various machine learning algorithms. Here is an [example using the python API](https://handmap.github.io/dlib-classifier-for-object-detection/) for using dlib tools.

The XML format is reduced to the very basic tags required. An example is shown below.

```XML
<?xml version='1.0' encoding='ISO-8859-1'?>
<?xml-stylesheet type='text/xsl' href='image_metadata_stylesheet.xsl'?>
<dataset>
<name>dlib face detection dataset generated by ImgLab</name>
<comment>
    This dataset is manually crafted or adjusted using ImgLab web tool
    Check more detail on https://github.com/NaturalIntelligence/imglab
</comment>
<images>	<image file='IMG_20191219_094800_001_flat_pc_resize_mirror.png'>
		<box top='36' left='119' width='278' height='208'>
			<label>slide</label>
		</box>
		<box top='31' left='-2' width='206' height='319'>
			<label>person</label>
		</box>
	</image>
	<image file='IMG_20191219_094802_002_flat_pc_resize_mirror.png'>
		<box top='44' left='1' width='204' height='304'>
			<label>person</label>
		</box>
	</image>
</images></dataset>
```

### BilderSkript Labels

We create rectangular shapes and define the following labels to annotate the shapes:

* <tbd>
* <tbd>

