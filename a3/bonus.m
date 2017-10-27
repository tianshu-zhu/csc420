% Depth Intrinsic Parameters
fx_d = 5.8262448167737955e+02;
fy_d = 5.8269103270988637e+02;
px_d = 3.1304475870804731e+02;
py_d = 2.3844389626620386e+02;

% Rotation
R = -[ 9.9997798940829263e-01, 5.0518419386157446e-03, ...
   4.3011152014118693e-03, -5.0359919480810989e-03, ...
   9.9998051861143999e-01, -3.6879781309514218e-03, ...
   -4.3196624923060242e-03, 3.6662365748484798e-03, ...
   9.9998394948385538e-01 ];

R = reshape(R, [3 3]);
R = inv(R');

% 3D Translation
t_x = 2.5031875059141302e-02;
t_z = -2.9342312935846411e-04;
t_y = 6.6238747008330102e-04;

%a
load('rgbd.mat');
K = [fx_d 0 px_d; 0 fy_d py_d; 0 0 1];

xyz = zeros(480, 640, 3);
for x = 1:640
    for y = 1:480
        w = depth(y,x);
        wx = w*x;
        wy = w*y;
        coor = linsolve(K, [wx; wy; w]);
        xyz(y,x,:) = coor;
    end
end
x = reshape(xyz(:, :, 1), [1, 480*640]);
y = reshape(xyz(:, :, 2), [1, 480*640]);
z = reshape(xyz(:, :, 3), [1, 480*640]);
figure; plot3(x, y, z);

%b
[y1,x1] = find(labels==1);
[y2,x2] = find(labels==2);
[y3,x3] = find(labels==3);
[y4,x4] = find(labels==4);

xyz1 = zeros(size(x1, 1), 3);
for i = 1:size(x1, 1)
    xyz1(i,:) = xyz(y1(i), x1(i), :);
end
avgxyz1 = mean(xyz1, 1);
d1 = norm(avgxyz1);
h1 = (-1)*avgxyz1(2);

xyz2 = zeros(size(x2, 1), 3);
for i = 1:size(x2, 1)
    xyz2(i,:) = xyz(y2(i), x2(i), :);
end
avgxyz2 = mean(xyz2, 1);
d2 = norm(avgxyz2);
h2 = (-1)*avgxyz2(2);

xyz3 = zeros(size(x3, 1), 3);
for i = 1:size(x3, 1)
    xyz3(i,:) = xyz(y3(i), x3(i), :);
end
avgxyz3 = mean(xyz3, 1);
d3 = norm(avgxyz3);
h3 = (-1)*avgxyz3(2);

xyz4 = zeros(size(x4, 1), 3);
for i = 1:size(x4, 1)
    xyz4(i,:) = xyz(y4(i), x4(i), :);
end
avgxyz4 = mean(xyz4, 1);
d4 = norm(avgxyz4);
h4 = (-1)*avgxyz4(2);
