function all_files_ok = checkForTileSilent(tile_list)
%CHECKFORTILES Summary of this function goes here
%   Detailed explanation goes here
all_files_ok = true;
    for i = 1:length(tile_list(:,1))
        filename = sprintf('%d_%d.mat',tile_list(i,1),tile_list(i,2));
        if ~exist(filename, "file")
            all_files_ok = false;
        end
    end
end