function draw_map()
    hold on
    axis equal
    grid on
    xlim([-2000 2000]);
    ylim([-2000 2000]);
    
    r = 500;
    
    BC = [linspace(-1000, 1000, 200); linspace(500, 500, 200)];
    EF = [linspace(-1000, 1000, 200); linspace(-500, -500, 200)];
    
    angle1 = linspace(pi/2, 3*pi/2);
    x1 = r*cos(angle1)-1000;
    y1 = r*sin(angle1);
    CE = [x1; y1];
    
    angle2 = linspace(-pi/2, pi/2);
    x2 = r*cos(angle2)+1000;
    y2 = r*sin(angle2);
    FB = [x2; y2];
    
    map_points = [FB BC CE EF];
    plot(map_points(1, :), map_points(2, :), 'k', 'linewidth', 1);
    
    % Anchor points
%     plot(0, 0, '-ro', 'MarkerSize', 1, 'linewidth',5);
%     plot(-1500, 0, '-ro', 'MarkerSize', 1, 'linewidth',5);
%     plot(1500, 0, '-ro', 'MarkerSize', 1, 'linewidth',5);
%     plot(-1000, 500, '-ro', 'MarkerSize', 1, 'linewidth',5);
%     plot(1000, 500, '-ro', 'MarkerSize', 1, 'linewidth',5);
%     plot(-1000, -500, '-ro', 'MarkerSize', 1, 'linewidth',5);
%     plot(1000, -500, '-ro', 'MarkerSize', 1, 'linewidth',5);
end