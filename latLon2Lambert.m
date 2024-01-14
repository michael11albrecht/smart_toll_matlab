function [x,y] = latLon2Lambert(lat,lon)
%LATLON2LAMBERT Converts Lat,Lon WGS84 coordinates to Lambert 93 projection
lambert = projcrs(2154);
[x,y] = projfwd(lambert,lat,lon);
end