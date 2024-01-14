function route_shapefile = buildRouteShapefile(route, start_shapefile, end_shapefile, hw_shapefile)
% BUILDROUTESHAPEFILE Creates a shapefile consisting of the segments needed for the route
if exist('end_shapefile','var')
    hw_seg = [hw_shapefile(:).SegmentID];
    route_shapefile = struct();
    cnt = 1;
    while ~isempty(route) && cnt <= length(route)
        if ~isempty(find(route(end) == hw_seg(:),1))
            idx = find(hw_seg(:) == route(end));
            i = length(route_shapefile);
            for fn = fieldnames(hw_shapefile)'
                route_shapefile(i+1).(fn{1}) = hw_shapefile(idx).(fn{1});
            end
            route(end) = [];
        end
        cnt = cnt+1;
    end
    if isempty(route)
        route_shapefile(1) = [];
        return
    end
    start_seg = [start_shapefile(:).SegmentID];
    cnt = 1;
    while ~isempty(route) && cnt <= length(route)
        if ~isempty(find(route(end) == start_seg(:),1))
            idx = find(start_seg(:) == route(end));
            i = length(route_shapefile);
            for fn = fieldnames(start_shapefile)'
                route_shapefile(i+1).(fn{1}) = start_shapefile(idx).(fn{1});
            end
            route(end) = [];
        end
        cnt = cnt+1;
    end
    if isempty(route)
        route_shapefile(1) = [];
        return
    end
    end_seg = [end_shapefile(:).SegmentID];
    cnt = 1;
    while ~isempty(route) && cnt <= length(route)
        if ~isempty(find(route(end) == end_seg(:),1))
            idx = find(end_seg(:) == route(end));
            i = length(route_shapefile);
            for fn = fieldnames(end_shapefile)'
                route_shapefile(i+1).(fn{1}) = end_shapefile(idx).(fn{1});
            end
            route(end) = [];
        end
        cnt = cnt+1;
    end

else
    %no hw route
    route_shapefile = struct();
    start_seg = [start_shapefile(:).SegmentID];
    cnt = 1;
    while ~isempty(route)
            idx = find(start_seg(:) == route(end));
            i = length(route_shapefile);
            for fn = fieldnames(start_shapefile)'
                route_shapefile(i+1).(fn{1}) = start_shapefile(idx).(fn{1});
            end
            route(end) = [];
    end
end
route_shapefile(1) = [];
end