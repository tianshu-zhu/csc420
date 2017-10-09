% q1 a: corner detection
image = imread('building.jpg'); % imagesc(image);
I = double(rgb2gray(image));
[rows, cols] = size(I);

[Ix, Iy] = imgradientxy(I, 'prewitt'); % compute average Ix2, Iy2, Ixy
sigma = 5;
avg_Ix2 = imgaussfilt(Ix.^2, sigma);
avg_Iy2 = imgaussfilt(Iy.^2, sigma);
avg_Ixy = imgaussfilt(Ix.*Iy, sigma);

alpha = 0.06; % alpha is a constat (0.04 to 0.06)
R1 = (avg_Ix2.*avg_Iy2 - avg_Ixy.^2) - alpha.*((avg_Ix2 + avg_Iy2).^2);
imagesc(R1);


% q1 b: non_maximal supression
% Build a circular domain with radius
radius = 3; 
threshold = 1e8;
length = radius*2+1;
[x,y] = meshgrid(1:length,1:length);
center = [mean(x(:)) mean(y(:))];
distance = sqrt(((x-center(1)).^2+(y-center(2)).^2));
domain = double(distance <= radius);

% apply non_maximal supression and threshold to reliability ratios. plot
% out the remaining interest points
order = sum(domain(:));
R2 = ordfilt2(R1, order, domain);
[rows, cols]  = find((double(R2 == R1) & double(R1 > threshold)));
figure;
imagesc(image);
hold on;
plot(cols, rows, 'yo');
