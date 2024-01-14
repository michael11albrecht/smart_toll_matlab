function point = p2pMatching(x, y, coos_list)
    d_min = inf;
    for i = 1:length(coos_list)
        d = sqrt((coos_list(i,1)-x)^2+(coos_list(i,2)-y)^2);
        if d < d_min
            point = i;
            d_min = d;
        end
    end
end