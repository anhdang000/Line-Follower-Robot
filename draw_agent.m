function [x_sensor, y_sensor] = draw_agent(x_c, y_c, width, length, phi)
    x1 = x_c - length/2;
    y1 = y_c - width/2;
    x2 = x_c + length/2;
    y2 = y_c + width/2;
    robot = polyshape([x1 x2 x2 x1], [y1 y1 y2 y2]);
    robot = rotate(robot, phi, [x_c y_c]);
    plot(robot, 'FaceColor', [0.3010 0.7450 0.9330], 'EdgeColor', 'r');
    
    sensor = polyshape([x2 x2 x_c], [y1 y2 y_c]);
    sensor = rotate(sensor, phi, [x_c y_c]);
%     plot(sensor, 'FaceColor', 'none', 'EdgeColor', 'r');
    [row, ~] = find(sensor.Vertices(:, 1) ~= x_c);
    x_sensor = sensor.Vertices(row, 1);
    [row, ~] = find(sensor.Vertices(:, 2) ~= y_c);
    y_sensor = sensor.Vertices(row, 2);
    drawnow
end