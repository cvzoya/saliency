% This demo loads two grayscale images and efficiently computes the emd_hat
% between them in a similar to Peleg et al. paper: "A Unified Approach
% to the Change of Resolution: Space and Gray-Level".
% All computation here are done on dint32, which is a little more
% efficient than working on doubles.
% emd_hat is described in the paper:
%  A Linear Time Histogram Metric for Improved SIFT Matching
%  Ofir Pele, Michael Werman
%  ECCV 2008
% The efficient algorithm is described in the paper:
%  Fast and Robust Earth Mover's Distances
%  Ofir Pele, Michael Werman
%  ICCV 2009

clc; close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im1= imread('cameraman.tif');
im2= imread('rice.png');
im1= imresize(im1,1/8);
im2= imresize(im2,1/8);
R= size(im1,1);
C= size(im1,2);
if (~(size(im2,1)==R&&size(im2,2)==C))
    error('Size of images should be the same');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMD input
% Each unit of gray-level (between 0 and 255) is a unit of mass, and the
% ground distance is a thresholded distance. This is similar to:
%  A Unified Approach to the Change of Resolution: Space and Gray-Level
%  S. Peleg and M. Werman and H. Rom
%  PAMI 11, 739-742
% The difference is that the images do not have the same total mass 
% and we chose a thresholded ground distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
COST_MULT_FACTOR= 1000;
THRESHOLD= 3*COST_MULT_FACTOR;
D= zeros(R*C,R*C,'int32');
j= 0;
for c1=1:C
    for r1=1:R
        j= j+1;
        i= 0;
        for c2=1:C
            for r2=1:R
                i= i+1;
                D(i,j)= min( [THRESHOLD (COST_MULT_FACTOR*sqrt((r1-r2)^2+(c1-c2)^2))] );
            end
        end
    end
end
extra_mass_penalty= int32(-1);
flowType= int32(3);

P= int32(im1(:));
Q= int32(im2(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The demo includes several ways to call emd_hat_mex and emd_hat_gd_metric_mex
demo_FastEMD_compute(P,Q,D,extra_mass_penalty,flowType);

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

