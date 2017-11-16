function drawAndLabelBoxes(ds, label, fig)

num_rows = size(ds, 1);
if num_rows > 0
    for row = 1:num_rows
        x_left = ds(row, 1); x_right = ds(row, 3);
        y_top = ds(row, 2); y_bottom = ds(row, 4);
        lineX = [ x_left, x_right , x_right , x_left , x_left ] ;
        lineY = [ y_bottom , y_bottom, y_top , y_top , y_bottom ] ;
        figure(fig);
        hold on;
        switch label
            case 'car'
                line( lineX , lineY, 'Color', 'r', 'LineWidth', 3 ) ;
            case 'person'
                line( lineX , lineY, 'Color', 'b', 'LineWidth', 3 ) ;
            case 'cyclist'
                line( lineX , lineY, 'Color', 'c', 'LineWidth', 3 ) ;
        end
        text(x_left, y_top, label, 'Color', 'w', 'FontSize', 16, 'FontWeight', 'bold');
    end
end

