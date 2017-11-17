globals;
imnames = {'004945', '004964', '005002'};
for i = 1:length(imnames)
    imname = imnames{i};
    % get ds and (center location)
    car_ds_data = getData(imname, 'test', 'car_ds');
    car_ds = car_ds_data.car_ds;
    person_ds_data = getData(imname, 'test', 'person_ds');
    person_ds = person_ds_data.person_ds;
    cyclist_ds_data = getData(imname, 'test', 'cyclist_ds');
    cyclist_ds = cyclist_ds_data.cyclist_ds;
    num_car = size(car_ds, 1);
    num_person = size(person_ds, 1);
    num_cyclist = size(cyclist_ds, 1);
    
    % concatenate ds together, label car as 1, person as 2, cyclist as 3
    all_ds = [car_ds; person_ds; cyclist_ds];
    all_ds(1:num_car, 10) = 1;
    all_ds(num_car+1:num_car+num_person, 10) = 2;
    all_ds(num_car+num_person+1:num_car+num_person+num_cyclist, 10) = 3;
    num_detections = size(all_ds, 1);
    
    % find closed object type and distance
    closest_distance = inf(1);
    closest_object = 'unknown';
    left_right = 'unknown';
    for j = 1:num_detections
        distance = norm(all_ds(j,7:9));
        if distance < closest_distance
            closest_distance = distance;
            if all_ds(j, 7) < 0
                left_right = 'left';
            else
                left_right = 'right';
            end
            switch all_ds(j, 10)
                case 1
                    closest_object = 'car';
                case 2
                    closest_object = 'person';
                case 3
                    closest_object = 'cyclist';
            end
        end
    end
    fprintf('for image %s: %d car, %d person, and %d cyclist are detected.\n',...
        imname, num_car, num_person, num_cyclist);
    fprintf('There is a %s on your %s, which is %d meters away from you\n\n',...
        closest_object, left_right, round(closest_distance));
end