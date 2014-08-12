function [] = demo_FastEMD_compute(P,Q,D,extra_mass_penalty,flowType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMD computation
% This part is common to all demo_FastEMD scripts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fastest version - Exploits the fact that the ground distance is
% thresholded and a metric.
tic
emd_hat_gd_metric_mex_val= emd_hat_gd_metric_mex(P,Q,D,extra_mass_penalty);
fprintf(1,'emd_hat_gd_metric_mex time in seconds: %f\n',toc);
 
% A little slower - with flows
tic
[emd_hat_gd_metric_mex_val_with_flow F1]= emd_hat_gd_metric_mex(P,Q,D,extra_mass_penalty,flowType);
fprintf(1,'emd_hat_gd_metric_mex computing the flow also, time in seconds: %f\n', ...
        toc);

% Even slower - Only exploits the fact that the ground distance is
% thresholded
tic
emd_hat_mex_val= emd_hat_mex(P,Q,D,extra_mass_penalty);
fprintf(1,'emd_hat_mex time in seconds: %f\n',toc);

% Even slower - with flows
tic
[emd_hat_mex_val_with_flow F2]= emd_hat_mex(P,Q,D,extra_mass_penalty,flowType);
fprintf(1,'emd_hat_mex computing the flow also, time in seconds: %f\n',toc);

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  % Comparison with Rubner (much slower than my versions) -
%  % You'll need to:
%  %  1. download emd mex files from:
%  %     http://www.mathworks.com/matlabcentral/fileexchange/12936
%  %     To rubner_emd/
%  %  2. Increase MAX_SIG_SIZE and MAX_ITERATIONS in emd.h
%  %  3. Compile it
%  %  4. You might also need to use 'unlimit' as Rubner's version 
%  %     uses the stack.
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  fprintf('\n');
%  addpath ('rubner_emd/');
%  P= double(P);
%  Q= double(Q);
%  sumBig=   max([sum(P(:)) sum(Q(:))]);
%  sumSmall= min([sum(P(:)) sum(Q(:))]);
%  D= double(D);
%  tic
%  emd_rubner_mex_val= (sumSmall*emd_mex(P',Q',D)) + (sumBig-sumSmall)*max(D(:));
%  fprintf(1,'emd_rubner_mex time in seconds: %f\n',toc);
%  
%  if (emd_hat_gd_metric_mex_val~=emd_rubner_mex_val)
%      fprintf(1,'emd_hat_gd_metric_mex_val - emd_rubner_mex_val == %f\n', ...
%              emd_hat_gd_metric_mex_val-emd_rubner_mex_val);
%      fprintf(1,'Note that there might be a small difference due to ');
%  	fprintf(1,'differences between double and int. Also differences ');
%  	fprintf(1,'might happen because of MAX_ITERATIONS in emd.h too small.\n');
%  end


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

