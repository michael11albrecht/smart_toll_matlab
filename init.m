function init(init_address)

 basepath = 'Daten';
 
 addpath(genpath(basepath));

 [lat, lon] = getLatLonAddress(init_address);
 [x,y] = latLon2Lambert(lat, lon);

 shapefile_path = sprintf('%s/shapefile/TRONCON_ROUTE.shp',basepath);
 shapefile = loadCleanShapefile(shapefile_path);
 shapefile = deleteUnessesary(shapefile);
 shapefile = renameItemsAttributes(shapefile);

 %base tile
 folder_name = createTileSpecific(shapefile,100000,basepath,y,x);
 
 new_shapefile_path = sprintf('%s/%s/%s.mat',basepath,folder_name,folder_name);
 shapefile = load(new_shapefile_path);
 shapefile = shapefile.save_tile;

[~,shapefile] = filterHighway(shapefile);
shapefile = secDeleteUnessesary(shapefile);

shapefile = compactShapefile(shapefile,false);

local_tiles_path = sprintf('%s/%s/local_tiles',basepath,folder_name);
folder_path = sprintf('%s/%s',basepath,folder_name);
mkdir(fullfile(folder_path,'local_tiles'));
createTiles(shapefile,10000,local_tiles_path);

[adjm,coosL] = shapefileToAdjMatrix(shapefile,false);
[adjm,coosL] = makeMainGraph(adjm, coosL);

highways = secBuildHwShapefile(shapefile);

[hw_adjm,hw_coosL] = shapefileToAdjMatrix(highways,true);
[hw_adjm,hw_coosL] = makeMainGraph(hw_adjm, hw_coosL);

ramps = findRamps(coosL,hw_coosL);

ramps_path = sprintf('%s/%s/ramps.mat',basepath,folder_name);
hw_adj_path = sprintf('%s/%s/hw_adjm.mat',basepath,folder_name);
hw_coosl_path = sprintf('%s/%s/hw_coosl.mat',basepath,folder_name);
highways_path = sprintf('%s/%s/hw_shape.mat',basepath,folder_name);
cleaned_shapefile_path = sprintf('%s/%s/clean_shape.mat',basepath,folder_name);

save(ramps_path,'ramps');
save(hw_adj_path,'hw_adjm');
save(hw_coosl_path,'hw_coosL');
save(highways_path,'highways');
save(cleaned_shapefile_path,'shapefile');

end