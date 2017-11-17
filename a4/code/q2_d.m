globals;
imnames = {'004945', '004964', '005002'};
for i = 1:length(imnames)
    % get depth, K, car ds, person ds, cyclist ds
    imname = imnames{i};
    depth_data = getData(imname, 'test', 'depth');
    depth = depth_data.depth;
    calib_data = getData(imname, 'test', 'calib');
    K = calib_data.K;
    car_ds_data = getData(imname, 'test', 'car_ds');
    car_ds = car_ds_data.car_ds;
    person_ds_data = getData(imname, 'test', 'person_ds');
    person_ds = person_ds_data.person_ds;
    cyclist_ds_data = getData(imname, 'test', 'cyclist_ds');
    cyclist_ds = cyclist_ds_data.cyclist_ds;
    num_rows = size(depth, 1);
    num_cols = size(depth, 2);
    % compute and save 3d location for each pixel in image with name imname
    location = zeros(num_rows, num_cols, 3);
    for row = 1:num_rows
        x = row;
        for col = 1:num_cols
            y = num_cols+1-col;
            Z = depth(row, col);
            result = K\[x; y; 1];
            w = Z/result(3);
            X = result(1)*w;
            Y = result(2)*w;
            location(row, col, :) = [X Y Z];
        end
    end
    location_filename = fullfile(RESULTS_DIR, strcat(imname, '_location.mat'));
    save(location_filename, 'location');
    
    % compute and save center 3d location for each car detected
    car_ds = computeCenterLocation(car_ds, location);
    car_ds_filename = fullfile(RESULTS_DIR, strcat(imname, '_car_ds.mat'));
    save(car_ds_filename, 'car_ds');
    % compute and save center 3d location for each cyclist detected
    cyclist_ds = computeCenterLocation(cyclist_ds, location);
    cyclist_ds_filename = fullfile(RESULTS_DIR, strcat(imname, '_cyclist_ds.mat'));
    save(cyclist_ds_filename, 'cyclist_ds');
    
    % compute and save center 3d location for each person detected
    person_ds = computeCenterLocation(person_ds, location);
    person_ds_filename = fullfile(RESULTS_DIR, strcat(imname, '_person_ds.mat'));
    save(person_ds_filename, 'person_ds');
end