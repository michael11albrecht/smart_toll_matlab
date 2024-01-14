function map_limit = calcMapLimits(xy_start, xy_dest)
%CALCMAPLIMITS Summary of this function goes here
%   Detailed explanation goes here
    pct_of_dist = 0.2;
    dist_sd = sqrt((xy_start(1)-xy_dest(1))^2+(xy_start(2)-xy_dest(2))^2);
    
    x_min = min([xy_start(1),xy_dest(1)])-dist_sd*pct_of_dist;
    y_min = min([xy_start(2),xy_dest(2)])-dist_sd*pct_of_dist;

    x_max = max([xy_start(1),xy_dest(1)])+dist_sd*pct_of_dist;
    y_max = max([xy_start(2),xy_dest(2)])+dist_sd*pct_of_dist;

    [lat_min,lon_min] = lambert2latlon(x_min,y_min);
    [lat_max,lon_max] = lambert2latlon(x_max,y_max);
    map_limit = [lat_min,lat_max,lon_min,lon_max];

end