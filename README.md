# BilderSkript

> Bilder [ˈbɪldɐ], (German), images

> Skript [skʁɪpt], (German), a written document or notes

BilderSkript automatically summarizes a lecture as a sequence of interesting images scenes.

Technically, it trains a deep neural net on objection recognition and extracts interesting scenes from a large sequence of still image recordings. Theses scenes compile to the BilderSkript.

The [project's website](http://cdeck3r.com/BilderSkript) records releveant discussions on design decisions and technologies. It provides insights for understanding the engineering behind BilderSkript. 

## Motivation and Goal

A lecturer usually provides a lot of supplemental course material such as a written script, slides, reading material, exercises. 

However, students visiting the course's lecture experience an additional channel, which helps them to sort and weight the supplemental material. The way how a lecturer presents the content will let attendees realize the weight and importance of certain parts of the content. Hence, it supports the creation of a red thread throughout entire supplemental material.

In contrast to full lecture recording, the BilderSkript approach condenses the recording to find those parts within a lecture which contribute to the understanding of the supplemental material.

Primarily, BilderSkript aims at course attendees, however, it could also be valuable for remote attentees.

BilderSkript has the following goals

* re-create partially the course experience
* support attenting students to follow-up on the content
* support students who have not attended all lessions to catch-up on the course
* improve the efficiency when working with the supplemental course material


## Objectives

There are a couple of activities to perform 

* record lectures as a sequence of wide angle still images
* train a computer to identify objects within still images
* define a metric of interestingness from the sequence of recognized objects 
* extract interesting images and compile a lecture notebook from which ultimately creates the BilderSkript

## Recording hardware

Wide-angle image recording is required to capture the lecturer's presentation. We use a [Insta360 ONE dual-fisheye camera](https://www.insta360.com/product/insta360-one/). While one lens overviews the lecturer's area, the lens pointing to the auditorium is covered to maintain privacy. 

Voice recording is intentionlly left out due to the preparation effort and the difficulty to produce recordings in a noisy and reverberant lecture hall. 