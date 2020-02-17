function [ a] = eGreedy(Q_table,s,Flag,episode)    
    ind=find(ismember(Q_table(:,1:end-2),[s,Flag],'rows'));
    q=Q_table(ind,end);
    
    %SOFTMAX action selection
    %-------------------------
%     for i=1:5
%        x(i)=exp(q(i)/tau); 
%     end
%     
%     x_sum=sum(x(:));
%     
%     for i=1:5
%        pr(i)=x(i)/x_sum; 
%     end
%     
%     w=rand;
%     
%     if w<=pr(1)
%         a=1;
%     end
%     if w>pr(1) && w<=pr(1)+pr(2)
%         a=2;
%     end
%     if w>pr(1)+pr(2) && w<=pr(1)+pr(2)+pr(3)
%         a=3;
%     end
%     if w>pr(1)+pr(2)+pr(3) && w<=pr(1)+pr(2)+pr(3)+pr(4)
%         a=4;
%     end
%     if w>pr(1)+pr(2)+pr(3)+pr(4) 
%         a=5;
%     end
    
    %e-greedy with constant e
    %-------------------------
    e=0.99^episode;
    if rand<e
        a=randi(9);
    else
        candidates=find(q==max(q));
        a=candidates(randi(length(candidates)));
    end
end

