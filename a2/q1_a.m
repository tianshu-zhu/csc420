image = imread('building.jpg');
% imagesc(image);
I = double(rgb2gray(image));
[rows, cols] = size(I);

% compute average Ix2, Iy2, Ixy
[Ix, Iy] = imgradientxy(I, 'prewitt');
sigma = 10;
avg_Ix2 = imgaussfilt(Ix.^2, sigma);
avg_Iy2 = imgaussfilt(Iy.^2, sigma);
avg_Ixy = imgaussfilt(Ix.*Iy, sigma);

% alpha is a constat (0.04 to 0.06)
alpha = 0.04;
threshold = 20;
R = (avg_Ix2.*avg_Iy2 - avg_Ixy.^2) - alpha.*((avg_Ix2 + avg_Iy2).^2);
imagesc(R);
max(R(:))
min(R(:))

% for row = 1:rows
%     for col = 1:cols
%         M = [avg_Ix2(row, col) avg_Ixy(row, col);...
%             avg_Ixy(row, col) avg_Iy2(row, col)];
%         R = det(M) - alpha.*(trace(M).^2)
%         % hm = det(M)/trace(M);
%         if (R > threshold)
%             hold on;
%             plot(col, row, 'MarkerSize', 10);
%             drawnow;
%         end
%     end
% end
   
