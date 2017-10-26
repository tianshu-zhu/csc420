% given match and tform, return the SSD
function loss = ssd(match, tform)
movingx = match(:,1);
movingy = match(:,2);
fixedx = match(:,3);
fixedy = match(:,4);
[transformedx, transformedy] = transformPointsForward(tform, movingx, movingy);
num = size(match, 1);
loss = sum((transformedx - fixedx).^2 + (transformedy - fixedy).^2)/num;
