function [ R ] = CompRobustness_signal(hist,caseStudy,S,tau,T)
    
    traj=hist;
   
    if caseStudy==1
        %STL specification 1: F_[0,10] G_[0,1] (x>4 and x<6 and y>4 and
        %y<6) 
        for t=1:T
            k=1;
            x=[]; y=[];
            for j=t+0:t+tau-1
                x(k)=S(traj(j),1);
                y(k)=S(traj(j),2);
                %---------------------------
                rx1=x(k)-4;
                %rx2=6-x(k);
                ry1=y(k)-4;
                %ry2=6-y(k);
                %r=min([rx1,rx2,ry1,ry2]);
                r=min([rx1,ry1]);
                k=k+1;
            end
            rob(t)=r;%min(r);
        end
        R=max(rob);
    end
    
    if caseStudy==2
        %STL specification 2: G_[0,12] (F_[0,2](x>1 and x<2 and y>3 and
        %y<4) and F_[0,2](x>2 and x<3 and y>2 and y<3))
        for t=1:13-1
            k=1;
            x=[]; y=[];
            for j=t+0:t+tau-1
                x(k)=S(traj(j),1);
                y(k)=S(traj(j),2);
                %---------------------------
                %phi1= F_[0,2](x>1 and x<2 and y>2 and y<3)
                rx1=x(k)-1;
                rx2=2-x(k);
                ry1=y(k)-3;
                ry2=4-y(k);
                r_phi1(k)=min([rx1,rx2,ry1,ry2]);
                %phi2 = F_[0,2](x>2 and x<3 and y>2 and y<3)
                rx1=x(k)-2;
                rx2=3-x(k);
                ry1=y(k)-2;
                ry2=3-y(k);
                r_phi2(k)=min([rx1,rx2,ry1,ry2]);
                %--------------------------    
                k=k+1;
            end
            r1=max(r_phi1);
            r2=max(r_phi2);
            rob(t)=min([r1,r2]);
        end
        R=min(rob);
    end

end

