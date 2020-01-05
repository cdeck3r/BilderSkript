+++
title = "Project Definition"
description = "Goals, objectives and approach"
date = "2019-12-29"
author = "Christian Decker"
sec = 2
+++

### Motivation and Goal

A lecturer usually provides a lot of supplemental course material such as a written script, slides, reading material, exercises. 

However, students visiting the course's lecture experience an additional channel, which helps them to sort and weight the supplemental material. The way how a lecturer presents the content will let attendees realize the weight and importance of certain parts of the content. Hence, it supports the creation of a red thread throughout entire supplemental material.

In contrast to full lecture recording, the BilderSkript approach condenses the recording to find those parts within a lecture which contribute to the understanding of the supplemental material.

Primarily, BilderSkript aims at course attendees, however, it could also be valuable for remote attentees.

BilderSkript has the following goals

* re-create partially the course experience
* support attenting students to follow-up on the content
* support students who have not attended all lessions to catch-up on the course
* improve the efficiency when working with the supplemental course material


### Objectives

There are a couple of activities to perform 

* record lectures as a sequence of wide angle still images
* train a computer to identify objects within still images
* define a metric of interestingness from the sequence of recognized objects 
* extract interesting images and compile a lecture notebook from which ultimately creates the BilderSkript

### Research Questions

BilderSkript relies on widely available open-source ML software. However, there are a couple of interesting research questions on the way.

* **How to automate image preprocessing?** - Image recording activity does not happen in a controlled environment, i.e. lecture rooms changes, light varies, camera postions are not fixed (resulting in varying field of views), varying colors of background, cloths etc.
* **Transfer learning?** - object identfication ... trained on labeled data from one lecture, apply model to different lecture ... relates to transfer learning?