---
title: "Programming Sessions"
layout: post
date: 2017-10-20 22:00
image: false
headerImage: false
tag:
- Programming Sessions
star: false
category: blog
author: rafa
description: Main site for the programming sessions of KU Leuven, MATLAB for young researchers
hidden: false
externalLink: true
---
The **Programming Sessions** are designed to teach computer programming and the MATLAB language to young researchers. The sessions focus on software construction, meaning mostly on coding and debugging but also keeping track of design techniques, construction planning, unit testing, and other activities. We will teach many different heuristic approaches to problem solving and introduce as fast as possible wicked problems by using projects that evolve as we solve them.

### [](#S-1)Session 01

During this session we will write one of the most basic of all programs. The purpose of this exercise is to  learn the basics of MATLAB's integrated development environment (IDE). We will learn basic ways in which we can make MATLAB report information back to the user. Namely, the ```disp()``` function and how to print information to a text file. For the later, we will quickly introduce some string formatting.
[Follow this link for detailed information about the session](/session-01)


### [](#S-2)Session 02
During the first session we created a basic program that wrote some information to the screen or text file. In other words it can create an **output**. However, useful programs generally produce results based on some **input** given to them. During this session we introduce some of the most basic and important data classes of MATLAB: the numeric array and the cell array. We will handle the change of a string into a number, in relation to user **input**. We will do a small introduction to the ```assert()``` function, which we can use to check if a program is working as intended. Further we will have a quick look to basic control flow - ```for```-loop.
[Follow this link for detailed information about the session](/session-02)

### [](#S-3)Session 03
After the first two sessions we start to have a feeling as to how we can get a program to take some user **input**, do some calculations based on that input to generate **output** and finally communicate that output back to the user. On the third session we will concentrate a bit more into the basics of **computation**. We will learn how to generate more complicated *expressions*, how to make our program to choose among different alternatives (**selection**), and how to repeat a **computation** many times (**iteration**). Finally we will learn how to keep code clean, reusable and maintainable by separating a particular sub-computation into a **function**.
[Follow this link for detailed information about the session](/session-03)

### [](#S-4)Session 04
During this session, we will concentrate on how to make MATLAB code easier to read and faster via vectorization. MATLAB has many built in function that are able to operate over all elements in an array, e.g. for multiplication the vectorised version is ```.*```. I will present an easy example and then go back into our Mandelbrot project to show you how to solve it using first nested loops and then via a more vectorised version of the code that allows me to remove the nested loops. While on this particular case the speed difference is not very large it makes the code much easier to understand. [Follow this link for detailed information about the session](/session-04)

### [](#S-5)Session 05
During this session, we will concentrate on data fitting using one of the minimization algorithms of MATLAB. The function we will work with is called fminsearch, and allows you to find the minimum of an unconstrained multivariable function. We will present an example of its use to fit a sine wave. We will then see some of the problems related to minimization algorithms, in particular the presence of deep local minima where the algorithm gets stuck and cannot get out, thus, never reaching the global minima. After looking at the example we will work together so you fit a Gaussian to a dummy data set.
[Follow this link for detailed information about the session](/session-05)

### [](#S-6)Session 06
During this session, we will concentrate on solving a system of linear equations using the ```mldivide()``` function . We will use it to do some very basic spectral unmixing. Basically, we will decompose a mixed fluorescence spectra (containing 2 known species) into its constituent spectra, and find the relative ratio between the species.
[Follow this link for detailed information about the session](/session-06)

### [](#p1)Project 01

#### Project description

Now that we can handle basic input and output, it is time we start to do some interesting calculations and plotting. So, for our first project in the course (Project-01) we will work towards a graphical user interphase [(GUI)](https://en.wikipedia.org/wiki/Graphical_user_interface) that displays the [Mandelbrot Set](https://en.wikipedia.org/wiki/Mandelbrot_set) (a very famous [fractal](https://en.wikipedia.org/wiki/Fractal)) and allows the user to zoom into any area of the fractal with seemingly infinite resolution.
[Follow this link for detailed project information](/Project01-Step01)
