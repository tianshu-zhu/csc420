globals;
imnames = {'004945', '004964', '005002'};
for i = 1:length(imnames)
    imname = imnames{i};
    depth_data = getData(imname, 'test', 'depth');
    depth = depth_data.data;
    calib_data
    
end