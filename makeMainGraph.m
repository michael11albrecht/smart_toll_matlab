function [main_adjm,main_coosL] = makeMainGraph(adjm,coosL)
%MAKEMAINGRAPH Searches for the largest connected graph
%   Based on the MST - Minimum Spanning Tree algorithm
    all_graphs = zeros(length(adjm),1);
    next_graph = 0;
    for i=1:length(adjm)
        other_graph = [];
        next_graph = next_graph+1;
        add_graph = 0;
        akt_graph = [i];
        for j=1:length(adjm)
            if adjm(j,i) ~= 0
                akt_graph(end+1) = j;
            end
        end
        for v = 1:length(akt_graph)
            if all_graphs(akt_graph(v)) ~= 0
                if add_graph == 0
                    add_graph = all_graphs(akt_graph(v));
                elseif add_graph == all_graphs(akt_graph(v))
                    %nothing
                else
                    for cng = 1:length(all_graphs)
                         if all_graphs(cng) == all_graphs(akt_graph(v))
                             all_graphs(cng) = add_graph;
                         end
                    end
                    other_graph(end+1,:) = [all_graphs(akt_graph(v)),akt_graph(v)];
                end
            end
        end
        if ~isempty(other_graph)
            add_graph;
            other_values = unique(other_graph(:,1));
        end
        for v = 1:length(akt_graph)
            if add_graph > 0
                all_graphs(akt_graph(v)) = add_graph;
            else
                all_graphs(akt_graph(v)) = next_graph;
            end
        end
    end
    
    %rework smaller graphs till no change
    old_num_graphs = 1;
    for iter = 1:100
        if old_num_graphs == length(unique(all_graphs)) || length(unique(all_graphs)) <= 1
            %no changes made during last iter
            break
        end
    [cnt_unique, unique_a] = hist(all_graphs,unique(all_graphs));
    found_graphs = [cnt_unique', unique_a];
    found_graphs = sortrows(found_graphs,1,"ascend");
    for i = 1:length(found_graphs)-1
        rw_graph_num = found_graphs(i,2);
        rw_graph = find(all_graphs == rw_graph_num);
        pot_other = [];
        for j = 1:length(rw_graph)
            for adjc = 1:length(adjm)
                if adjm(adjc,rw_graph(j)) ~= 0
                    if ~any(adjc == rw_graph(:))
                        pot_other(end+1) = adjc;
                    end    
                end
            end
        end
        if ~isempty(pot_other)
        highest_pot_rank = [0,0];
        for j = 1:length(pot_other)
            pot_graph_nr = all_graphs(pot_other(j));
            for rank = 1:length(found_graphs(:,2))
                if pot_graph_nr == found_graphs(rank,2)
                    if rank > highest_pot_rank(:,2)
                        highest_pot_rank = [pot_graph_nr,rank];
                    end
                end
            end
        end
        for j = 1:length(rw_graph)
            all_graphs(rw_graph(j)) = highest_pot_rank(1,1);
        end
        end
    end
    old_num_graphs = length(unique_a);
    if iter == 100
        disp('maingraph not stable')
    end
    end


    [cnt_unique, unique_a] = hist(all_graphs,unique(all_graphs));
    [~,idx_max] =  max(cnt_unique);
    main_graph_num = unique_a(idx_max);
    main_graph = find(all_graphs == main_graph_num);


    main_adjm = zeros(length(main_graph));
    main_coosL = zeros(length(main_graph),length(coosL(1,:)));
    
    for i=1:length(main_coosL(:,1))
        for j=1:length(main_coosL(:,1))
            main_adjm(j,i) = adjm(main_graph(j),main_graph(i));
        end
        main_coosL(i,:) = [coosL(main_graph(i),:)];
    end


end