function hw_shapefile = secBuildHwShapefile(shapefile)
%SECBUILDHWSHAPEFILE Summary of this function goes here
%   Detailed explanation goes here
    count = 1;
    for i = 1:length(shapefile)
        if shapefile(i).Highway
            for fn = fieldnames(shapefile)'
                hw_shapefile(count).(fn{1}) = shapefile(i).(fn{1});
            end
            count = count+1;
        end  
    end
end