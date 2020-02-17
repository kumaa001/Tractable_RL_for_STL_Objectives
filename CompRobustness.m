function [ R ] = CompRobustness(S_tau_table,S,tau,caseStudy)

    if caseStudy==1
        %STL specification 1: F_[0,10] G_[0,1] (x>4 and x<6 and y>4 and y<6) 
        %Consider the inner formula
        for i=1:size(S_tau_table,1)
            x=[]; y=[];
            for j=1:tau
                x(j)=S(S_tau_table(i,j),1);
                y(j)=S(S_tau_table(i,j),2);
                %---------------------------
                rx1=x(j)-4;
                %rx2=6-x(j);
                ry1=y(j)-4;
                %ry2=6-y(j);
                %r(j)=min([rx1,rx2,ry1,ry2]);
                r(j)=min([rx1,ry1]);
            end
            R(i)=min(r);
        end
    end
    
    if caseStudy==2
        %STL specification 2: G_[0,12] (F_[0,2](x>1 and x<2 and y>3 and y<4) and F_[0,2](x>2 and x<3 and y>2 and y<3))
        %consider the inner formula
        for i=1:size(S_tau_table,1)
            x=[]; y=[];
            for j=1:tau
                x(j)=S(S_tau_table(i,j),1);
                y(j)=S(S_tau_table(i,j),2);
                %---------------------------
                %phi1= F_[0,2](x>1 and x<2 and y>3 and y<4)
                rx1=x(j)-1;
                rx2=2-x(j);
                ry1=y(j)-3;
                ry2=4-y(j);
                r_phi1(j)=min([rx1,rx2,ry1,ry2]);
                %phi2 = F_[0,2](x>2 and x<3 and y>2 and y<3)
                rx1=x(j)-2;
                rx2=3-x(j);
                ry1=y(j)-2;
                ry2=3-y(j);
                r_phi2(j)=min([rx1,rx2,ry1,ry2]);
                %--------------------------                
            end
            r1=max(r_phi1);
            r2=max(r_phi2);
            R(i)=min([r1,r2]);
        end
    end

end

