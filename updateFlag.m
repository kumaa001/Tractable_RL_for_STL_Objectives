function Flag_new = updateFlag(Flag_prev,s_now,S,tau,caseStudy)
    Flag_new = Flag_prev;
    s_now = S(s_now,:);
    if(tau-1 ~= 0)
        if caseStudy==1
            %STL specification 1: F_[0,10] G_[0,1] (x>4 and x<6 and y>4 and y<6)
            %Update flag based on the current flag value and state  
            if(s_now(1) > 4 && s_now(1) < 6 && s_now(2) > 4 && s_now(2) < 6)
                Flag_new = min(Flag_prev+1,tau-1);
            else
                Flag_new = 0;
            end
                
            
        elseif caseStudy==2
            %STL specification 2: G_[0,12] (F_[0,2](x>1 and x<2 and y>3 and y<4) and F_[0,2](x>2 and x<3 and y>2 and y<3))
            %Update flags based on the current flag value and state  
            
            % Flag(1) corresponds to the first sub formula F_[0,2](x>1 and x<2 and y>3 and y<4)
            if(s_now(1) > 1 && s_now(1) < 2 && s_now(2) > 3 && s_now(2) < 4)
                Flag_new(1) = tau-1;
            else
                Flag_new(1) = max(Flag_prev(1)-1,0);
            end
            
            % Flag(2) corresponds to the second sub formula F_[0,2](x>2 and x<3 and y>2 and y<3)
            if(s_now(1) > 2 && s_now(1) < 3 && s_now(2) > 2 && s_now(2) < 3)
                Flag_new(2) = tau-1;
            else
                Flag_new(2) = max(Flag_prev(2)-1,0);
            end
            
            
        end
    else
        Flag_new = zeros(size(Flag_prev));
    end

end