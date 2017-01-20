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
% edited: David Berga, Jan 2017

[sn, sm, c]=size(img);
n=max([sn sm]);
n=n+mod(n,2);
n = 2^ceil(log2(n));

img2 = zeropadimage(img,n); %image with zero padding
[sn2, sm2, c2]=size(img2);
n2=max([sn2 sm2]);
%n2=n2+mod(n2,2);
%n2 = 2^ceil(log2(n2));

% frequencies:
[fx,fy]=meshgrid(0:n-1,0:n-1);
fx=fx-n/2; fy=fy-n/2;

% convert cut of frequency into gaussian width:
s=round(n2/n) * fc/sqrt(log(2)); %re-scaled to padded image dimensions

% compute transfer function of gaussian filter:
gf=exp(-(fx.^2+fy.^2)/(s^2));

gf2 = zeros(n2,n2,c); gf2(n+1:n2-n,n+1:n2-n,:) = gf;
gf2 = fftshift(gf2);


% convolve (in Fourier domain) each color band:
BF = zeros(n2,n2,c);
for i = 1:c
    BF(:,:,i)=real(ifft2(fft2(img2(:,:,i),n2,n2).*gf2));
    %BF(:,:,i)=real(ifft2(fftshift(fftshift(fft2(img2(:,:,i),n2,n2)).*gf2)));
end

% crop output to have same size than the input
BF=BF(n+1:n+sn,n+1:n+sm,:);

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


function [Ipad] = zeropadimage(I,p)

%Find size of image
[h, w] = size(I); 

%Pad edges
Ipad = zeros(h+2*p, w+2*p);  

%Middle
Ipad(p+1:p+h, p+1:p+w) = I;

%Top and Bottom
Ipad(1:p, p+1:p+w) = repmat(I(1,1:end), p, 1);
Ipad(p+h+1:end, p+1:p+w) = repmat(I(end,1:end), p, 1); 

%Left and Right
Ipad(p+1:p+h, 1:p) = repmat(I(1:end,1), 1, p);
Ipad(p+1:p+h, p+w+1:end) = repmat(I(1:end,end), 1, p); 

%Corners
Ipad(1:p, 1:p) = I(1,1); %Top-left
Ipad(1:p, p+w+1:end) = I(1,end); %Top-right
Ipad(p+h+1:end, 1:p) = I(end,1); %Bottom-left
Ipad(p+h+1:end,p+w+1:end) = I(end,end); %Bottom-right

end
