function new_shapefile = stichTiles(tile_list,tile_path)
%STICH_TILES Summary of this function goes here
%   Detailed explanation goes here
    old_segments = [];
    for i = 1:length(tile_list(:,1))
        filepath = sprintf('%s/%d_%d.mat',tile_path,tile_list(i,1),tile_list(i,2));
        shapefile = load(filepath);
        shapefile = shapefile.save_tile;
        if i ~= 1
            old_segments = [new_shapefile(:).SegmentID];
        end
        for segment = 1:length(shapefile)
            if ~strcmp(shapefile(segment).SegmentID,old_segments(:))
                if i == 1 && segment == 1
                    idx = 0;
                else
                    idx = length(new_shapefile);
                end
                for fn = fieldnames(shapefile)'
                    new_shapefile(idx+1).(fn{1}) = shapefile(segment).(fn{1});
                end
            end
        end
    end
end