% select 4 pairs of control points and compute projective transformation
% and apply that transformation to shoe.jpg
[movingPoints,fixedPoints] = cpselect('shoe.jpg','5dollars.jpg','Wait',true);
tform = fitgeotrans(movingPoints,fixedPoints,'projective');
img = imread('shoe.jpg');
timg = imwarp(img, tform);

% select a 8 pairs of points in shoe.jpg to compute the relative width and
% length (shoe/bill). 
% 1:2 pairs are for shoe width
% 3:4 pairs are for shoe length
% 5:6 pairs are for bill width
% 7:8 pairs are for bill length
f = figure; imshow(timg); truesize(f); 
[x,y] = ginput(8);

shoeWidthPoints = [x(1:2, :) y(1:2, :)];
shoeWidth = norm(shoeWidthPoints(1,:)-shoeWidthPoints(2,:));

shoeLengthPoints = [x(3:4, :) y(3:4, :)];
shoeLength = norm(shoeLengthPoints(1,:)-shoeLengthPoints(2,:));

billWidthPoints = [x(5:6, :) y(5:6, :)];
billWidth = norm(billWidthPoints(1,:)-billWidthPoints(2,:));

billLengthPoints = [x(7:8, :) y(7:8, :)];
billLength = norm(billLengthPoints(1,:)-billLengthPoints(2,:));

relativeWidth = shoeWidth/billWidth;
relativeLength = shoeLength/billLength;

% compute shoe width and length based on bill's width and length in cm
billTrueWidth = 6.985;
billTrueLength = 15.24;
shoeTruewidth = billTrueWidth*relativeWidth;
shoeTrueLength = billTrueLength*relativeLength;
