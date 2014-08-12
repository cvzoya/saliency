% [dist F]= emd_hat_gd_metric_mex(P,Q,D,extra_mass_penalty,FType)
%
% Fastest version of EMD. Also, in my experience metric ground distance
% yields better performance.
% 
% Output:
%  dist - the computed distance
%  F - the flow matrix, see "FType" 
%  Note: if it's not required it's computation is totally skipped.
%
% Required Input:
%  P,Q - two histograms of size N
%  D - the NxN matrix of the ground distance between bins of P and Q.
%  Must be a metric. I recommend it to be a thresholded metric (which
%  is also a metric, see ICCV paper).
%
% Optional Input:
%  extra_mass_penalty - the penalty for extra mass. If you want the
%                       resulting distance to be a metric, it should be
%                       at least half the diameter of the space (maximum
%                       possible distance between any two points). If you
%                       want partial matching you can set it to zero (but
%                       then the resulting distance is not guaranteed to be a metric).
%                       Default value is -1 which means 1*max(D(:)).
%  FType - type of flow that is returned. 
%          1 - represent no flow (then F should also not be requested, that is the
%          call should be: dist= emd_hat_gd...
%          2 - fills F with the flows between bins connected
%              with edges smaller than max(D(:)).
%          3 - fills F with the flows between all bins, except the flow
%              to the extra mass bin.
%          Defaults: 1 if F is not requested, 2 otherwise





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

