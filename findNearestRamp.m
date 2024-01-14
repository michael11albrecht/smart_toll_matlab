function ramp = findNearestRamp(x,y,ramp_list)
% FINDNEARESTRAMP Searches for the nearest ramp to the given point from the ramp list
    d_min = inf;
    for i = 1:length(ramp_list(:,1))
            d = sqrt((ramp_list(i,1)-x)^2+(ramp_list(i,2)-y)^2);
            if d < d_min
                point = i;
                d_min = d;
            end
    end
    ramp = [ramp_list(point,:)];
end