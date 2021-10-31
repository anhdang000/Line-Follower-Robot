function v = rpm2v(rpm, wheel_radius)
    v = rpm * 2 * pi / 60 * wheel_radius;
end

