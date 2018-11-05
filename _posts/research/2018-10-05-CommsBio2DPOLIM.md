---
title: "2D polarization imaging as a low-cost fluorescence method to detect α-synuclein aggregation ex vivo in models of Parkinson’s disease"
layout: post
date: 2018-10-05 10:00
image: /assets/images/CommsBio/FluoVsFret.png
headerImage: true
hidden: false
tag:
- Polarization Microscopy
- Protein aggregation
- alpha-synuclein
- FRET
star: false
category: blog
author: rafa
description: presentation of our article "2D polarization imaging as a low-cost fluorescence method to detect α-synuclein aggregation ex vivo in models of Parkinson’s disease" R. Camacho, D. Täuber, C. Hansen, J. Shi, L. Bousset, R. Melki, J.-Y. Li, I. G. Scheblykin, Communications Biololy 2018, 1, 157..
externalLink: true
---

[Link to the CommsBio article](https://www.nature.com/articles/s42003-018-0156-x)
## Abstract
A hallmark of Parkinson’s disease is the formation of large protein-rich aggregates in neurons, where α-synuclein is the most abundant protein. A standard approach to visualize aggregation is to fluorescently label the proteins of interest. Then, highly fluorescent regions are assumed to contain aggregated proteins. However, fluorescence brightness alone cannot discriminate micrometer-sized regions with high expression of non-aggregated proteins from regions where the proteins are aggregated on the molecular scale. Here, we demonstrate that 2-dimensional polarization imaging can discriminate between preformed non-aggregated and aggregated forms of α-synuclein, and detect increased aggregation in brain tissues of transgenic mice. This imaging method assesses homo-FRET between labels by measuring fluorescence polarization in excitation and emission simultaneously, which translates into higher contrast than fluorescence anisotropy imaging. Exploring earlier aggregation states of α-synuclein using such technically simple imaging method could lead to crucial improvements in our understanding of α-synuclein-mediated pathology in Parkinson’s Disease.
[![imageTOC](/assets/images/CommsBio/FluoVsFret.png "TOC")](https://www.nature.com/articles/s42003-018-0156-x)
Image from the accessory olfactory bulb of an α-syn-GFP mouse model of Parkinson’s disease. Left: Fluorescence, Right: homo-FRET metric - energy funnelling efficiency.

## MATLAB implementation for the simulations used in the article
[The implementation to generate the figure below can be found here](https://github.com/CamachoDejay/FRET-calculations)
![Definition of energy funneling efficiency ε (top panel) and calculations of the fluorescence anisotropy r and ε as functions of the distance between GFP molecules in a cubic lattice (bottom panel)](https://media.springernature.com/lw900/springer-static/image/art%3A10.1038%2Fs42003-018-0156-x/MediaObjects/42003_2018_156_Fig1_HTML.png)
Definition of FRET parameter ε (top panel) and calculations of the fluorescence anisotropy r and ε as functions of the distance between GFP molecules in a cubic lattice (bottom panel). Black arrows show the transition from the pure monomer to the pure dimer case. Error bars represent the standard deviation of the simulations when repeated 10 times.
