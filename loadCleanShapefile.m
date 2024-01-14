function shapefile = loadCleanShapefile(shapefile_path)
%loads and cleans shapefile to needed parts only
%   Detailed explanation goes heres
shapefile = shaperead(shapefile_path,'Selector',{@(roadlenght)(roadlenght>=0),'LONGUEUR'});
end