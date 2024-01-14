function tile_list = calcNeededTiles(x_start,y_start,x_dest,y_dest,tile_size)
%CALC_NEEDED_TILES Summary of this function goes here
%   Detailed explanation goes here
%works with positve coos only
    vz = 1;
    if y_start > y_dest
        vz = -1;
    end

    dist_s_d = sqrt((x_dest-x_start)^2+(y_dest-y_start)^2);
    points2check = [x_start, y_start
                    x_dest, y_dest];

    alpha = asin((x_dest-x_start)/dist_s_d);

    for i = 0:floor(dist_s_d/tile_size)
        x_check = (sin(alpha)*i*tile_size)+x_start;
        y_check = vz*(cos(alpha)*i*tile_size)+y_start;
        points2check(end+1,:) = [x_check, y_check];
    end
    points2check = unique(points2check,"rows","stable");

    tile_list = [];
    for i = 1:length(points2check(:,1))
        x_tile = floor(points2check(i,1)*(1/tile_size))*tile_size;
        y_tile = floor(points2check(i,2)*(1/tile_size))*tile_size;
        tile_list(end+1,:) = [x_tile,y_tile]; 
        if dist_s_d < 50000 || i <= 2 %start&end + under 50km
        %extra tiles
        x_tile_v = x_tile+tile_size;
        x_tile_h = x_tile-tile_size;

        y_tile_v = y_tile+tile_size;
        y_tile_h = y_tile-tile_size;

        extra_tiles = [x_tile_v,y_tile
                       x_tile_h,y_tile
                       x_tile,y_tile_v
                       x_tile,y_tile_h];
        for j = 1:length(extra_tiles)
            if checkForTileSilent(extra_tiles(j,:))
                tile_list(end+1,:) = extra_tiles(j,:);
            end
        end

    end
    tile_list = unique(tile_list,"rows",'stable');

end