function folder_name = createTileSpecific(shapefile,tile_size,output_path,y_value,x_value)
%CREATE_TILES Summary of this function goes here
%   Detailed explanation goes here
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
y_tile = floor(y_value*(1/tile_size))*tile_size;
    y_list = find((y_values_min >= y_tile) & (y_values_min <= y_tile+tile_size));
    y_list = [y_list;find((y_values_max >= y_tile) & (y_values_max <= y_tile+tile_size))];
    y_list = unique(y_list,'rows');
    x_tile = floor(x_value*(1/tile_size))*tile_size;
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
            folder_name = sprintf('%d_%d',x_tile,y_tile);
            mkdir(fullfile(output_path,folder_name))
            fn = sprintf('%s/%s/%d_%d.mat',output_path,folder_name,x_tile,y_tile);
            save(fn,'save_tile');
        end
end