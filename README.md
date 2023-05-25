# SpheroidSegmentation_With_ResNet101

This repository contains functions implemented in MATLAB for training various segmentation neural networks, for spheroid segmentation using the trained neural networks and for evaluating the quality of the segmentation performed. 
This code is included in the AnaSP software that is free to download at https://sourceforge.net/projects/anasp/
The implemented segmentation networks that are trainable are VGG16, VGG19, ResNet18, ResNet50 and ResNet101. 

## Introduction

Today, more and more biological laboratories use 3D cell cultures and tissues grown in vitro as a 3D model of in vivo tumors and metastases. In the last decades, it has been extensively established that multicellular spheroids represent an efficient model to validate the effects of drugs and treatments for human care applications. However, a lack of methods for quantitative analysis limits the use of spheroids as models for routine experiments. Several methods have been proposed in the literature to perform high-throughput experiments employing spheroids by automatically computing different morphological parameters, such as diameter, volume, and sphericity. Nevertheless, these systems are typically grounded in expensive automated technologies that make the suggested solutions affordable only for a limited subset of laboratories that frequently perform high-content screening analyses. 
The aim of this project is to implement an automatic way to segment brightfield spheroid images acquired with a standard widefield microscope based on convolutional neural networks.
This automated method has been incorporated into the already existig AnaSP software, that is an open-source software suitable for automatically estimating several morphological parameters of spheroids. Its modular architecture and graphical user interface make it attractive for researchers who do not work in areas of computer vision and suitable for both high-content screenings and occasional spheroid-based experiments.

## Repository Contents


- `gitattributes`

- `gitignore` containing file types that are not trakced by git.

- `FUNC.m` containing the function necessary to the main code.

- `Main.m` example code that explains how to use the project.

- `metric_evaluation.m` containing the function responsible of evaluating the quality of the  performed segmentation.

- `Network_Training.m` containing the function responsible of training new segmentation neural networks.

- `ResNet101_Seg.m` containing the function responsible of generating the segmentation network based on the convolutional neural network ResNet101.

- `segmentation_multiple_images.m` containing the function responsible of performing the segmentation of spheroid images using the trained neural network.



## Installation

To clone the git repository, type the following commands from terminal:

```         
git clone https: https://github.com/MariachiaraStellato/SpheroidSegmentation_With_ResNet101
cd SpheroidSegmentation_With_ResNet101
```

To run the functions used it is necessary to have the deep learning toolbox installed on matlab. You can check if you already have it by writing in your MATLAB command line:

```         
ver('Deep Learning Toolbox')
```
If it is not installed, you can instal and/or purcase it at the following link: 
https://it.mathworks.com/products/deep-learning.html

It is also necessary to install some required packages. They can be found at the following links:

- VGG16: https://it.mathworks.com/matlabcentral/fileexchange/61733-deep-learning-toolbox-model-for-vgg-16-network

- VGG19: https://it.mathworks.com/matlabcentral/fileexchange/61734-deep-learning-toolbox-model-for-vgg-19-network
- ResNet18: https://it.mathworks.com/matlabcentral/fileexchange/68261-deep-learning-toolbox-model-for-resnet-18-network

- ResNet50: https://it.mathworks.com/matlabcentral/fileexchange/64626-deep-learning-toolbox-model-for-resnet-50-network

To test if all the functions are correctly working you can write in the MATLAB command line: 

```         
results = runtests('tests');
```


