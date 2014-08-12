% This demo efficiently computes the emd_hat between 
% histograms where the ground distance is non
% symmetric.
% emd_hat is described in the paper:
% A Linear Time Histogram Metric for Improved SIFT Matching
% Ofir Pele, Michael Werman
%  ECCV 2008
% The efficient algorithm is described in the paper:
%  Fast and Robust Earth Mover's Distances
%  Ofir Pele, Michael Werman
%  ICCV 2009
clc; close all; clear all;
extra_mass_penalty= -1;
flowType= 3;

% Non symmetric ground distance
D= [0 3 5; 100 0 300; 900 800 0];

P= [1; 0; 0];
Q= [0; 1; 0];

demo_FastEMD_compute(P,Q,D,extra_mass_penalty,flowType);

P= [1; 0; 0];
Q= [0; 2; 0];

demo_FastEMD_compute(P,Q,D,extra_mass_penalty,flowType);

P= [2; 0; 0];
Q= [0; 1; 0];

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
