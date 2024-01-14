function new_shapefile = secDeleteUnessesary(shapefile)
%SECDELETEUNNECESSARY Deletes now unnecessary columns after further processing
new_shapefile = rmfield(shapefile,{'Lanes','RoadName'});
end