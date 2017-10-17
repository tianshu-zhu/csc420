% q1 a: corner detection
image = imread('synthetic.png'); % imagesc(image);
I = double(rgb2gray(image));

[Ix, Iy] = imgradientxy(I, 'prewitt'); % compute average Ix2, Iy2, Ixy
sigma = 5;
avg_Ix2 = imgaussfilt(Ix.^2, sigma);
avg_Iy2 = imgaussfilt(Iy.^2, sigma);
avg_Ixy = imgaussfilt(Ix.*Iy, sigma);

alpha = 0.06; % alpha is a constat (0.04 to 0.06)
R1 = (avg_Ix2.*avg_Iy2 - avg_Ixy.^2) - alpha.*((avg_Ix2 + avg_Iy2).^2);
q1_a = figure;
imagesc(R1);
truesize(q1_a);


% q1 b: non_maximal supression
radius = 20; 
threshold = 1e8;
[rows, cols]  = NMS(R1, radius, threshold);
q1_b = figure;
imagesc(image);
truesize(q1_b);
title('radius = 20');
hold on;
plot(cols, rows, 'ro', 'MarkerSize', 12);
