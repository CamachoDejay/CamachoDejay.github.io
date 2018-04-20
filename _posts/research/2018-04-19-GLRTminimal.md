---
title: "Generalized Likelihood Ratio Test (GLRT) for the localization of single emitters in a fluorescence microscopy image"
layout: post
date: 2018-04-19 10:00
image: false
headerImage: false
hidden: false
tag:
- Localization Microscopy
- Super-resolution
- Particle Localization
- Generalized Likelihood Ratio Test
star: false
category: blog
author: rafa
description: my own take on the equations and ideas presented on the article Dynamic multiple-target tracing to probe spatiotemporal cartography of cell membranes. By Sergé, A., Bertaux, N., Rigneault, H., & Marguet, D. (2008). Nature Methods, 5(8), 687–694.
externalLink: true
---

All the information presented here is my own take on the equations and ideas presented on the article [Dynamic multiple-target tracing to probe spatiotemporal cartography of cell membranes. By Sergé, A., Bertaux, N., Rigneault, H., & Marguet, D. (2008). Nature Methods, 5(8), 687–694.](https://doi.org/10.1038/nmeth.1233)

I will post later a good introduction to hypothesis testing via Generalized Likelihood Ratio Test. For the particular case of single molecule detection, the two hypotheses tested are: $$H_0$$ non-presence of a particle (i.e. the data can be explained by random noise), and $$H_1$$ the presence of a particle (i.e. the data can be explained by a 2D gaussian).

In this post I will not concentrate on the mathematics behind the equations, as I will cover that later, but I will take the view from an implementation stand point. How can we actually code the final equations presented in the above cited article?


## What are we trying to do?
**Problem:** given a microscopy image, $$im$$, of dimensions $$[k, v]$$ how can we automatically detect the presence of a single particle located at a given pixel $$(x,y)$$.

**Solution:** we will use a GLRT to test each pixel of the image for the presence or absence of a particle. In practice this means that we have to select a squared region of interest (ROI) centered around the test pixel $$(x,y)$$ of dimensions $$[w_s  × w_s]$$, where $$w_s$$ stands for window size. Then we will check if that ROI can be better explained by random noise ($$H_0$$) or by the presence of a gaussian in its center ($$H_1$$ a particle PSF).

![GLRT H0 and H1](/assets/images/GLRT-fig1.svg "Two hypothesis to test")

**Where do the equations come from?** for a formal explanation have a look at the supplementary information of the above cited article. Below I explain the practical implementation.

## How do I interpret the equations presented in the paper?

Let us consider a segmented ROI containing in its center the pixel to test $$(x,y)$$. From a data perspective the ROI is nothing else than a matrix containing intensity values at each pixel:

$$
  X_{(i,j)} = X_n
$$

To follow the nomenclature of the article, we take the vector form or the ROI $$X_n$$, which is just a change in the way we index the ROI, and therefore, the total number of pixels in the ROI, $$N$$, is given by:

$$
  \sum{n} = {w_s}^2 = N
$$

Now, the most important set of equations for the implementation are those labelled as 4 in the supplementary information. GLRT map $$H_0 / H_1$$:
$$
c = L(H_0)-L(H_1)\\
c = -\left( \frac{w_s^2}{2} \right) ln\left( \frac{ \hat\sigma_0 } {\hat\sigma_1} \right)\\
c = \left( \frac{w_s^2}{2} \right) ln\left( \frac{ \hat\sigma_1 } {\hat\sigma_0} \right)\\
c = \left( \frac{w_s^2}{2} \right) ln\left( 1 - \frac{ \hat I^2 \sum_{n}{\tilde G^2_n}} {w_s^2 \hat\sigma_0^2} \right)\\
$$

The last equation above is the one we will implement in our calculations. However, what all of this mumbo-jumbo means, well:

$$w_s$$: is the window size of the squared ROI containing or not a particle in its center. Therefore, $$w_s^2$$ is nothing else than the number of pixels in your ROI.


$$\tilde G$$: comes from the gaussian hypothesis ($$H_1$$ - presence of a particle), and is given by:

$$
\tilde G = G - \hat G
$$

$$
  \hat G = \mu(G) = \frac{1}{N} \sum_{n}{G_n}=\left(\frac{1}{w_s}\right)^2 \sum_n G_n
$$

The equation above means that we take the perfect image of a gaussian centered in the ROI, $$G$$, and remove its mean value over the ROI, $$\hat G$$. Details about $$G$$ calculation can be found in the example code below.

$$\hat I$$: also comes from the gaussian hypothesis ($$H_1$$) and is defined as:

$$
  \hat I = \frac {\sum_n {\tilde G_n X_n}}{\sum_n {\tilde G_n^2}}
$$

Before you get afraid, the numerator of $$\hat I$$ is just the convolution of your input ROI image, $$X_n$$, with $$\tilde G$$. While the denominator is the sum of $$\tilde G^2$$ over all ROI pixels.

$$\sigma ̂_0^2$$: comes from the noise hypothesis ($$H_0$$ - non-presence of a particle), and it is defined as:

$$
\sigma ̂_0^2 = \left(\frac{1}{w_s^2}  \sum_n {X_n^2}\right) - \left(\frac{1}{w_s^2} \sum_n X_n \right)^2
$$

$$
\sigma ̂_0^2 = \hat\mu(X^2) - [\hat\mu(X)]^2
$$

which is nothing else than the variance of the input ROI image - $$X_n$$

## How do I code/implement the equations presented above?
A single pixel MATLAB implementation of the code can be found [here](https://github.com/CamachoDejay/polymer3D) and is presented below. After running the code you will get an output image that contains two test simulated ROIs.

![Simulated GLRT](/assets/images/GLRT-fig2.svg "Simulated images used for testing of GRLT code")

 ```
 function main()
 %MAIN minimal implementation of GLRT
 %   now for the implementation to give a better feeling I will first build
 %   2 example images, one containing only noise and another containing a
 %   particle in the middle. For the particle I just use a gaussian
 %   approximation to the PSF.

 % By Rafael Camacho, 2018, github user camachodejay,
 % <camachodejay@yahoo.com>

 % lets agree on a ROI size of 13 x 13
 ROIsize = [13,13];

 % ROI image containing noise
 imRand = uint16(ones(ROIsize).*20);
 imRand = imnoise(imRand,'poisson');

 % ROI image containing a gaussian spot on its center with some noise. For
 % this I first build a gaussian with appropriate dimentions - G. For a
 % water immersion obj the best-fit gasuss to the PSF has: sigma = 0.25
 % wavelength / NA
 % emission wavelength
 emWave   = 600; % in nm
 % objective NA
 objNA    = 1.2;
 % sigma of gaussian in nm
 sigma_nm = 0.25 * emWave/objNA;
 % typical pixel size for SR microscopy
 pxSizeNm = 100;
 % sigma of gaussian in pixels
 sigma_px = sigma_nm / pxSizeNm;
 % get input for my 2D gaussian function generator
 xid = 1:ROIsize(1);
 yid = 1:ROIsize(2);
 % gaussian PSF will be in the middle of the ROI
 pos = [mean(xid),mean(yid)];
 % gaussian PSF, see end of file for the function definition
 [G] = gaus2D(pos, [sigma_px, sigma_px], xid,yid,1);
 % create image and add noise
 imParticle = G.*150+20;
 imParticle = uint16(imParticle);
 imParticle = imnoise(imParticle,'poisson');
 %%
 testROI = cat(3,imRand,imParticle);
 LRT = zeros(1,2);
 for i = 1:2
     im = testROI(:,:,i);
     im = double(im);
     assert(size(im,1)==size(im,2),'ROI must be squared')
     % get size of ROI
     ws = size(im,1);
     N   = ws^2;
     % calculation of G_bar and sGbar2.
     % get model gaussian, a bit redundant but good to have it here also
     % get input for my 2D gaussian function generator
     xid = 1:ws;
     yid = 1:ws;
     % gaussian PSF will be in the middle of the ROI
     pos = [mean(xid),mean(yid)];
     % gaussian PSF -  note that sigma_px is a input given to the GLRT
     [G] = gaus2D(pos, [sigma_px, sigma_px], xid,yid,1);
     %       Mean of the gaussian PSF
     G_mean  = mean(G(:));
     %       G bar: gaussian PSF minus its mean
     G_bar = G - G_mean;
     %       sum of G bar squared
     sGbar2 = sum(sum(G_bar.^2));
     %       convolution of the image with G_bar
     imConv = sum(sum(G_bar.*im));
     %       calculation of I_hat
     I_hat  = imConv/sGbar2;
     %       denominator, which depends on how good it fits
     %       to random noise
     den = var(im(:))*N;
     %   calculation of the difference betwen the likelihood
     %   of having the data explained by random noise or by
     %   a gaussian. L(H_0)-L(H_1)
     LRT(i) = ( (N)/2 ) * (log(1-((I_hat^2 * sGbar2)/den)));

 end

 figure(1)
 subplot(1,2,1)
 imagesc(imRand)
 axis image
 title({'no particle example',['GLRT: ' num2str(LRT(1),3)]})

 subplot(1,2,2)
 imagesc(imParticle)
 axis image
 title({'particle example',['GLRT: ' num2str(LRT(2),3)]})

 end

 function [G] = gaus2D(pos, sig, xid,yid,maxCount)
     %Simple 2D gaussian, just to make the code easier to read
     switch nargin
         case 4
             A = 100;
         case 5
             A = maxCount;
         otherwise
             error('Not enough input');
     end

     % due to the way meshgrid works y comes first and x second. this because I
     % want x to be the first dimention of my array and y the second
     [y,x] = meshgrid(xid,yid);
     sigX = sig(1);
     sigY = sig(2);
     x0 = pos(1);
     y0 = pos(2);

     xPart = ((x-x0).^2) ./ (2*sigX^2);
     yPart = ((y-y0).^2) ./ (2*sigY^2);


     G = A.*exp( -(xPart + yPart));

 end

 ```

### MATLAB implementation for an image
An optimized MATLAB implementation of the GLRT described above that runs over an entire image, testing all possible pixels, can be found [here](https://github.com/CamachoDejay/polymer3D/blob/master/%2BLocalization/private/GLRTfiltering.m)
