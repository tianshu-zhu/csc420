%templates{idx} = imread( fullfile( inputFolder , templateFile ) ) ;
%dimensions(idx).height = size( templates{idx},1) ;
%dimensions(idx).width  = size( templates{idx},2) ;

%q3 b
[templates, dimensions] = readInTemplates;

%q3 c
img = double(rgb2gray(imread('thermometer.png')));
figure;
imagesc(img);
[height, width] = size(img);
%figure;imagesc(img);axis image;colormap gray;
for( i = 1 : 30 )
    temp = double(rgb2gray((templates{i})));
    originalCorr = normxcorr2(temp, img);
    offx = round(dimensions(i).width);
    offy = round(dimensions(i).height);
    newCorr = originalCorr(offy: offy + height - 1, offx: offx + width - 1);
    corrArray(:, :, i) = newCorr;    
end

%q3 d
[maxCorr, maxIdx] = max(corrArray, [], 3);

%q3 e
candidates = q3_e(maxCorr, 0.65);

%q3 f
q3_f;