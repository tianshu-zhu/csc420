% q2 a: ransac %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img1 = single(rgb2gray(imread('book.jpg')));
img2 = single(rgb2gray(imread('findBook.jpg')));
match = sift(img1, img2, 0.8);
tform = ransac(match, 1, 15);

img = imread('book.jpg');
timg = imwarp(img, tform);
f= figure; imshow(timg); truesize(f);

% q2 b: reassembling use SSD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


