function  [rows, cols] = NMS(img, radius, threshold)

% q1 b: non_maximal supression
% Build a circular domain with radius
length = radius*2+1;
[x,y] = meshgrid(1:length,1:length);
center = [mean(x(:)) mean(y(:))];
distance = sqrt(((x-center(1)).^2+(y-center(2)).^2));
domain = double(distance <= radius);

% apply non_maximal supression and threshold to reliability ratios. plot
% out the remaining interest points
order = sum(domain(:));
imgfilt = ordfilt2(img, order, domain);
[rows, cols]  = find((double(imgfilt == img) & double(img > threshold)));