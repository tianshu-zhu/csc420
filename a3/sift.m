% img1: moving image
% img2: fixed image
% threshold: for sift matching, default 0.8
% return a mx5 matrix match where 1,2 col are coor of moving image, 
% 3,4 col are coor of fixed image, 5 col is score
function match = sift(img1, img2, threshold)

% extract sift key points
[f1, d1] = vl_sift(img1); % each col of f is [x; y; radius; orientation]
[f2, d2] = vl_sift(img2); % each col of d is 128 d sift descriptor

% match sift key points
% each row of match is matched [coor1 coor2 dist]
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
        if size(match,1) == 0 ||...
                ~(ismember(coor1', match(1:2,:)', 'rows') || ismember(coor2', match(3:4,:)', 'rows'))
            match = [match [coor1; coor2; min_dist1]];
        end
    end
end
match = sortrows(match', 5);
% [matches, scores] = vl_ubcmatch(d1, d2, threshold);
% coor1s = f1(1:2,matches(1,:));
% coor2s = f2(3:4,matches(2,:));
% match = [coor1s' coor2s' scores'];