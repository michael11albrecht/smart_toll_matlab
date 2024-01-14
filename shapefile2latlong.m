function [lat,lon] = shapefile2latlong(shapefile)
% SHAPEFILE2LATLON Returns all points of the shapefile segments in sequential order as lat, lon WGS84 coordinates
    x = [];
    y = [];
    for i = 1:length(shapefile(:))
        if i ~= length(shapefile(:))
        if ((shapefile(i).X(end-1)-shapefile(i+1).X(1))^2+(shapefile(i).Y(end-1)-shapefile(i+1).Y(1))^2) < 100 || ((shapefile(i).X(end-1)-shapefile(i+1).X(end-1))^2+(shapefile(i).Y(end-1)-shapefile(i+1).Y(end-1))^2) < 100
            for j = 1:(length(shapefile(i).X)-1)
                x(end+1) = shapefile(i).X(j);
                y(end+1) = shapefile(i).Y(j);
            end
        else
            for j = (length(shapefile(i).X)-1):-1:1
                x(end+1) = shapefile(i).X(j);
                y(end+1) = shapefile(i).Y(j);
            end 
        end
        else
            %last element
            if ((shapefile(i).X(1)-x(end))^2+(shapefile(i).Y(1)-y(end))^2) < 100
            for j = 1:(length(shapefile(i).X)-1)
                x(end+1) = shapefile(i).X(j);
                y(end+1) = shapefile(i).Y(j);
            end
        else
            for j = (length(shapefile(i).X)-1):-1:1
                x(end+1) = shapefile(i).X(j);
                y(end+1) = shapefile(i).Y(j);
            end 
        end
        end
    end
    [lat,lon] = lambert2latlon(x,y);
end