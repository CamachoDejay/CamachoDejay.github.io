---
title: "Mapping Transient Protein Interactions at the Nanoscale in Living Mammalian Cells"
layout: post
date: 2018-09-11 10:00
image: /assets/images/ACSnano/ACSnanoSusana.jpeg
headerImage: true
hidden: false
tag:
- Localization Microscopy
- Super-resolution
- Particle Localization
- Image simulation
star: false
category: blog
author: rafa
description: presentation of our article "Mapping Transient Protein Interactions at the Nanoscale in Living Mammalian Cells" by H. De Keersmaecker, R. Camacho, D. M. Rantasa, E. Fron, H. Uji-i, H. Mizuno, S. Rocha, ACS Nano 2018, acsnano.8b01227.
externalLink: true
---

[![imageTOC](/assets/images/ACSnano/ACSnanoSusana.jpeg "TOC")](https://pubs.acs.org/doi/10.1021/acsnano.8b01227)
[Link to the ACSnano article](https://pubs.acs.org/doi/10.1021/acsnano.8b01227)
## Abstract
Protein-protein interactions (PPIs) form the basis of cellular processes, regulating cell behavior and fate. PPIs can be extremely transient in nature, which hinders their detection. In addition, traditional biochemical methods provided limited information on the spatial distribution and temporal dynamics of PPIs, crucial for their regulation in the crowed cellular environment. Given the pivotal role of membrane micro- and nano-domains in the regulation of PPIs at the plasma membrane, the development of methods to visualize PPIs with a high spatial resolution is imperative. Here we present a super-resolution fluorescence microscopy technique that can detect and map short-lived transient protein-protein interactions on a nanometer scale in the cellular environment. This imaging method is based on single molecule fluorescence microscopy and exploits the effect of the difference in the mobility between cytosolic and membrane-bound proteins in the recorded fluorescence signals. After a proof-of-concept using a model system based on membrane-bound modular protein domains and fluorescently labeled peptides, we applied this imaging approach to investigate the interactions of cytosolic proteins involved in the epidermal growth factor signaling pathway, namely Grb2, c-Raf and PLCγ1. The detected clusters of Grb2 and c-Raf were correlated with the distribution of the receptor at the plasma membrane. Additionally, the interactions of wild type PLCγ1 were compared to those detected with truncated mutants, which provided important information regarding the role played by specific domains in the interaction with the membrane. The results presented here demonstrate the potential of this technique to unravel the role of membrane heterogeneity in the spatio-temporal regulation of cell signaling.


## MATLAB implementation for the simulations used in the article
The implementation can be found [here](https://github.com/CamachoDejay/diffusion_binding_simulations)

### Diffusion of single particles:
We simulated molecules diffusing linearly along the focal plane. The distance traveled by each molecule depends on the frame exposure and the diffusion speed. We generate the image via the following approximation: the molecule’s trajectory was sampled at 4ms time resolution. Then the particle’s point-spread-function (PSF) was placed at each of the sampled positions. Then the “motion blurred” image can be calculated by sampling this.

To calculate the PSF of a single particle we implemented the [PSF Generator from the Biomedical Imaging Group at EPFL]( http://bigwww.epfl.ch/algorithms/psfgenerator/). Note that each PSF is sampled according to the molecule’s brightness to obtain the number of counts per pixel on the imaging sensor. To approximate the noise properties of our detector (EMCCD camera) we measured the background level for each experimental condition and approximated it via a Gaussian model.

![image1](/assets/images/ACSnano/Diff.svg "Diffusion example")

### Binding of particles to target site:
Further we simulated the interaction between a protein diffusing in the cytosol and a protein-binding pocket at the plasma membrane. This process was simulated by considering the following steps: (1) a fluorescent protein diffuses towards a pocket and binds with certain time constant; (2) Once bound, the molecule becomes fluorescent with a limited survival time on the “bright” state - given by the quenching time. (3) The molecule (bright or bleached) leaves the binding site. (4) The pocket becomes available once again. All this considered, we calculate the fraction of each camera frame in which the binding pocket was occupied by a bright fluorescent label, and use this information to generate the frame’s image.

200 ms | 100 ms | 50 ms
------------ | ------------- | ------------- |
<img src="/assets/images/ACSnano/pocket_200_exp_30.gif" width="90" height="90"> | <img src="/assets/images/ACSnano/pocket_100_exp_30.gif" width="90" height="90">  | <img src="/assets/images/ACSnano/pocket_50_exp_30.gif" width="90" height="90"> |  
