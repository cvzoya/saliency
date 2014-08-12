% [ground_distance_matrix]= color_spatial_EMD_ground_distance(im1,im2,alpha_color,threshold,coordinates_transformation)
%
% Creates an EMD ground distance matrix between im1 and im2 (ims
% should be in L*a*b* space). The distance between the pixels
% (x1,y1,L1,a1,b1) and (x2,y2,L2,a2,b2) is:
%  min(alpha_color*CIEDE2000(L1,a1,b1,L2,a2,b2) +
%      (1-alpha_color)*||(T(x1),T(y1))-(T(y2),T(y2))||_2 , threshold)
% Where T is a coordinate transformation determined by
% coordinates_transformation:
%  coordinates_transformation==1 Identity:
%   T(x1)=x1 T(y1)=y1
%   T(x2)=x2 T(y2)=y2
%  coordinates_transformation==2 Center:
%   T(x1)=x1-((size(im1,2)+1)/2) T(x2)=x2-((size(im2,2)+1)/2)
%   T(y1)=y1-((size(im1,1)+1)/2) T(y2)=y2-((size(im2,1)+1)/2)
%  coordinates_transformation==3 Normalized (coordinates are transformed
%  to [0 1]):
%   T(x1)=(x1-1)/(size(im1,2)-1) T(x2)=(x2-1)/(size(im2,2)-1)
%   T(y1)=(y1-1)/(size(im1,1)-1) T(y2)=(y2-1)/(size(im2,1)-1)
%
% Note 1: alpha_color*threshold should be smaller or equal to 20, as
% CIEDE2000 (like all other color distances) should be saturated (see
% ICCV paper)
%
% Note 2: the ground_distance_matrix contains values only between im1 and
% im2. That is, the distance between im1 pixels to themselves and
% im2 pixels to themselves are not computed. This means that the matrix
% can be used for EMD, but cannot be used for distances such as the
% Quadratic-Form (aka Mahalanobis).





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
