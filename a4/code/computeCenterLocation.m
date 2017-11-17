function ds = computeCenterLocation(ds, location)
% given ds and corresponding 3d locations
% compute center location for each detection and store them back into ds
% col 7:9 in ds are center locations
num_detections = size(ds, 1);
num_rows = size(location, 1);
num_cols = size(location, 2);
if num_detections > 0
    if  size(ds, 2) == 6
        ds = [ds zeros(num_detections, 3)];
    end
    for row = 1:num_detections
        x_left = round(ds(row, 1)); x_left = min(max(x_left, 1), num_cols);
        x_right = round(ds(row, 3)); x_right = min(max(x_right, 1), num_cols);
        y_top = round(ds(row, 2)); y_top = min(max(y_top, 1), num_rows);
        y_bottom = round(ds(row, 4)); y_bottom = min(max(y_bottom, 1), num_rows);

        detection_location = location(y_top:y_bottom, x_left:x_right, :);
        center_location = reshape(mean(mean(detection_location, 1), 2), [1 3]);
        ds(row, 7:9) = center_location;
    end
else
    ds = zeros(0, 9);
end

 