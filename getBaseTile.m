function [new_basepath, all_files_ok] = getBaseTile(xy_start, xy_dest, tile_size, basepath)
%GETBASETILE Summary of this function goes here
%   Detailed explanation goes here
    all_files_ok = true;
    
    x_tile = floor(xy_start(1)*(1/tile_size))*tile_size;
    y_tile = floor(xy_start(2)*(1/tile_size))*tile_size;

    if (xy_dest(1)-x_tile) > tile_size || (xy_dest(2)-y_tile) > tile_size
        warning_message = 'Error: Start and Destination are not in the same base-tile. Please Init first.';
        uiwait(msgbox(warning_message));
        all_files_ok = false;
    end
    
    folder_name = sprintf('%d_%d',x_tile,y_tile);
    if ~exist(folder_name, "dir")
        warning_message = sprintf('Error: Folder %s needed for routing. Please Init first for needed area or check if files are added to Path.',folder_name);
        uiwait(msgbox(warning_message));
        all_files_ok = false;
    end

    new_basepath = sprintf('%s/%s',basepath,folder_name);
end