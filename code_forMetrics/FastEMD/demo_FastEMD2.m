% This demo efficiently computes emd_hat between two random SIFTs
% histograms (3d histograms, see Lowe's paper: "Distinctive image
% features from scale-invariant keypoints" for more detail) where the
% ground distance between the bins is the thresholded sum of orientation and
% spatial distanced.
% emd_hat was described in the paper:
% A Linear Time Histogram Metric for Improved SIFT Matching
% Ofir Pele, Michael Werman
%  ECCV 2008
% The efficient algorithm is described in the paper:
%  Fast and Robust Earth Mover's Distances
%  Ofir Pele, Michael Werman
%  ICCV 2009

clc; close all; clear all;
rand('state',sum(100*clock));

XNBP= 4; % SIFT's X-dimension
YNBP= 4; % SIFT's Y-dimension
NBO= 16; % SIFT's Orientation-dimension
N= XNBP*YNBP*NBO;
thresh= 2;
extra_mass_penalty= -1; % Default of maximum distance
flowType= 3; % Regular flows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIFT ground distance matrix computation.
% Note: loops in Matlab are costly.
% However, this should be done only once.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D= zeros(N,N);
i= 1;
for y1=1:YNBP
    for x1=1:XNBP
        for nbo1=1:NBO
            
            j= 1;
            for y2=1:YNBP
                for x2=1:XNBP
                    for nbo2=1:NBO
                        D(i,j)= (sqrt((y1-y2)^2 + (x1-x2)^2) + ...
                                 min( [abs(nbo1-nbo2) NBO-abs(nbo1-nbo2)] ));
                        
                        j=j+1;
                    end
                end
            end
            i= i+1;
            
        end
    end
end
maxDist= max(D(:));
D= min(D,thresh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
P= rand(N,1);
Q= rand(N,1);

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

