function filepath = getTilesFilePath(tile_list)
%GETFILEPATH Summary of this function goes here
%   Detailed explanation goes here
    filename = sprintf('%d_%d.mat',tile_list(1,1),tile_list(1,2));
    filepath = mlreportgen.utils.findFile(filename);
    del_str = sprintf('/%s',filename);
    filepath = erase(filepath,del_str);
end