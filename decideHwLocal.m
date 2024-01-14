function hw_true = decideHwLocal(xy_start,xy_dest,xy_start_ramp,xy_dest_ramp)
% DECIDEHWLOCAL Decides between an expressway route or simple A*
% The decision is based on the straight-line distance between start/end points and ramps
% or start and end points
    hw_true = true;
    
    dist_start_dest = (xy_dest(1)-xy_start(1))^2+(xy_dest(2)-xy_start(2))^2;
    dist_start_ramp = (xy_start_ramp(1)-xy_start(1))^2+(xy_start_ramp(2)-xy_start(2))^2;
    dist_dest_ramp = (xy_dest_ramp(1)-xy_dest(1))^2+(xy_dest_ramp(2)-xy_dest(2))^2;
    
    if dist_start_dest <= (dist_start_ramp+dist_dest_ramp)
        hw_true = false;
    end
end