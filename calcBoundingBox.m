function boundingBox = calcBoundingBox(x_val,y_val)
%calcs the bounding box of a set of points
    x_min = min(x_val);
    y_min = min(y_val);
    x_max = max(x_val);
    y_max = max(y_val);

    boundingBox = [x_min,y_min;x_max,y_max];
end