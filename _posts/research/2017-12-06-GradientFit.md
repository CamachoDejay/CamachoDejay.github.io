---
title: "Gradient Fit for Localization Microscopy"
layout: post
date: 2017-12-06 10:00
image: false
headerImage: false
hidden: false
tag:
- Localization Microscopy
- Super-resolution
star: false
category: blog
author: rafa
description: working on the code by Ma, H., Xu, J., Jin, J., Gao, Y., Lan, L., & Liu, Y. Scientific Reports, 5(1), 14335.
externalLink: true
---
# Localization via Gradient Fit

Below I solve the system of equations presented by Liu et. al. in their article: __Fast and Precise 3D Fluorophore Localization based on Gradient Fitting__ 2015 Scientific reports. The reason for this is that their [implementation](http://www.pitt.edu/~liuy/) was difficult to follow/understand. Further, by doing some cleaning of their code I noticed that extra work on the math could simplify their equations. Unfortunately, I could not find the solutions to the systems of equation in the article or supporting information. Therefore, I solved the math, which I present below, and came up with my own implementation. Direct comparison shows that my solutions are consistent with those presented by the authors in their code. Full reference:
[Ma, H., Xu, J., Jin, J., Gao, Y., Lan, L., & Liu, Y. Scientific Reports, 5(1), 14335.](https://doi.org/10.1038/srep14335)

## System of equations
**TODO: So far, I place only the main equations/solutions. More details will follow**.
The main system of equations presented in the paper is as follows:

$$
D = \sum_{m,n} \frac{(e(x_c-m) g_y-(y_c-n) g_x )^2  }{(e_0^2 (x_0-m)^2+(y_0-n)^2 )(g_x^2+g_y^2 ) }W
$$

where, $$e_0$$ and $$(x_0,y_0)$$ are the initial values of $$e$$ and $$(x_c,y_c)$$ estimated by the centroid method (see [QuickPALM](https://www.nature.com/articles/nmeth0510-339)) and $$W$$ is the weighting parameter:

$$
W= (g_x^2+g_y^2 )* \sqrt{(x_0-m)^2+(y_0-n)^2}
$$

Now the task is to solve the system of equations:

$$
\frac{\partial D}{\partial x_c}=0 \\
\frac{\partial D}{\partial y_c}=0 \\
\frac{\partial D}{\partial e}=0
$$

By solving the derivatives we find that:

$$
\frac{\partial D}{\partial x_c} = \sum_{m,n} 2 e g_y W^{* } [(x_c - m)eg_y - (y_c - n)g_x] = 0 \\
\frac{\partial D}{\partial y_c} = \sum_{m,n} 2 g_x W^{* } [(y_c - n)g_x - (x_c - m)eg_y] = 0 \\
\frac{\partial D}{\partial e} = \sum_{m,n} 2 (x_c - m) g_y W^{* } [(x_c - m)g_y e - (y_c - n)g_x] = 0
$$

where:

$$
W^{* }= \frac{ \sqrt{(x_0-m)^2+(y_0-n)^2} }{e_0^2 (x_0 - m)^2 + (y_0 - n)^2 }
$$

### Solution
Solving the system of equations we obtain:

$$
e = \frac{ A(FJ-GH)+B(EH-DJ)+D(GD-EF) }{ A(F^2-CH)+B(BH-DF)+D(CD-BF) } \\
x_c = \frac{BH-FD}{AH-D^2} + \frac{1}{e} \frac{JD-EH}{AH-D^2}\\
y_c = \frac{JA-ED}{AH-D^2} + e \frac{DB-FA}{AH-D^2}
$$

where:

$$
A = \sum_{m,n} g_y^2 W^{* }\\
B = \sum_{m,n} m g_y^2 W^{* }\\
C = \sum_{m,n} (m g_y)^2 W^{* }\\
D = \sum_{m,n} g_x g_y W^{* }\\
E = \sum_{m,n} n g_x g_y W^{* }\\
F = \sum_{m,n} m g_x g_y W^{* }\\
G = \sum_{m,n} m n g_x g_y W^{* }\\
H = \sum_{m,n} g_x^2 W^{* }\\
J = \sum_{m,n} ng_x^2 W^{* }\\
$$

### MATLAB implementation
A MATLAB implementation of the code can be found [here](https://github.com/CamachoDejay/polymer3D)
