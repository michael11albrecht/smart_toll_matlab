function ramps = findRamps(loc_coos_L,hw_coos_L)
    index = 1;
    ramps = [];
    for i = 1:length(loc_coos_L(:,1))
        for j = i+1:length(hw_coos_L(:,1))
            if sqrt((loc_coos_L(i,1)-hw_coos_L(j,1))^2+(loc_coos_L(i,2)-hw_coos_L(j,2))^2) < 10
                if loc_coos_L(i,4) == false
                    hw_seg = hw_coos_L(j,3);
                    loc_seg = loc_coos_L(i,3);
                    ramps(index,:) = [loc_coos_L(i,1),loc_coos_L(i,2),loc_seg,hw_seg];
                    index = index + 1;
                end
            end
        end
    end
end