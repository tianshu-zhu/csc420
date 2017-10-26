% match: match matrix from sift(). Note to set img1 as moving image, set
% img2 as fixed image.
% threshold: for ransac, default 1
% round: round of ransac, default 15
% return a affine transformation based on match
function bestTform = ransac(match, threshold, round)

% q2 a:Ransac
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Do round of random sample
numMatch = size(match, 1);
maxNumInliers = -1;
for i = 1:round
    % pick 3 paris randomly and compute transformation
    randPairs = match(randperm(numMatch, 3), :);
    movingPoints = randPairs(:,1:2);
    fixedPoints = randPairs(:,3:4);
    tform = fitgeotrans(movingPoints, fixedPoints, 'affine');
    % count inliers with threshold, pick the transformation with most
    % inliers
    % x' between [x-threshold, x+threshold] is inlier
    movingMatches = match(:, 1:2);
    fixedMatches = match(:, 3:4);
    transedMovingMatches = transformPointsForward(tform,movingMatches);
    numInliers = sum(sum(abs(fixedMatches - transedMovingMatches) <= threshold));
    if numInliers > maxNumInliers
        maxNumInliers = numInliers;
        bestTform = tform;
    end
end
% fprintf('%d\n', maxNumInliers);