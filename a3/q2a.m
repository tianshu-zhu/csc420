% q2 a: ransac %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img1 = single(rgb2gray(imread('book.jpg')));
img2 = single(rgb2gray(imread('findBook.jpg')));
match = sift(img1, img2, 0.8);
tform = ransac(match, 1, 10);

img = imread('book.jpg');
transformedImg = imwarp(img, tform);
f= figure;
imshowpair(transformedImg, imread('findBook.jpg'), 'montage');

