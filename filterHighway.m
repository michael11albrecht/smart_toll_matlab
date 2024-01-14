function [hw_shapefile,shapefile] = filterHighway(shapefile)
%FILTERHIGHWAY Identifies all highways and dual carriageway national roads
%   Finds adjoining segments to the identified expressways (based on designation)
%   Creates a separate shapefile for them
count = 1;
double_roadnames = {};
added_segments = [];
for i = 1:length(shapefile)
    if shapefile(i).Lanes >= 2 || strcmp(shapefile(i).RoadClass,'A')
        double_roadnames{end+1} = shapefile(i).RoadName;
        for fn = fieldnames(shapefile)'
            hw_shapefile(count).(fn{1}) = shapefile(i).(fn{1});
        end
        shapefile(i).Highway = true;
        added_segments(end+1) = shapefile(i).SegmentID;
        count = count +1;
    else
        shapefile(i).Highway = false;
    end
end
%clean two lane-roads
double_roadnames = unique(double_roadnames);
double_roadnames = double_roadnames(~cellfun('isempty',double_roadnames));
to_del = [];
for i = 1:length(double_roadnames)
    element = double_roadnames{i};
    if element(1) == 'D'
        to_del(end+1) = i;
    end
end
double_roadnames(:,to_del(:)) = [];
%adding single Lanes of the same Street
for i = 1:length(shapefile)
    if strcmp(shapefile(i).RoadName, double_roadnames(:)) & shapefile(i).Highway == false
        for fn = fieldnames(shapefile)'
           hw_shapefile(count).(fn{1}) = shapefile(i).(fn{1});
        end
        shapefile(i).Highway = true;
        count = count +1;
    end
%if no hw create empty shapestruct
if ~exist('hw_shapefile')
    f = fieldnames(shapefile)';
    f{2,1} = {};
    hw_shapefile = struct(f{:});
end
end