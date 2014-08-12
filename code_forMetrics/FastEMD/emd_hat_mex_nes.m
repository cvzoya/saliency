function [dist F]= emd_hat_mex_nes(P,Q,D,extra_mass_penalty,FType)
% [dist F]= emd_hat_mex_nes(P,Q,D,extra_mass_penalty,FType)
% 
% Same as emd_hat_mex, but does not assume P and Q have the same size
% Note that D should still be non-negative.

if (nargin<4)
    extra_mass_penalty= -1;
end
if (nargin<5)
    if (nargout==2)
        FType= 2;
    else
        FType= 1;
    end
end
    

maxD= max(D(:));
if (length(P)<length(Q))
    add_N= length(Q)-length(P);
    PP= [P; zeros(add_N,1)];
	QQ= Q;
	D= [D; ones(add_N,size(D,2)).*maxD];
else
    add_N= length(P)-length(Q);
    QQ= [Q; zeros(add_N,1)];
	PP= P;
    D= [D, ones(size(D,1),add_N).*maxD];
end

if (nargout==2)
    [dist F]= emd_hat_mex(PP,QQ,D,extra_mass_penalty,FType);
	if (length(P)<length(Q))
	  F= F(1:length(P),:);
	else
	  F= F(:,1:length(Q));
	end
else
    dist= emd_hat_mex(PP,QQ,D,extra_mass_penalty,FType);
end    
        
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

