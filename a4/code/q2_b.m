globals;
test_fid = fopen(fullfile(TEST_DIR, 'test.txt'));
imname = fgetl(test_fid);

% detext car, cyclist, person for all test image and save into results
% save will overwrite the file if exist
while ischar(imname)
    car_ds = detectObject('detector-car', imname, -0.6, 0.25);
    car_filename = fullfile(RESULTS_DIR, strcat(imname, '_car.mat'));
    save(car_filename, 'car_ds');
    
    cyclist_ds = detectObject('detector-cyclist', imname, -0.35, 0.05);
    cyclist_filename = fullfile(RESULTS_DIR, strcat(imname, '_cyclist.mat'));
    save(cyclist_filename, 'cyclist_ds');
    
    person_ds = detectObject('detector-person', imname, -0.6, 0.25);
    person_filename = fullfile(RESULTS_DIR, strcat(imname, '_person.mat'));
    save(person_filename, 'person_ds');
    
    imname = fgetl(test_fid);
end
fclose(test_fid);