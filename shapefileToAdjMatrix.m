function [A,L] = shapefileToAdjMatrix(shapefile, highway_file)
%SHAPEFILETOADJMATRIX Calculates the shapefile and creates a list of coordinates from the shapefile
    %create empty arrays
    L = zeros(2*length(shapefile),2);
    A = zeros(2*length(shapefile));
    for segment = 1:length(shapefile)
        %Start/Endkoos in Liste
        L(segment,1) = shapefile(segment).X(1);
        L(segment,2) = shapefile(segment).Y(1);
        L(segment,3) = shapefile(segment).SegmentID;
        if ~highway_file
            L(segment,4) = shapefile(segment).Highway;
        end
        L(segment,5) = shapefile(segment).Toll;
        L(segment+length(shapefile),1) = shapefile(segment).X(end-1);
        L(segment+length(shapefile),2) = shapefile(segment).Y(end-1);
        L(segment+length(shapefile),3) = shapefile(segment).SegmentID;
        if ~highway_file
            L(segment+length(shapefile),4) = shapefile(segment).Highway;
        end
        L(segment+length(shapefile),5) = shapefile(segment).Toll;
        
        %Kante in Adjazenzmatrix
        if strcmp(shapefile(segment).RoadClass,'D')
            % 80kmh
            A(segment,segment+length(shapefile)) = shapefile(segment).Length/80*120;
            A(segment+length(shapefile),segment) = shapefile(segment).Length/80*120;
        elseif strcmp(shapefile(segment).RoadClass,'N')
            % 80kmh
            A(segment,segment+length(shapefile)) = shapefile(segment).Length/80*120;
            A(segment+length(shapefile),segment) = shapefile(segment).Length/80*120;
        elseif strcmp(shapefile(segment).RoadClass,'A')
            %130kmh
            A(segment,segment+length(shapefile)) = shapefile(segment).Length/130*120;
            A(segment+length(shapefile),segment) = shapefile(segment).Length/130*120;
        else
            %50kmh
            A(segment,segment+length(shapefile)) = shapefile(segment).Length/50*120;
            A(segment+length(shapefile),segment) = shapefile(segment).Length/50*120;
        end
    end
    for i = 1:length(L(:,1))
        for j = i+1:length(L(:,1))
            if sqrt((L(i,1)-L(j,1))^2+(L(i,2)-L(j,2))^2) < 30
                A(i,j) = 1;
                A(j,i) = 1;
            end
        end
    end
end