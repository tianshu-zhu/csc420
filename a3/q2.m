% q2 a: ransac %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% img1 = single(rgb2gray(imread('book.jpg')));
% img2 = single(rgb2gray(imread('findBook.jpg')));
% match = sift(img1, img2, 0.8);
% tform = ransac(match, 1, 10);
% 
% img = imread('book.jpg');
% timg = imwarp(img, tform);
% f= figure; imshow(timg); truesize(f);

% q2 b: reassembling use SSD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize some variables
dsr = 0.25; % down sample rate
dss = [round(968*dsr) round(216*dsr)]; % down sample size of cut
mugshot = imresize(single(rgb2gray(imread('mugShot.jpg'))), dsr);
cuts = zeros(dss(1), dss(2), 5); % array of 5 cuts
for i=1:6
    fileName = ['shredded/cut0', num2str(i), '.png'];
    cut = imresize(single(rgb2gray(imread(fileName))), dsr);
    cuts(:,:,i) = cut(1:dss(1), 1:dss(2));
end

% dynamic approach
% starts with cut1, patch another cut with minimal ssd on its left or right side
% get a patch of 2 cuts, then patch another cut with the previous result
% so on until patched all the cuts
result = [4 3 6 1 5 2];
for j = 1:5 % 6 cuts, patch 5 times
    % get the result of previous patching, starts with cut1
    center = zeros(dss(1), dss(2)*j);
    for k = 1:j
        center(:,(dss(2)*(k-1)+1):(dss(2)*k)) = cuts(:,:,result(k));
    end
    minSsd = inf(1);
    % patch another cut with the previous result based on the ssd
    for l = j+1:6
        leftPerm = single([cuts(:,:,result(l)) center]); % patching
        leftMatch = sift(mugshot, leftPerm, 0.8);
        leftTform = ransac(leftMatch, 1, 10);
        leftSsd = ssd(leftMatch, leftTform);
        
        rightPerm = single([center cuts(:,:,result(l))]); % patching
        rightMatch = sift(mugshot, rightPerm, 0.8);
        rightTform = ransac(rightMatch, 1, 10);
        rightSsd = ssd(rightMatch, rightTform);
        
        if minSsd > min(leftSsd, rightSsd);
            minSsd = min(leftSsd, rightSsd);
            patchedCut = result(l);
            if min(leftSsd, rightSsd) == leftSsd
                leftOrRight = 'l';
            else
                leftOrRight = 'r';
            end
        end
    end
    % update result
    part1 = result(1:j);
    part2 = result(j+1:6);
    part2 = part2(find(part2~=patchedCut));
    if leftOrRight == 'l'
        result = [patchedCut result(1:j) part2];
    else
        result = [result(1:j) patchedCut part2];
    end
end

resultImage = [cuts(:,:,result(1)) cuts(:,:,result(2)) cuts(:,:,result(3))...
    cuts(:,:,result(4)) cuts(:,:,result(5)) cuts(:,:,result(6))];
figure; imagesc(resultImage);