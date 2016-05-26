% created: Zoya Bylinskii, Jan 2016

% Given a desired sigma blur value, this computes the cut off frequency
% required for the Gaussian low pass filter in the Fourier domain.
% This function runs Antonio's gaussian computation.

function [BF, gf] = run_antonioGaussian(img, sigma)

[sn, sm, c]=size(img);
n=max([sn sm]);

fc = n*sqrt(log(2)/(2*(pi^2)*(sigma^2)));

[BF, gf]=antonioGaussian(img, fc);