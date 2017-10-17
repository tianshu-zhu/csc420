% extract sift frames and decriptors
% each col of f is [x; y; radius; orientation]
% each col of d is 128 d sift descriptor
img1 = single(imread('colourTemplate.png'));
img2 = single(imread('colourSearch.png'));
[f1r, d1r] = vl_sift(img1(:, :, 1)); 
[f1g, d1g] = vl_sift(img1(:, :, 2));
[f1b, d1b] = vl_sift(img1(:, :, 3));
[f2r, d2r] = vl_sift(img2(:, :, 1)); 
[f2g, d2g] = vl_sift(img2(:, :, 2)); 
[f2b, d2b] = vl_sift(img2(:, :, 3));
f1 = [f1r f1g f1b];
d1 = [d1r d1g d1b];
f2 = [f2r f2g f2b];
d2 = [d2r d2g d2b];


% matching algorithm
% compute matching for RGB seperatly, and put them all into match
distsr = pdist2(double(d1r)', double(d2r)');
distsg = pdist2(double(d1g)', double(d2g)');
distsb = pdist2(double(d1b)', double(d2b)');

threshold = 0.1;
matchr = []; 
for i = 1:size(d1r, 2)
    [min_dist1, j] = min(distsr(i, :));
    sorted_dists = sort(distsr(i, :));
    min_dist2 = sorted_dists(2);
    rr = min_dist1/min_dist2; % reliability ratio
    if  rr < threshold
        coor1 = f1r(1:2, i);
        coor2 = f2r(1:2, j);
        matchr = [matchr [coor1; coor2; min_dist1]];
    end
end

matchg = []; 
for i = 1:size(d1g, 2)
    [min_dist1, j] = min(distsg(i, :));
    sorted_dists = sort(distsg(i, :));
    min_dist2 = sorted_dists(2);
    rr = min_dist1/min_dist2; % reliability ratio
    if  rr < threshold
        coor1 = f1g(1:2, i);
        coor2 = f2g(1:2, j);
        matchg = [matchg [coor1; coor2; min_dist1]];
    end
end

matchb = []; 
for i = 1:size(d1b, 2)
    [min_dist1, j] = min(distsb(i, :));
    sorted_dists = sort(distsb(i, :));
    min_dist2 = sorted_dists(2);
    rr = min_dist1/min_dist2; % reliability ratio
    if  rr < threshold
        coor1 = f1b(1:2, i);
        coor2 = f2b(1:2, j);
        matchb = [matchb [coor1; coor2; min_dist1]];
    end
end

match = [matchr matchg matchb];
match = sortrows(match', 5)';



% compute affine transformation
k = 15;
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

% visualize affine transformation
A = [a(1) a(2) a(5); a(3) a(4) a(6)]; % reshape of a
tl1 = [1; 1]; tr1 = [size(img1, 2); 1]; % 4 corners of img1
bl1 = [1; size(img1, 1)]; br1 = [size(img1, 2); size(img1, 1)]; 

tl2 = A*[tl1; 1]; tr2 = A*[tr1; 1]; % 4 corners computed in img2
bl2 = A*[bl1; 1]; br2 = A*[br1; 1];
corners = [tl2 tr2 br2 bl2 tl2];
q2e = figure; imagesc(imread('colourSearch.png')); truesize(q2e);
hold on;
plot(corners(1, :), corners(2, :), 'b-', 'LineWidth', 2);
