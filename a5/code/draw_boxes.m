function draw_boxes(fig, dets, color)
% draw boxes on top of image in fig given boxes information in dets
num_rows = size(dets, 1);
if num_rows > 0
    for row = 1:num_rows
        x_left = dets(row, 1); x_right = dets(row, 3);
        y_top = dets(row, 2); y_bottom = dets(row, 4);
        lineX = [ x_left, x_right , x_right , x_left , x_left ] ;
        lineY = [ y_bottom , y_bottom, y_top , y_top , y_bottom ] ;
        figure(fig);
        hold on;
        line( lineX , lineY, 'Color', color, 'LineWidth', 3 ) ;
    end
end

