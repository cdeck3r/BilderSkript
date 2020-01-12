+++
title = "Introductionary Example"
description = "Demostrates how BilderSkript works"
date = "2019-12-31"
author = "Christian Decker"
sec = 3
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

BilderSkript takes a series of still images as input and compiles visual lecture notes as output. 
Below we illustrate a step-by-step walkthrough how the software processes the data.

**Image recording:** A 360 camera records the entire room. However, the lens towards the audience is covered to maintain privacy. The images have the typical distorted appearance due to the camera's fisheye lenses. Nevertheless, it creates an approx. 200 degrees, wide-angle recording.

<img src="img/fisheye.jpg" alt="fisheye raw image" width="50%" />

**Image preparation:** The BilderSkript projects fisheye images as equirectangular images to correct for the distortion.

<img src="img/fisheye_flat.png" alt="fisheye equirectangular projections" width="50%" />

Finally, the perspective control corrects the deformation of vertical and horizontal lines when the camera records the projection wall or blackboard from an inclinded position.

<img src="img/fisheye_flat_pc.png" alt="perspective control" width="50%" />

**Object identfication:** In this step BilderSkript identifies typical objects, such as blackboard, lecturer, video projection, within each image. 

*tbd. include image*

**Sequencing:** Utilizing the object id, it transforms the set of images into a sequence of object compositions. A step consists of all identified objects in a single image. Please note, each step links back to the original image. 

*tbd. include image*

**Interesting sequences:** This steps only operates on the sequence of identified objects. Based on a definition on interestingness, it quantifies the previously created sequences on this metric. The idea is that interestingness emerges from changes in the composition of identified objects.

*tbd. include image*

**Compilation:** By the degree of interestingness BilderSkript applies a threshold to extract the best ones. Once it has found an interesting sequence, it links each step within this sequence back to its image where it originates from. Finally, it compiles the scene from these images.

*tbd. include image*