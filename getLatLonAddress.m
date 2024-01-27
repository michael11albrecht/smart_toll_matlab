function  [lat,lon]=getLatLonAddress(address)
%GETLATLONADDRESS Performs an API call with text input to https://www.geoapify.com
%   Returns the resulting lat, lon coordinates
env_config = loadenv('config.env');
api_key = env_config('geoapify_key');
address_rdy = regexprep(address, ' ', '%20');
url_string = sprintf('https://api.geoapify.com/v1/geocode/search?text=%s&apiKey=%s',address_rdy,api_key);
import matlab.net.*
import matlab.net.http.*
r = RequestMessage;
uri = URI(url_string);
resp = send(r,uri);
status = resp.StatusCode;
if status == 200
    lon = resp.Body.Data.features(1).properties.lon;
    lat = resp.Body.Data.features(1).properties.lat;
else
    disp('Please try again.')
end
end