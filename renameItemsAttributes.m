function new_shapefile = renameItemsAttributes(shapefile)
%RENAMEITEMATTRIBUTES Renames the remaining columns of the shapefile
%   Introduces a SegmentID (int)

old_class = {'Autoroute', 'D�partementale', 'Nationale', 'Sans objet'};
new_class = {'A','D','N','None'};

for i = 1:length(shapefile(:))
    if strcmp(shapefile(i).NB_CHAUSSE,'1 chauss�e')
        new_shapefile(i).Lanes = 1;
    end
    if strcmp(shapefile(i).NB_CHAUSSE,'2 chauss�es')
        new_shapefile(i).Lanes = 2;
    end
    for c = 1:length(old_class)
        if strcmp(shapefile(i).CLASS_ADM,old_class{c})
            new_shapefile(i).RoadClass = new_class{c};
        end
    end
    if strcmp(shapefile(i).ACCES,'Libre')
        new_shapefile(i).Toll = false;
    end
    if strcmp(shapefile(i).ACCES,'A p�age')
        new_shapefile(i).Toll = true;
    end

    new_shapefile(i).Geometry = shapefile(i).Geometry;
    new_shapefile(i).BoundingBox = shapefile(i).BoundingBox;
    new_shapefile(i).X = shapefile(i).X;
    new_shapefile(i).Y = shapefile(i).Y;
    new_shapefile(i).Length = shapefile(i).LONGUEUR;
    new_shapefile(i).RoadName = shapefile(i).NUM_ROUTE;

    %add segment id 
    new_shapefile(i).SegmentID = i;
end
end