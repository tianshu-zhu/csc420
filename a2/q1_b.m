function image_out = q1_b(image_in, radius)% Build a circular domain, with radius given% intensity = 1 if inside the circle% intensity = 0 otherwiselength = radius*2+1;domain = zeros(length,length);[x,y] = meshgrid(1:length,1:length);center = [mean(x(:)) mean(y(:))];distance = sqrt(((x-center(1)).^2+(y-center(2)).^2));domain = double(distance <= radius);order = sum(domain(:));image_out = ordfilt2(image_in, order, domain);