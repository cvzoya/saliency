% This demo loads two color images and efficiently computes the emd_hat
% between them. The ground distance is a thresholded linear combination of
% the spatial and color distance between pixels. This is similar to the
% distance I used for color images in my ICCV paper. Image sizes do not
% need to be the same. As a color distance I used CIEDE2000.
% emd_hat is described in the paper:
%  A Linear Time Histogram Metric for Improved SIFT Matching
%  Ofir Pele, Michael Werman
%  ECCV 2008
% The efficient algorithm is described in the paper:
%  Fast and Robust Earth Mover's Distances
%  Ofir Pele, Michael Werman
%  ICCV 2009
% CIEDE2000 is described in the papers:
% The development of the CIE 2000 colour-difference formula: CIEDE2000
%  M. R. Luo, G. Cui, B. Rigg
%  CRA 2001
% The CIEDE2000 color-difference formula: Implementation notes, supplementary test data, and mathematical observations
%  Gaurav Sharma, Wencheng Wu, Edul N. Dalal
%  CRA 2004

clc; close all; clear all;

addpath ../

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distance parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the paper I used threshold=20, but I didn't use alpha_color and
% 1-alpha_color for the spatial. I just added them. So using threshold=10
% is equivalent to what I used in the paper.
threshold= 10;
alpha_color= 1/2;
% Center. In the ICCV paper center and identity were equivalent as the image
% sizes were the same.
coordinates_transformation= 2; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im1= imresize( imread('1.jpg') , 1/30);
im2= imresize( imread('2.jpg') , 1/30);
% 3.jpg is more similar to 1.jpg and thus the running time will be longer.
%im2= imresize( imread('3.jpg') , 1/30);
im1_Y= size(im1,1);
im1_X= size(im1,2);
im1_N= im1_Y*im1_X;
im2_Y= size(im2,1);
im2_X= size(im2,2);
im2_N= im2_Y*im2_X;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMD input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P= [ ones(im1_N,1)  ;  zeros(im2_N,1) ];
Q= [ zeros(im1_N,1) ;  ones(im2_N,1)  ];

im1= double(im1)./255;
im2= double(im2)./255;
cform = makecform('srgb2lab');
im1_lab= applycform(im1, cform);
im2_lab= applycform(im2, cform);

% Creating the ground distance matrix.
% Loops in Matlab are very time consuming, so I use mex.
% Matlab corresponding code is commented out below.
tic
[ground_distance_matrix]= color_spatial_EMD_ground_distance(im1_lab,im2_lab,...
                                                  alpha_color,threshold, ...
                                                  coordinates_transformation);
fprintf(1,'computing the ground distance matrix, time in seconds: %f\n', ...
        toc);

% In ICCV paper extra_mass_penalty did not matter as image sizes were the same.
extra_mass_penalty= -1;
flowType= 3;

tic
[emd_hat_mex_val_with_flow F]= emd_hat_mex(P,Q,ground_distance_matrix,extra_mass_penalty,flowType);
fprintf(1,'Note that the ground distance here is not a metric.\n');
fprintf(1,'emd_hat_mex, time in seconds: %f\n',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% Copyright (c) 2009-2012, Ofir Pele
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met: 
%    * Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
%    * Neither the name of the The Hebrew University of Jerusalem nor the
%    names of its contributors may be used to endorse or promote products
%    derived from this software without specific prior written permission.

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
