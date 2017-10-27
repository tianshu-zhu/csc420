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

load('rgbd.mat');
K = [fx_d 0 px_d; 0 fy_d py_d; 0 0 1];
wx = zeros(1, 640*480);
wy = zeros(1, 640*480);
w = zeros(1, 640*480);
index = 1;
for x = 1:640
    for y = 1:480
        wx(index) = depth(y,x)*x;
        wy(index) = depth(y,x)*y;
        w(index) = depth(y,x);
        index = index+1;
    end
end

xyz = linsolve(K, [wx; wy; w]);
x3 = xyz(1,:);
y3 = xyz(2,:);
z3 = xyz(3,:);