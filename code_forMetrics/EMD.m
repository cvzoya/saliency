% created: Tilke Judd, Aug 2011
% updated: Zoya Bylinskii, Aug 2014

% This function is built off of FastEMD/demo_FastEMD3 demo.
% Before using this function, compile FastEMD.
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

function score = EMD(saliencyMap1, saliencyMap2, toPlot)
% saliencyMap1 and saliencyMap2 are 2 real-valued matrices
% if toPlot=1, displays output of EMD processing

if nargin < 3, toPlot = 0; end

% im1 and im2 may come in as doubles or uint8!
im1 = imresize(saliencyMap2, 1/32);
im2 = imresize(saliencyMap1, 1/32);
R= size(im1,1);
C= size(im1,2);
if (~(size(im2,1)==R&&size(im2,2)==C))
    error('Size of images should be the same');
end

% histogramMatch the images so they have the same mass
im2 = histMatchMaps(im1, im2);
if size(find(isnan(im2)), 1)
    im2(isnan(im2))=0;
    display('Warning, changing NaN to 0');
end

% Making sure mass sums to 1.
% This normalizes the EMD so that the score is independent of the starting
% amount of mass / spread of fixations of the fixation map
im1 = im1/sum(im1(:));
im2 = im2/sum(im2(:));

%[sum(im1(:)), sum(im2(:))] % The mass of earth in each image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


D= zeros(R*C,R*C,'double');

j= 0;
for c1=1:C
    for r1=1:R
        j= j+1;
        i= 0;
        for c2=1:C
            for r2=1:R
                i= i+1;
                D(i,j)= sqrt((r1-r2)^2+(c1-c2)^2);
            end
        end
    end
end

extra_mass_penalty= 0;
flowType= int32(3);


P = im1(:);
Q = im2(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

score = emd_hat_gd_metric_mex(P,Q,D,extra_mass_penalty);

if toPlot
    figure(1)
    subplot(221); imshow(saliencyMap2);
    subplot(222); imshow(saliencyMap1);
    subplot(223); imshow(im1, []); title(['EMD: ', num2str(score)])
    subplot(224); imshow(im2, []);
    
    figure(2)
    subplot(131); imshow([im1; im2], []);
    subplot(132); imhist(im1);
    subplot(133); imhist(im2);
end

% Copyright (c) 2009-2011, Ofir Pele
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

