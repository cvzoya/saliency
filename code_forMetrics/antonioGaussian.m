function [BF, gf]=gaussian(img, fc)
% Gaussian low pass filter (with circular boundary conditions).
% 
%  [BF, gf]=gaussian(img, fc);
%
% Parameters:
%  img = input image
%  fc  = cut off frequency (-6dB)
%    The cut off frequency has units of cycles per image. The number of cycles
%   per image goes from 1 to n/2 where n^2 is the number of pixels of the image.
%    fc is the frequency at which the amplitude of the input signal gets
%    divided by 2 at the output. If you run gaussian(img, 6) without output
%    parameters you will see that the section falls to 1/2 at the frequency
%    6 cycles/image.
%  BF = output image
%  gf = gaussian filter
%
% USE:
% For instance:
%  BF = gaussian(img, 6);
% this will filter the image 'img' and give back a blurred version of the image 'BF'.  
%
% If the input image is not square, there might be some boundary artifact
% due to zero padding of the input.

% Antonio Torralba, 1999

[sn, sm, c]=size(img);
n=max([sn sm]);
n=n+mod(n,2);
n = 2^ceil(log2(n));

% frequencies:
[fx,fy]=meshgrid(0:n-1,0:n-1);
fx=fx-n/2; fy=fy-n/2;

% convert cut of frequency into gaussian width:
s=fc/sqrt(log(2));

% compute transfer function of gaussian filter:
gf=exp(-(fx.^2+fy.^2)/(s^2));
gf = fftshift(gf);

% convolve (in Fourier domain) each color band:
BF = zeros(n,n,c);
for i = 1:c
    BF(:,:,i)=real(ifft2(fft2(img(:,:,i),n,n).*gf));
    %BF(:,:,i)=real(ifft2(fftshift(fftshift(fft2(img(:,:,i),n,n)).*gf)));
end

% crop output to have same size than the input
BF=BF(1:sn,1:sm,:);

% if no input parameters are provided, then it shows a section of the
% gaussian filter:
if nargout==0
   figure
   plot(fx(n/2,:),gf(n/2,:))
   grid on
   hold on
   plot([fc fc],[0 1],'r')
   hold off
   xlabel('cycles per image')
   ylabel('amplitude transfer function')
end


