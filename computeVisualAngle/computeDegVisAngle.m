% created: Zoya Bylinskii, Aug 2014
% Code for computing degrees of visual angle

% This code has been written to make it easier to report visual angle in
% papers, and to ensure a standardized calculation is used.

% This code can take variable input (e.g. horizontal, vertical, or diagonal
% screen measurements in any units), and will calculate any number of 
% degrees of visual angle in pixels, as well as degrees of visual angle 
% spanned by the computer screen or an image. 

% The code is provided on: http://saliency.mit.edu/

% resources used: http://osdoc.cogsci.nl/miscellaneous/visual-angle/, 
%                 http://en.wikipedia.org/wiki/Visual_angle
% Thank you to Lavanya Sharan and Melissa Vo for helpful discussion.

function computeDegVisAngle(varargin)

% Example usage:

% Assume: screen diagonal size is 19.5 inches, at a distance of 24 inches from
% eye-tracker, with a screen resolution of 1280x1024.
% To find out how many degrees of visual angle the screen subtends, and
% also to get an estimate of 1 degree of visual angle:
% computeDegVisAngle('diagonal','19.5 inch','distance','24 inch','hres',1280,'vres',1024)

% Assume: screen size is 47.39cm x 29.62cm, at a distance of 47.39cm from
% eye-tracker, with a screen resolution of 1680x1050.
% To find how many pixels 2 degrees of visual angle subtend and to
% determine the degrees of visual angle in a 200x200 pixel image:
% computeDegVisAngle('height','29.62 cm','width','47.39 cm','distance','26 inch','hres',1680,'vres',1050,'numDegs',2,'imageWidth',200,'imageHeight',200)

% ------ INPUT ARGUMENTS: ------
% necessary:
% 'distance'         distance to screen with units (e.g. 56 cm)

% provide at least one of:
% 'height'           height of screen with units
% 'width'            width of screen with units
% 'diagonal'         diagonal of screen with units 

% provide at least one of:
% 'hres'             horizontal resolution of screen (provide this if also provided 'height')
% 'vres'             vertical resolution of screen (provide this if also provided 'width')
% provide both if only provided 'diagonal'

% optional:
%'outputUnit'        output units to measure screen, distance in (default: cm)
%'numDegs'           number of degres of visual angle (in pixels) to calculate (default numDegs=1)
%'imageWidth'        width of image in pixels
%'imageHeight'       height of image in pixels

% NOTE: if you provide the screen diagonal and resolution, then the screen
% height and width will be estimated under the assumption that the aspect
% ratio of the screen dimensions matches that of the set resolution. If
% these estimates look wrong, either:
% (1) you measured the monitor dimensions, instead of the screen dimensions
% (2) the screen resolution aspect ratio does not match the screen
%     dimensions
% (3) explicitely enter the screen height and width instead of the diagonal

% Common mistake: remember that the number of pixels per unit size of screen 
% or image is a linear function, but number of pixels per degree of visual 
% angle is NOT.

% Remember: when writing a paper, include enough information for visual 
% angle to be calculated - providing screen resolution without screen 
% dimensions or vice versa is insufficient! Also, remember to measure the
% screen itself, rather than the whole monitor.

% units required for distance, height, width, and diagonal values
P = inputParser;

addParameter(P,'distance',[]);      
addParameter(P,'height',[]);         
addParameter(P,'width',[]);         
addParameter(P,'diagonal',[]);      
addParameter(P,'hres',[]);          
addParameter(P,'vres',[]);          
addParameter(P,'outputUnit','cm');  
addParameter(P,'numDegs',1);        
addParameter(P,'imageWidth',[]);    
addParameter(P,'imageHeight',[]);   

parse(P,varargin{:});

dist = P.Results.distance;
height = P.Results.height;
width = P.Results.width;
diagonal = P.Results.diagonal;
hres = P.Results.hres;
vres = P.Results.vres;
outputUnit = P.Results.outputUnit;
numDegs = P.Results.numDegs;
imageWidth = P.Results.imageWidth;
imageHeight = P.Results.imageHeight;

computeDegVisAngle_helper(dist,height,width,diagonal,hres,vres,outputUnit,numDegs,imageWidth,imageHeight);


    
  