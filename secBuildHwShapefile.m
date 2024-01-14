function hw_shapefile = secBuildHwShapefile(shapefile)
%SECBUILDHWSHAPEFILE Creates a shapefile that only includes expressways
%   Uses the processed shapefile as its base
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