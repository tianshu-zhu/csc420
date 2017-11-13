camera_parameters = getData('004945', 'test', 'calib');
f = camera_parameters.f;
T = camera_parameters.baseline;

disparity_struct = getData('004945', 'test', 'disp');
disparity = disparity_struct.disparity;

depth = f*T./(disparity);
figure('position', [100, 100,size(disparity,2)*0.7, size(disparity,1)*0.7]);
subplot('position', [0,0,1,1]);
imagesc(depth);
axis equal;
