function new_shapefile = deleteUnessesary(shapefile)
%DELETEUNNECESSARY Deletes unnecessary columns from the shapefile
    new_shapefile = rmfield(shapefile,{'ID_RTE500','VOCATION','NB_VOIES','ETAT','RES_VERT','SENS','RES_EUROPE'});
end