
bestPatch = single([cuts(:,:,4) cuts(:,:,3) cuts(:,:,6)]); 
imagesc(bestPatch);
bestMatch = sift(mugshot, bestPatch, 0.8);
bestTform = ransac(bestMatch, 2, 100);
transformedMugshot = imwarp(mugshot, bestTform);
imshowpair(bestPatch, transformedMugshot, 'montage');
bestLoss = ssd(bestMatch, bestTform);