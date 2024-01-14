function new_shapefile = compactShapefile(shapefile, highway_file)
%COMPACTSHAPEFILE Summary of this function goes here
%   Detailed explanation goes here
    max_dist =10;
    max_dist = max_dist^2;
    count = 1;
    incl = [];
    for i = 1:length(shapefile)
        if ~any(i == incl(:))
            for fn = fieldnames(shapefile)'
               new_shapefile(count).(fn{1}) = shapefile(i).(fn{1});
            end
            incl(end+1) = i;
            while true
                new_X = new_shapefile(count).X;
                new_Y = new_shapefile(count).Y;
                new_Length = new_shapefile(count).Length;
                if ~highway_file
                    new_Highway_front = new_shapefile(count).Highway;
                    new_Highway_back = new_shapefile(count).Highway;
                end
                found_seg_front = false;
                found_seg_back = false;
                back_incl = [];
                front_incl = [];
                count_intersect_front = 0;
                count_intersect_back = 0;
                for j = 1:length(shapefile)
                        dist_front_front = (new_shapefile(count).X(1)-shapefile(j).X(1))^2+(new_shapefile(count).Y(1)-shapefile(j).Y(1))^2;
                        dist_front_back = (new_shapefile(count).X(1)-shapefile(j).X(end-1))^2+(new_shapefile(count).Y(1)-shapefile(j).Y(end-1))^2;
                        dist_back_front = (new_shapefile(count).X(end-1)-shapefile(j).X(1))^2+(new_shapefile(count).Y(end-1)-shapefile(j).Y(1))^2;
                        dist_back_back = (new_shapefile(count).X(end-1)-shapefile(j).X(end-1))^2+(new_shapefile(count).Y(end-1)-shapefile(j).Y(end-1))^2;
                        if dist_front_back <= max_dist
                            count_intersect_front = count_intersect_front+1;
                            if strcmp(new_shapefile(count).RoadClass,shapefile(j).RoadClass) && new_shapefile(count).Toll == shapefile(j).Toll
                                if ~any(j == incl(:))
                                    found_seg_front = true;
                                    new_X_front = [rmmissing(shapefile(j).X)];
                                    new_Y_front = [rmmissing(shapefile(j).Y)];
                                    new_Length_front = shapefile(j).Length;
                                    if ~highway_file
                                        if  shapefile(j).Highway == true
                                            new_Highway_front = true;
                                        end
                                    end
                                    front_incl = j;
                                end
                            end
                        elseif dist_back_front <= max_dist
                            count_intersect_back = count_intersect_back+1;
                            if strcmp(new_shapefile(count).RoadClass,shapefile(j).RoadClass) && new_shapefile(count).Toll == shapefile(j).Toll
                                if ~any(j == incl(:))
                                    found_seg_back = true;
                                    new_X_back = [shapefile(j).X];
                                    new_Y_back = [shapefile(j).Y];
                                    new_Length_back = shapefile(j).Length;
                                    if ~highway_file
                                        if shapefile(j).Highway == true
                                            new_Highway_back = true;
                                        end
                                    end
                                    back_incl = j;
                                end
                            end
                        elseif dist_front_front <= max_dist
                            count_intersect_front = count_intersect_front+1;
                            if strcmp(new_shapefile(count).RoadClass,shapefile(j).RoadClass) && new_shapefile(count).Toll == shapefile(j).Toll
                                if ~any(j == incl(:))
                                    found_seg_front = true;
                                    new_X_front = [rmmissing(fliplr(shapefile(j).X))];
                                    new_Y_front = [rmmissing(fliplr(shapefile(j).Y))];
                                    new_Length_front = shapefile(j).Length;
                                    if ~highway_file
                                        if  shapefile(j).Highway == true
                                            new_Highway_front = true;
                                        end
                                    end
                                    front_incl = j;
                                end
                            end
                        elseif dist_back_back <= max_dist
                            count_intersect_back = count_intersect_back+1;
                            if strcmp(new_shapefile(count).RoadClass,shapefile(j).RoadClass) && new_shapefile(count).Toll == shapefile(j).Toll
                                if ~any(j == incl(:))
                                    found_seg_back = true;
                                    new_X_back = [rmmissing(fliplr(shapefile(j).X)),missing];
                                    new_Y_back = [rmmissing(fliplr(shapefile(j).Y)),missing];
                                    new_Length_back = shapefile(j).Length;
                                    if ~highway_file
                                        if shapefile(j).Highway == true
                                            new_Highway_back = true;
                                        end
                                    end
                                    back_incl = j;
                                end
                            end
                        end 
                        %if both sides are intersections
                        if (count_intersect_front > 1 && count_intersect_back > 1)
                            break
                        end
                end
                if count_intersect_front == 1 && found_seg_front
                    new_shapefile(count).X = [new_X_front,new_X];
                    new_shapefile(count).Y = [new_Y_front,new_Y];
                    new_shapefile(count).BoundingBox = calcBoundingBox(new_shapefile(count).X,new_shapefile(count).Y);
                    new_shapefile(count).Length = new_Length_front+new_Length;
                    if ~highway_file
                        new_shapefile(count).Highway = new_Highway_front;
                    end
                    incl(end+1) = front_incl;
                    
                    %incase both sides are open
                    new_X = new_shapefile(count).X;
                    new_Y = new_shapefile(count).Y;
                    new_Length = new_shapefile(count).Length;
                end
                if count_intersect_back == 1 && found_seg_back
                    new_shapefile(count).X = [rmmissing(new_X),new_X_back];
                    new_shapefile(count).Y = [rmmissing(new_Y),new_Y_back];
                    new_shapefile(count).BoundingBox = calcBoundingBox(new_shapefile(count).X,new_shapefile(count).Y);
                    new_shapefile(count).Length = new_Length_back+new_Length;
                    if ~highway_file
                        if new_Highway_back
                            new_shapefile(count).Highway = new_Highway_back;
                        end
                    end
                    incl(end+1) = back_incl;
                end
                if (count_intersect_front > 1 && count_intersect_back > 1) || (~found_seg_front && ~found_seg_back) || (count_intersect_front > 1 && ~found_seg_back) || (~found_seg_front && count_intersect_back > 1)
                    count = count+1;
                    break
                end
            end
        end
    end
end