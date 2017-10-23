% q2 a: extract sift frames and decriptors
img1 = single(rgb2gray(imread('book.jpg')));
img2 = single(rgb2gray(imread('findBook.jpg')));
[f1, d1] = vl_sift(img1); % each col of f is [x; y; radius; orientation]
[f2, d2] = vl_sift(img2); % each col of d is 128 d sift descriptor

% q2 b: matching algorithm
match = []; % each colomn of match is matched [i; j; dist]
dists = pdist2(double(d1)', double(d2)');
threshold = 0.8;
for i = 1:size(d1, 2)
    [min_dist1, j] = min(dists(i, :));
    sorted_dists = sort(dists(i, :));
    min_dist2 = sorted_dists(2);
    rr = min_dist1/min_dist2; % reliability ratio
    if  rr < threshold
        coor1 = f1(1:2, i);
        coor2 = f2(1:2, j);
        match = [match [coor1; coor2; min_dist1]];
    end
end
match = sortrows(match', 5)';

% visualize matching
matching = figure;
showMatchedFeatures(img1,img2,match(1:2, :)',match(3:4, :)', 'montage');

% q2 c: affine transformation
k = 20;
p1 = zeros(2*k, 6); % p2 = p1*a = T(p1)
p2 = zeros(2*k, 1); % img1 transform to img2
for i = 1:k
    
    coor1 = match(1:2, i);
    coor2 = match(3:4, i);
    p1(2*i-1, :) = [coor1' 0 0 1 0];
    p1(2*i, :) = [0 0 coor1' 0 1];
    p2(2*i-1, 1) = coor2(1);
    p2(2*i, 1) = coor2(2);
end
a = linsolve(p1' * p1, p1' * p2);

% q2 d: visualize affine transformation
A = [a(1) a(2) a(5); a(3) a(4) a(6)]; % reshape of a
tl1 = [1; 1]; tr1 = [size(img1, 2); 1]; % 4 corners of img1
bl1 = [1; size(img1, 1)]; br1 = [size(img1, 2); size(img1, 1)]; 

tl2 = A*[tl1; 1]; tr2 = A*[tr1; 1]; % 4 corners computed in img2
bl2 = A*[bl1; 1]; br2 = A*[br1; 1];
corners = [tl2 tr2 br2 bl2 tl2];
q2_d = figure; 
imagesc(imread('findBook.jpg')); 
truesize(q2_d); 
title('k = 15'); 
hold on;
plot(corners(1, :), corners(2, :), 'b-', 'LineWidth', 2);
