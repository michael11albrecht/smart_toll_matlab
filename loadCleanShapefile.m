function shapefile = loadCleanShapefile(shapefile_path)
%LOADCLEANSHAPEFILE Reads in the shapefile while filtering out empty segments
shapefile = shaperead(shapefile_path,'Selector',{@(roadlenght)(roadlenght>=0),'LONGUEUR'});
end