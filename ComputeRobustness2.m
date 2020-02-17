function [ R ] = ComputeRobustness2(S_tau,tau)

    %global STL

    %Specification: G_[0,T] (F_[0,3] visit A or visit D AND F_[0,3] visit B or visit C)
    
    for i=1:size(S_tau,1)
        for j=1:tau
           trj=S_tau(i,2*j-1:2*j); 
           
           %visit A or D
           r_A=min([trj(1)-1, 4-trj(1), trj(2)-3]); % x>1 and x<4 and y>3
           r_D=min([trj(1)-3,trj(2)-3]); %x>3 and y>3
           rr_AD(j)=max(r_A,r_D);
           %visit B or C
           r_B=min([trj(1)-1, 4-trj(1), trj(2)-1, 4-trj(2)]); % x>1 and x<4 and y>1 and y<4
           r_C=min([trj(1)-3, trj(2)-1, 4-trj(2)]); % x>3 and y>1 and y<4
           rr_BC(j)=max(r_B,r_C);
           %--------------          
        end
        rr1=max(rr_AD);     
        rr2=max(rr_BC); 
        R(i)=min(rr1,rr2);
        
%         if R(i)<=0
%             R(i)=0;
%         end
            
    end

end

