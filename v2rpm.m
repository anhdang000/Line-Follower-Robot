function rpm = v2rpm(v, wheel_radius)
    omega = v / wheel_radius;
    rpm = omega * 60 / (2*pi);
end

