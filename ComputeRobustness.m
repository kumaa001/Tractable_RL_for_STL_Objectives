function [ R ] = ComputeRobustness(S_tau,tau)

    global STL

    for i=1:size(S_tau,1)
        for j=1:tau
           trj=S_tau(i,2*j-1:2*j); 
           rr(j)=min(trj(1)-STL(1),trj(2)-STL(2)); 
        end
                   
        R(i)=min(rr(j));
        
%         if R(i)<=0
%             R(i)=0;
%         end
            
    end

end

