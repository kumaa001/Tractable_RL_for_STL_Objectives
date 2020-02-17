function [ b,s_next ] = dynamics( s_now,a,Adj,S,Flag,Q_table )
    
    current_s=S(s_now,:);
    ind=find(ismember(S(:,1:2),current_s,'rows'));
    feasible_nodes=find(Adj(ind,:));
    S_feasible=S(feasible_nodes,:);
    prob=0.93;
    unfeasible=[];
    %actions => 1:up, 2:up-right, 3:right, 4:down-right, 5:down, 6:down-left, 7:left, 8:up-left, 9:stay
    switch a
        case 1
            x_dum=current_s(1);
            y_dum=current_s(2)+1;
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum-1 y_dum; x_dum+1 y_dum; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
        case 2
            x_dum=current_s(1)+1;
            y_dum=current_s(2)+1;
            
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum-1 y_dum; x_dum y_dum-1; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end            
        case 3
            x_dum=current_s(1)+1;
            y_dum=current_s(2);
            
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum y_dum-1; x_dum y_dum+1; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
        case 4
            x_dum=current_s(1)+1;
            y_dum=current_s(2)-1;
            
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum y_dum+1; x_dum-1 y_dum; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
        case 5
            x_dum=current_s(1);
            y_dum=current_s(2)-1;

            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum y_dum-1; x_dum y_dum+1; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
        case 6
            x_dum=current_s(1)-1;
            y_dum=current_s(2)-1;
            
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum+1 y_dum; x_dum y_dum+1; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
        case 7
            x_dum=current_s(1)-1;
            y_dum=current_s(2);
            
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum y_dum+1; x_dum y_dum-1; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
        case 8
            x_dum=current_s(1)-1;
            y_dum=current_s(2)+1;
            
            ind2=find(ismember(S_feasible(:,1:2),[x_dum y_dum],'rows'));
            if isempty(ind2)==1
                next_s=current_s;
            else            
                c=rand;
                if c<prob
                    next_s=[x_dum y_dum];
                else
                    list=[x_dum+1 y_dum; x_dum y_dum-1; current_s(1) current_s(2)];
                    for i=1:size(list,1)
                       j=find(ismember(S_feasible(:,1:2),list(i,:),'rows'));
                       if isempty(j)==1
                           unfeasible=[unfeasible i];
                       end
                    end
                    if isempty(unfeasible)==1
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    else
                        list(unfeasible,:)=[];
                        ind3=randi(size(list,1));
                        next_s=list(ind3,:);
                    end
                end
            end
            
        case 9
            c=rand;
            if c<prob
                next_s=current_s;
            else
                ind2=randi(length(feasible_nodes));
                next_s=S(feasible_nodes(ind2),:);
            end
            
    end
    %next_s
    ind4=find(ismember(S(:,1:2),next_s,'rows'));    
    s_next=ind4;

    %Choosing the best possible action at [s_next,Flag]
    ind5=find(ismember(Q_table(:,1:end-2),[s_next,Flag],'rows'));
    feasibleQ=Q_table(ind5,end);
    candidates=find(feasibleQ==max(feasibleQ));
 %   if(length(candidates) == 0)
 %      length(candidates)
 %   end
    b=candidates(randi(length(candidates)));
end

