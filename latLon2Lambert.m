function [x,y] = latLon2Lambert(lat,lon)
%LAT_LON_LAMBERT Summary of this function goes here
%   Detailed explanation goes here
lambert = projcrs(2154);
[x,y] = projfwd(lambert,lat,lon);
end