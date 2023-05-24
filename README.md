# SpheroidSegmentation_With_ResNet101

This repository contains functions implemented in MATLAB for training various segmentation neural networks, for spheroid segmentation using the trained neural networks and for evaluating the quality of the segmentation performed. 
This code is included in the AnaSP software that is free to download at https://sourceforge.net/projects/anasp/
The implemented segmentation networks that are trainable are VGG16, VGG19, ResNet18, ResNet50 and ResNet101. 

## Introduction

Today, more and more biological laboratories use 3D cell cultures and tissues grown in vitro as a 3D model of in vivo tumors and metastases. In the last decades, it has been extensively established that multicellular spheroids represent an efficient model to validate the effects of drugs and treatments for human care applications. However, a lack of methods for quantitative analysis limits the use of spheroids as models for routine experiments. Several methods have been proposed in the literature to perform high-throughput experiments employing spheroids by automatically computing different morphological parameters, such as diameter, volume, and sphericity. Nevertheless, these systems are typically grounded in expensive automated technologies that make the suggested solutions affordable only for a limited subset of laboratories that frequently perform high-content screening analyses. 
The aim of this project is to implement an automatic way to segment brightfield spheroid images acquired with a standard widefield microscope based on convolutional neural networks.
This automated method has been incorporated into the already existig AnaSP software, that is an open-source software suitable for automatically estimating several morphological parameters of spheroids. Its modular architecture and graphical user interface make it attractive for researchers who do not work in areas of computer vision and suitable for both high-content screenings and occasional spheroid-based experiments.

## Repository Contents


- 'gitattributes'

- 'gitignore' containing file types that are not trakced by git.

- 'FUNC' containing the function necessary to the main code.

- 'Main' example code that explains how to use the project.

- 'metric_evaluation' containing the function responsible of evaluating the quality of the  performed segmentation.

- 'Network_Training' containing the function responsible of training new segmentation neural networks.

- 'ResNet101_Seg' containing the function responsible of generating the segmentation network based on the convolutional neural network ResNet101.

- 'segmentation_multiple_images' containing the function responsible of performing the segmentation of spheroid images using the trained neural network.



## Installation


