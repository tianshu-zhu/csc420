globals;
imnames = {'004945', '004964', '005002'};
% test_fid = fopen(fullfile(TEST_DIR, 'test.txt'));
% imname = fgetl(test_fid);
% while ischar(imname)
for i = 1:length(imnames)
    imname = imnames{i};
    imdata = getData(imname, 'test', 'left');
    im = imdata.im;
    car_ds_data = getData(imname, 'test', 'car_ds');
    car_ds = car_ds_data.car_ds;
    person_ds_data = getData(imname, 'test', 'person_ds');
    person_ds = person_ds_data.person_ds;
    cyclist_ds_data = getData(imname, 'test', 'cyclist_ds');
    cyclist_ds = cyclist_ds_data.cyclist_ds;
    fig = figure;
    imshow(im);
    drawAndLabelBoxes(car_ds, 'car', fig);
    drawAndLabelBoxes(person_ds, 'person', fig);
    drawAndLabelBoxes(cyclist_ds, 'cyclist', fig);
    % save result
    result_name = fullfile('../results', strcat('q2_c_', imname, '.png'));
    saveas(fig, result_name); 
%     imname = fgetl(test_fid);
end
