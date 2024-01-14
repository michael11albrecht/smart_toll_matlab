function route = aStar(AdjM,Coos_List,start_kn,end_kn)

closed = false(length(Coos_List));
open = [start_kn,0,0,0];
akt_kn = start_kn;
dist_start = 0;
L = [0,start_kn];
while(true)
    %endknoten = open --> stop
    if akt_kn == end_kn
        disp('found route')
        break
    end
    %durchlaufen der AdjM der reihe aktkn
    for i = 1:length(Coos_List)
        %kante größer 0 (echte kante)
        if any(AdjM(i,akt_kn) > 0) && any(closed(i) == false)
            %kanten kosten+kosten zum start + Luftlinie zum Ziel
            fnew = AdjM(i,akt_kn)+dist_start+sqrt((Coos_List(end_kn,1)-Coos_List(i,1))^2+(Coos_List(end_kn,2)-Coos_List(i,2))^2);
            if open(:,1) == i
                indize = find(open(:,1) == i);
                if open(indize,2) > fnew
                    open(indize,2) = fnew;
                    open(indize,3) = akt_kn;
                    open(indize,3) = dist_start;
                end
            else
                open(end+1,:) = [i,fnew,akt_kn,dist_start];
            end
        end
    end
    closed(akt_kn) = true;
    indize = find(open(:,1)==akt_kn);
    open(indize,:) = [];
    if isempty(open)
        disp('No route found!')
        break
    end
    min_f = min(open(:,2));
    indize = find(open(:,2)==min_f);
    % to make sure indize is always 1x1 (taking the first node in array)
    indize = indize(1,1);
    new_kn = open(indize,1);
    leading_kn = open(indize,3);
    L(end+1,:) = [leading_kn,new_kn];
    dist_start = open(indize,4);
    dist_start = dist_start + AdjM(new_kn,leading_kn);
    akt_kn = new_kn;
end
indize = length(L(:,1));
i = 1;
while true
    akt_kn = L(indize,2);
    last_kn = L(indize,1);
    if akt_kn > 0
        %adding segmentID to route List
        route(i,:) = Coos_List(akt_kn,3);
        i = i+1;
    end
    if akt_kn == start_kn
        break
    end
    indize = find(L(:,2)==last_kn);
end
%del double entries
del_list = [];
for i = 1:2:length(route)
    del_list(end+1,:) = i; 
end
route(del_list,:) = [];
end