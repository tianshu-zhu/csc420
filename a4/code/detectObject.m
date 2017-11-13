function ds = detectObject(detectorType, imname, model_thresh, nms_thresh)

data = getData([], [], detectorType);
model = data.model;
col = 'r';

imdata = getData(imname, 'test', 'left');
im = imdata.im;
f = 1.5;
imr = imresize(im,f); % if we resize, it works better for small objects

% detect objects
fprintf('running the detector, may take a few seconds...\n');
tic; % measure running time
[ds, bs] = imgdetect(imr, model, model_thresh); % you may need to reduce the threshold if you want more detections
e = toc;
fprintf('finished! (took: %0.4f seconds)\n', e);

% non maximum suppression
top = nms(ds, nms_thresh);
if model.type == model_types.Grammar
  bs = [ds(:,1:4) bs];
end
if ~isempty(ds)
    % resize back
    ds(:, 1:end-2) = ds(:, 1:end-2)/f;
    bs(:, 1:end-2) = bs(:, 1:end-2)/f;
end;
showboxesMy(im, reduceboxes(model, bs(top,:)), col);
fprintf('detections:\n');
ds = ds(top, :);