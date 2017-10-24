% img1: moving image
% img2: fixed image
% threshold: for sift matching, default 0.8
function match = sift(img1, img2, threshold)

% extract sift key points
[f1, d1] = vl_sift(img1); % each col of f is [x; y; radius; orientation]
[f2, d2] = vl_sift(img2); % each col of d is 128 d sift descriptor

% match sift key points
% each colomn of match is matched [coor1; coor2; dist]
match = []; 
dists = pdist2(double(d1)', double(d2)');
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
match = sortrows(match', 5);