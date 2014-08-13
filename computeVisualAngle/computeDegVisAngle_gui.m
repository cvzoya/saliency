% created: Zoya Bylinskii, Aug 2014
% Code for computing degrees of visual angle

% This code has been written to make it easier to report visual angle in
% papers, and to ensure a standardized calculation is used.

% This code can take variable input (e.g. horizontal, vertical, or diagonal
% screen measurements in any units), and will calculate any number of 
% degrees of visual angle in pixels, as well as degrees of visual angle 
% spanned by the computer screen or an image. 

% The code is provided on: http://saliency.mit.edu/

% Resources used: http://osdoc.cogsci.nl/miscellaneous/visual-angle/, 
%                 http://en.wikipedia.org/wiki/Visual_angle
% Thank you to Lavanya Sharan and Melissa Vo for helpful discussion.

function computeDegVisAngle_gui()

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
% ratio of the screen dimensions matches that of the set resolution. 
% If these estimates look wrong, either:
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
ui=inputdlg({'distance (with units)','height (with units)',...
    'width (with units)','diagonal (with units)',...
    'horizontal resolution','vertical resolution',...
    'output units (optional)','number of degrees (optional)',...
    'image width in pixels (optional)','image height in pixels (optional)'},...
    'Visual Angle Calculator',1,...
    {'','','','','','','cm','1','',''});

dist = ui{1};
height = ui{2};
width = ui{3};
diagonal = ui{4};
hres = str2num(ui{5});
vres = str2num(ui{6});
outputUnit = ui{7};
numDegs = str2num(ui{8});
imageWidth = str2num(ui{9});
imageHeight = str2num(ui{10});

computeDegVisAngle_helper(dist,height,width,diagonal,hres,vres,outputUnit,numDegs,imageWidth,imageHeight);

    
  