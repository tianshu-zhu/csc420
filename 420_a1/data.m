%templates{idx} = imread( fullfile( inputFolder , templateFile ) ) ;%dimensions(idx).height = size( templates{idx},1) ;%dimensions(idx).width  = size( templates{idx},2) ;%q3 b[templates, dimensions] = readInTemplates;%q3 cimg = double(rgb2gray(imread('thermometer.png')));[height, width] = size(img);for( i = 1 : 30 )    temp = double(rgb2gray((templates{i})));    originalCorr = normxcorr2(temp, img);    offx = round(dimensions(i).width/2);    offy = round(dimensions(i).height/2);    newCorr = originalCorr(offy: offy + height - 1, offx: offx + width - 1);    corrArray(:, :, i) = newCorr;    end%q3 d[maxCorr, maxIdx] = max(corrArray, [], 3);