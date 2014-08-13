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

function computeDegVisAngle_helper(dist,height,width,diagonal,hres,vres,outputUnit,numDegs,imageWidth,imageHeight)

assert(~isempty(dist),'Must provide distance to screen.')
temp = regexp(dist,'([\d\.]*)([ a-zA-Z]*)','tokens');
temp = temp{1};
d = str2num(temp{1});
u = temp{2};

if isempty(numDegs)
   numDegs = 1;
end

assert(~isempty(hres)&&~isempty(vres),...
    'Must provide either horizontal (hres) or vertical (vres) screen resolution in pixels.')
r1 = hres;
r2 = vres;

if isempty(height) && isempty(width)
    assert(~isempty(diagonal),'Must provide either a screen dimension or screen diagonal.')
    temp = regexp(diagonal,'([\d\.]*)([ a-zA-Z]*)','tokens');
    temp = temp{1};
    s_diag = str2num(temp{1});
    u1 = temp{2};
    u2 = temp{2};
    factor = s_diag/sqrt(r1^2 + r2^2);
    s1 = (r1)*factor; % width
    s2 = (r2)*factor; % height
    fprintf('Screen size estimated based on diagonal and resolution = %2.2f%s x %2.2f%s\n',s1,u1,s2,u2)
else
    if ~isempty(width)
        temp = regexp(width,'([\d\.]*)([ a-zA-Z]*)','tokens');
        temp = temp{1};
        s1 = str2num(temp{1});
        u1 = temp{2};
    else
        s1 = []; u1 = [];
    end
    if ~isempty(height)
        temp = regexp(height,'([\d\.]*)([ a-zA-Z]*)','tokens');
        temp = temp{1};
        s2 = str2num(temp{1});
        u2 = temp{2};
    else
        s2 = []; u2 = [];
    end
end

% convert units to outputUnit for further calculations
d = d*unitsratio(outputUnit,u); 
fprintf('Distance in %s: %2.2f\n',outputUnit,d);
if ~isempty(s1)
    s1 = s1*unitsratio(outputUnit,u1); 
    fprintf('Screen width in %s: %2.2f\n',outputUnit,s1)
end
if ~isempty(s2)
    s2 = s2*unitsratio(outputUnit,u2); 
    fprintf('Screen height in %s: %2.2f\n',outputUnit,s2)
end
    

if ~isempty(s1) && ~isempty(u1)

    horz_deg_screen = rad2deg(2*atan2(s1,2*d));
    horz_1deg = (r1/s1)*d*tan(deg2rad(numDegs));
    
    fprintf('Width of screen subtends %2.2f%c visual angle\n',horz_deg_screen,char(176))
    fprintf('%g%c of horizontal visual angle: %2.2f pixels\n',numDegs,char(176),horz_1deg)
end
    
if ~isempty(s2) && ~isempty(u2)
    
    vert_deg_screen = rad2deg(2*atan2(s2,2*d));
    vert_1deg = (r2/s2)*d*tan(deg2rad(numDegs));
    
    fprintf('Height of screen subtends %2.2f%c visual angle\n',vert_deg_screen,char(176))
    fprintf('%g%c of vertical visual angle: %2.2f pixels\n',numDegs,char(176),vert_1deg)

end

if ~isempty(imageWidth)
    temp = imageWidth*s1/r1;
    horz_deg = rad2deg(2*atan2(temp,2*d));
    fprintf('Image width subtends %2.2f%c visual angle\n',horz_deg,char(176))
end

if ~isempty(imageHeight)
    temp = imageHeight*s2/r2;
    vert_deg = rad2deg(2*atan2(temp,2*d));
    fprintf('Image height subtends %2.2f%c visual angle\n',vert_deg,char(176))
end