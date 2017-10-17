%q1_c: detect scale invariant interest points
image = imread('building.jpg'); 
q1c = figure; imagesc(image); truesize(q1c);
img = mean(double(image), 3);

% perform base-level smoothing to supress noise
clear responseLoG;
k = 1.1;
sigma = 2.0;
s = k.^(1:30).*(sigma^2);
responseLoG = zeros(size(img,1),size(img,2),size(s, 2));

% Filter over a set of scales
for si = 1:size(s, 2)
    sL = floor(s(si));
    hs= floor(sL*3);
    HL = fspecial('log',[hs hs],sL);
    imgFiltL = conv2(img, HL, 'same');
    %Compute the LoG
    responseLoG(:,:,si)  = abs((sL^2)*imgFiltL);
end

% get max value at each pixel, and its scale
[Mlog, Ilog] = max(responseLoG, [], 3);

% do non_maximal supression
radius = 10; 
threshold = 50;
[rows, cols]  = NMS(Mlog, radius, threshold);

% plot the founded interest
for i = 1:size(rows, 1)
    % Draw a circle
    sc = s(Ilog(rows(i), cols(i)));
    xc = sc*sin(0:0.1:2*pi)+cols(i);
    yc = sc*cos(0:0.1:2*pi)+rows(i);
    hold on;
    plot(xc,yc,'r');
    drawnow;
end