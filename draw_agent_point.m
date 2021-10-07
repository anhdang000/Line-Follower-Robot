function draw_agent_point(x_c, y_c, x_c_prev, y_c_prev)
    plot([x_c; x_c_prev], [y_c; y_c_prev], 'Color', 'r', 'LineWidth', 2);
    drawnow
end