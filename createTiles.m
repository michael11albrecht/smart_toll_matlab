function createTiles(shapefile,tile_size,output_path)
%CREATETILES Calculates all tiles required to represent the shapefile
%   Saves the tiles, naming them with the minimum coordinates
y_values_min = zeros(length(shapefile(:)),1);
y_values_max = zeros(length(shapefile(:)),1);
x_values_min = zeros(length(shapefile(:)),1);
x_values_max = zeros(length(shapefile(:)),1);
for i = 1:length(shapefile(:))
    y_values_min(i) = shapefile(i).BoundingBox(1,2);
    x_values_min(i) = shapefile(i).BoundingBox(1,1);
    y_values_max(i) = shapefile(i).BoundingBox(2,2);
    x_values_max(i) = shapefile(i).BoundingBox(2,1);
end
y_min = min(y_values_min);
y_max = max(y_values_max);
y_min = uint32(y_min*(1/tile_size))*tile_size;
y_max = uint32(y_max*(1/tile_size))*tile_size;
for y_tile = y_min:tile_size:y_max
    y_list = find((y_values_min >= y_tile) & (y_values_min <= y_tile+tile_size));
    y_list = [y_list;find((y_values_max >= y_tile) & (y_values_max <= y_tile+tile_size))];
    y_list = unique(y_list,'rows');
    x_min = min(x_values_min(y_list));
    x_max = max(x_values_max(y_list));
    x_min = uint32(x_min*(1/tile_size))*tile_size;
    x_max = uint32(x_max*(1/tile_size))*tile_size;
    for x_tile = x_min:tile_size:x_max
        x_list = find((x_values_min >= x_tile) & (x_values_min <= x_tile+tile_size));
        x_list = [x_list;find((x_values_max >= x_tile) & (x_values_max <= x_tile+tile_size))];
        x_list = unique(x_list,'rows');
        final_list = intersect(x_list,y_list);
        if ~isempty(final_list)
            i = 1;
            for shape_segment = final_list
                if i == 1
                    save_tile = shapefile(shape_segment);
                else
                    save_tile = [save_tile,shapefile(shape_segment)];
                end
                i = i+1;
            end
            fn = sprintf('%s/%d_%d.mat',output_path,x_tile,y_tile);
            save(fn,'save_tile');
        end
    end
end