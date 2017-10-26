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
clear
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

% greedy approach
% starts with cut1, patch another cut with minimal ssd on its left or right side
% get a patch of 2 cuts, then patch another cut with the previous result
% so on until patched all the cuts
result = [1 2 3 4 5 6];
for j = 1:5 % 6 cuts, patch 5 times
    % patch another cut with the previous result based on the ssd
    minLoss = inf(1);
    for l = j+1:6
        for m = 1:j+1 % patching
            left = reshape(cuts(:,:,result(1:m-1)), dss(1), dss(2)*(m-1));
            middle = cuts(:,:,result(l));
            right = reshape(cuts(:,:,result(m:j)), dss(1), dss(2)*(j-m+1));
            patch = single([left middle right]); 
            imagesc(patch);
            match = sift(mugshot, patch, 0.8);
            tform = ransac(match, 2, 10);
            loss = ssd(match, tform);
            if minLoss > loss
                minLoss = loss;
                from = l;
                to = m;
            end
        end
    end
    % update result
    result = [result(1:to-1) result(from) result(to:from-1) result(from+1:6)];
end

resultImage = [cuts(:,:,result(1)) cuts(:,:,result(2)) cuts(:,:,result(3))...
    cuts(:,:,result(4)) cuts(:,:,result(5)) cuts(:,:,result(6))];
figure; imagesc(resultImage);