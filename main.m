function [lat_lon_route,map_limit,lat_lon_start_ziel] = main(start_addr, dest_addr)
%gets run by the gui, by pressing the "Calculate" button
% returns the route as lat, lon list, start, end coords and the map limits

base_tile_size = 100000;
basepath = 'Daten';

addpath(genpath(basepath));

%start ziel input
[lat, lon] = getLatLonAddress(start_addr);
[xstart, ystart] = latLon2Lambert(lat, lon);

[lat, lon] = getLatLonAddress(dest_addr);
[xziel, yziel] = latLon2Lambert(lat, lon);

[basepath, files_okey] = getBaseTile([xstart,ystart],[xziel,yziel],base_tile_size,basepath);

if ~files_okey
    return
end

%find nearest ramp (start/ziel)
ramps_path = sprintf('%s/ramps.mat',basepath);
ramp_list = load(ramps_path);
ramp_list = ramp_list.ramps;
if ~isempty(ramp_list)
   route_shapefile = withHw(xstart,ystart,xziel,yziel,basepath,ramp_list);
else
   route_shapefile = withoutHw(xstart,ystart,xziel,yziel,basepath);
end


%show_route

[lat,lon] = shapefile2latlong(route_shapefile);
lat_lon_route = [lat',lon'];

map_limit = calcMapLimits([xstart,ystart],[xziel,yziel]);

[lat_s,lon_s] = lambert2latlon(xstart,ystart);
[lat_d,lon_d] = lambert2latlon(xziel,yziel);

lat_lon_start_ziel = [lat_s,lon_s,lat_d,lon_d];
end

function route_shapefile = withoutHw(xstart, ystart, xziel, yziel, basepath)
% WITHOUTHW Calculates the route using simple A*
    %no ramps on map
    %calc_tiles
    tile_list = calcNeededTiles(xstart,ystart,xziel,yziel,10000);
    
    if ~checkForTiles(tile_list)
        return
    end
    
    tiles_path = sprintf('%s/local_tiles',basepath);
    shapefile = stichTiles(tile_list,tiles_path);

    %calc_route
    [adjm,coosL] = shapefileToAdjMatrix(shapefile,false);
    [adjm,coosL] = makeMainGraph(adjm,coosL);
    
    start_p = p2pMatching(xstart,ystart,coosL);
    end_p = p2pMatching(xziel,yziel,coosL);
    
    route = aStar(adjm,coosL,start_p,end_p);

    route_shapefile = buildRouteShapefile(route,shapefile);
end

function route_shapefile = withHw(xstart, ystart, xziel, yziel, basepath, ramp_list)
% WITHHW Calculates the route using Midpoint Heuristic A*
%there are ramps on the map
start_ramp = findNearestRamp(xstart,ystart,ramp_list);
dest_ramp = findNearestRamp(xziel,yziel,ramp_list);

if ~decideHwLocal([xstart,ystart],[xziel,yziel],[start_ramp(1),start_ramp(2)],[dest_ramp(1),dest_ramp(2)])
    route_shapefile = withoutHw(xstart,ystart,xziel,yziel,basepath);
    return
end

%calc_tiles
tile_list_start = calcNeededTiles(xstart,ystart,start_ramp(1),start_ramp(2),10000);
tile_list_end = calcNeededTiles(xziel,yziel,dest_ramp(1),dest_ramp(2),10000);

if ~checkForTiles(tile_list_start)
    return
end
if ~checkForTiles(tile_list_end)
    return
end

tiles_path = sprintf('%s/local_tiles',basepath);
shapefile_start = stichTiles(tile_list_start,tiles_path);
shapefile_end = stichTiles(tile_list_end,tiles_path);

%calc_route
[adjm_start,coosL_start] = shapefileToAdjMatrix(shapefile_start,false);
[adjm_start,coosL_start] = makeMainGraph(adjm_start,coosL_start);

[adjm_end,coosL_end] = shapefileToAdjMatrix(shapefile_end,false);
[adjm_end,coosL_end] = makeMainGraph(adjm_end,coosL_end);

hw_adjm_path = sprintf('%s/hw_adjm.mat',basepath);
hw_adjm = load(hw_adjm_path);
hw_adjm = hw_adjm.hw_adjm;
hw_coosl_path = sprintf('%s/hw_coosl.mat',basepath);
hw_coosL = load(hw_coosl_path);
hw_coosL = hw_coosL.hw_coosL;

start_p = p2pMatching(xstart,ystart,coosL_start);
end_p = p2pMatching(xziel,yziel,coosL_end);

route = aStarMiddle(adjm_start,coosL_start,adjm_end,coosL_end,hw_adjm,hw_coosL,start_p,end_p,start_ramp,dest_ramp);

hw_path = sprintf('%s/hw_shape.mat',basepath);
shapefile_hw = load(hw_path);
shapefile_hw = shapefile_hw.highways;
route_shapefile = buildRouteShapefile(route,shapefile_start,shapefile_end,shapefile_hw);
end
