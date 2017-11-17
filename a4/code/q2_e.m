globals;
imnames = {'004945', '004964', '005002'};
for i = 1:length(imnames)
    imname = imnames{i};
    % get location, ds and (center location)
    location_data = getData(imname, 'test', 'location');
    location = location_data.location;
    car_ds_data = getData(imname, 'test', 'car_ds');
    car_ds = car_ds_data.car_ds;
    person_ds_data = getData(imname, 'test', 'person_ds');
    person_ds = person_ds_data.person_ds;
    cyclist_ds_data = getData(imname, 'test', 'cyclist_ds');
    cyclist_ds = cyclist_ds_data.cyclist_ds;
    
    % concatenate all ds together
    all_ds = [car_ds; person_ds; cyclist_ds];
    num_rows = size(location, 1);
    num_cols = size(location, 2);
    num_detections = size(all_ds, 1);
    segmentation = zeros(num_rows, num_cols);
    
    % find and label all pixel that is segmented
    for j = 1:num_detections
        center_location = all_ds(j, 7:9);
        x_left = round(all_ds(j, 1)); x_left = min(max(x_left, 1), num_cols);
        x_right = round(all_ds(j, 3)); x_right = min(max(x_right, 1), num_cols);
        y_top = round(all_ds(j, 2)); y_top = min(max(y_top, 1), num_rows);
        y_bottom = round(all_ds(j, 4)); y_bottom = min(max(y_bottom, 1), num_rows);
        for col = x_left:x_right
            for row = y_top:y_bottom              
                if norm(reshape(location(row, col, :), [1 3])-center_location) <= 15
                    segmentation(row, col) = j;
                end
            end
        end
    end
    f = figure;
    imagesc(segmentation);
    truesize(f);
end