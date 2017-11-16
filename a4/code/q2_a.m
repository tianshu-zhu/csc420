globals;
imnames = {'004945', '004964', '005002'};
for i = 1:length(imnames)
    imname = imnames{i};
    % compute depth
    camera_parameters = getData(imname, 'test', 'calib');
    f = camera_parameters.f;
    T = camera_parameters.baseline;
    disparity_struct = getData(imname, 'test', 'disp');
    disparity = disparity_struct.disparity;
    depth = f*T./(disparity);
    % save depth
    depth_filename = fullfile(RESULTS_DIR, strcat(imname, '_depth.mat'));
    save(depth_filename, 'depth');
    % plot depth
    figure('position', [100, 100,size(disparity,2)*0.7, size(disparity,1)*0.7]);
    subplot('position', [0,0,1,1]);
    imagesc(depth, [0,256]);
    axis equal;
end