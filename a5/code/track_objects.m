function tracks = track_objects()
% this is a very simple tracking algo
% for more serious tracking, look-up the papers in the projects pdf
% since process 2 frame at a time, then end at frame 71
FRAME_DIR = '../data/frames/';
DET_DIR = '../data/detections/';
start_frame = 62;
end_frame = 71;
tracks = {};

for i = start_frame:end_frame
    im_cur = imread(fullfile(FRAME_DIR, sprintf('%06d.jpg', i)));
    data = load(fullfile(DET_DIR, sprintf('%06d_dets.mat', i)));
    dets_cur = data.dets;
    
    im_next = imread(fullfile(FRAME_DIR, sprintf('%06d.jpg', i+1)));
    data = load(fullfile(DET_DIR, sprintf('%06d_dets.mat', i+1)));
    dets_next = data.dets;
   
    sims = compute_similarity(dets_cur, dets_next, im_cur, im_next);
    
    % add disjunct pairs greedily
    tracked = zeros(0, 2);
    while sum(sims(:)) > 0
        [sim, I] = max(sims(:));
        [det_cur, det_next] = ind2sub(size(sims), I);
        new_track = [i det_cur; i+1 det_next];
        if not(ismember(new_track(1,:), tracked, 'rows')) &&...
                not(ismember(new_track(1,:), tracked, 'rows'))
            tracked = [tracked; new_track(1,:); new_track(2,:)];
            tracks = add_track(tracks, new_track);
        end
        sims(det_cur, det_next) = 0;
    end
end;

% remove tracks with only two detections
num_track = size(tracks, 2);
for j = 1:num_track
    if size(tracks{j}, 1) == 2
        tracks{j} = [];
    end
end
tracks = tracks(~cellfun('isempty',tracks)); 

end


function tracks = add_track(tracks, new_track)
% add new_track to tracks
num_track = size(tracks,2);
is_in = 0;
for k = 1:num_track
    track = tracks{k};
    if isequal(track(size(track,1),:),new_track(1,:))
        track = [track;new_track(2,:)];
        tracks{k} = track;
        is_in = 1;
        break;
    end
end
if not(is_in)
    tracks{num_track+1} = new_track;
end

end


function sim = compute_similarity(dets_cur, dets_next, im_cur, im_next)
% sim has as many rows as dets_cur and as many columns as dets_next
% sim(k,t) is similarity between detection k in frame i, and detection
% t in frame j
% sim(k,t)=0 means that k and t should probably not be the same track
n = size(dets_cur, 1);
m = size(dets_next, 1);
sim = zeros(n, m);

area_cur = compute_area(dets_cur);
area_next = compute_area(dets_next);
c_cur = compute_center(dets_cur);
c_next = compute_center(dets_next);
im_cur = double(im_cur);
im_next = double(im_next);
weights = [1,1,2];

for i = 1: n
    % compare sizes of boxes
    a = area_cur(i) * ones(m, 1);
    sim(i, :) = sim(i, :) + weights(1) * (min(area_next, a) ./ max(area_next, a))';
    
    % penalize distance (would be good to look-up flow, but it's slow to
    % compute for images of this size)
    sim(i, :) = sim(i, :) + weights(2) * exp((-0.5*sum((repmat(c_cur(i, :), [size(c_next, 1), 1]) - c_next).^2, 2)) / 5^2)';
    
    % compute similarity of patches
    box = round(dets_cur(i, 1:4));
    box(1:2) = max([1,1],box(1:2));
    box(3:4) = [min(box(3),size(im_cur, 2)), min(box(4),size(im_cur, 1))];
    im_i = im_cur(box(2):box(4),box(1):box(3), :);
    im_i = im_i / norm(im_i(:));
    for j = 1 : m
       d = norm(c_cur(i, :) - c_next(j, :));
       if d>60  % distance between boxes too big
           sim(i,j) = 0;
           continue;
       end;
       box = round(dets_next(j, 1:4));
       box(1:2) = max([1,1],box(1:2));
       box(3:4) = [min(box(3),size(im_cur, 2)), min(box(4),size(im_cur, 1))]; 
       im_j = im_next(box(2):box(4),box(1):box(3), :);
       im_j = double(imresize(uint8(im_j), [size(im_i, 1), size(im_i, 2)]));
       im_j = im_j / norm(im_j(:));
       c = sum(im_i(:) .* im_j(:));
       sim(i,j) = sim(i,j) + weights(3) * c;
    end;
end;
end


function area = compute_area(dets)
% helper function of compute_similarity
area = (dets(:, 3) - dets(:, 1) + 1).* (dets(:, 4) - dets(:, 2) + 1);
end


function c = compute_center(dets)
% helper function of compute_similarity
c = 0.5 * (dets(:, [1:2]) + dets(:, [3:4]));
end