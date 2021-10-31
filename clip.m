function value = clip(value, min_val, max_val)
    if(value > max_val)
        value = max_val;
    elseif (value < min_val)
        value = min_val;
    end
end

