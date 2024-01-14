function route = aStarMiddle(start_adjm, start_coosL, end_adjm, end_coosL, hw_adjm, hw_coosL, start_point, end_point, start_ramp, end_ramp)
% ASTARMIDDLE Calculates three routes (start-highway-end) and connects them
    local_hw_start_point = find(start_coosL(:,3) == start_ramp(3));
    hw_hw_start_point = find(hw_coosL(:,3) == start_ramp(4));
    local_hw_end_point = find(end_coosL(:,3) == end_ramp(3));
    hw_hw_end_point = find(hw_coosL(:,3) == end_ramp(4));
    
    start_route = [];
    hw_route = [];
    end_route = [];
    if start_point ~= local_hw_start_point
        start_route = aStar(start_adjm,start_coosL,start_point,local_hw_start_point(1,1));
    end
    if hw_hw_start_point(1,1) ~= hw_hw_end_point(1,1)
         hw_route = aStar(hw_adjm,hw_coosL,hw_hw_start_point(1,1),hw_hw_end_point(1,1));
    end
    if end_point ~= local_hw_end_point
        end_route = aStar(end_adjm,end_coosL,local_hw_end_point(1,1),end_point);
    end

    route = [end_route;hw_route;start_route];
end