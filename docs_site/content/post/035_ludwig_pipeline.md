+++
title = "[ludwig.snakefile] Pipeline for Blackboard Classification"
description = "Classify the blackboard's state of writing"
date = "2020-03-05"
author = "Christian Decker"
sec = 35
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

The `ludwig.snakefile` pipeline takes blackboard images as input and assigns labels like full, partial, empty. It indicates the whether the writing on the blackboard fills out the blackboard completely, partially, or alternatively, the blackboard is empty.