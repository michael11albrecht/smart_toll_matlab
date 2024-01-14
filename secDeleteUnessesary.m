function new_shapefile = secDeleteUnessesary(shapefile)
%DELETE_UNESSESARY Summary of this function goes here
%   Detailed explanation goes here
new_shapefile = rmfield(shapefile,{'Lanes','RoadName'});
end