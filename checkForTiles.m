function all_files_ok = checkForTiles(tile_list)
%CHECKFORTILES Summary of this function goes here
%   Detailed explanation goes here
all_files_ok = true;
    for i = 1:length(tile_list(:,1))
        filename = sprintf('%d_%d.mat',tile_list(i,1),tile_list(i,2));
        if ~exist(filename, "file")
            warning_message = sprintf('Error: File %s needed for routing. Please Init first for needed area or check if files are added to Path.',filename);
            uiwait(msgbox(warning_message));
            all_files_ok = false;
        end
    end
end