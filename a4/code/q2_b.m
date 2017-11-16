globals;
test_fid = fopen(fullfile(TEST_DIR, 'test.txt'));
imname = fgetl(test_fid);

% detext car, cyclist, person for all test image and save into results
% save will overwrite the file if exist
while ischar(imname)
    [car_ds, car_bs] = detectObject('detector-car', imname, -0.6, 0.1);
    car_ds_filename = fullfile(RESULTS_DIR, strcat(imname, '_car_ds.mat'));
    car_bs_filename = fullfile(RESULTS_DIR, strcat(imname, '_car_bs.mat'));
    save(car_ds_filename, 'car_ds');
    save(car_bs_filename, 'car_bs');
    
    [cyclist_ds, cyclist_bs] = detectObject('detector-cyclist', imname, 0, 0.1);
    cyclist_ds_filename = fullfile(RESULTS_DIR, strcat(imname, '_cyclist_ds.mat'));
    cyclist_bs_filename = fullfile(RESULTS_DIR, strcat(imname, '_cyclist_bs.mat'));
    save(cyclist_ds_filename, 'cyclist_ds');
    save(cyclist_bs_filename, 'cyclist_bs');
    
    [person_ds, person_bs] = detectObject('detector-person', imname, -0.6, 0.1);
    person_ds_filename = fullfile(RESULTS_DIR, strcat(imname, '_person_ds.mat'));
    person_bs_filename = fullfile(RESULTS_DIR, strcat(imname, '_person_bs.mat'));
    save(person_ds_filename, 'person_ds');
    save(person_bs_filename, 'person_bs');

    imname = fgetl(test_fid);
end
fclose(test_fid);