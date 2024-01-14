function new_shapefile = deleteUnessesary(shapefile)
%DELETE_UNESSESARY Summary of this function goes here
%   Detailed explanation goes here
new_shapefile = rmfield(shapefile,{'ID_RTE500','VOCATION','NB_VOIES','ETAT','RES_VERT','SENS','RES_EUROPE'});
end