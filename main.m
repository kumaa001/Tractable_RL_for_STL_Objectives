%Problem: Consider an agent on a discretized grid environment.
%State (s): grid cell the agent is located on          (36 states for a 6x6 grid world)
%Action (a): up, right,left ,down , stay, diagonals    (4 + 4 cross path actions)
%Flags (f): Capture temporal distance of satisfaction for each sub formula in G(predicate)|F(predicate) from current time step
%Predicate: Logical True or False can be evalated for every time step
%Q(s,a): Value function corresponding to a pair of (s,a)
%-----------------------------------------------------------------
%Developed by D.Aksaray, modified by Harish latest update: 11/24/2019
%-----------------------------------------------------------------
close all;
clear all;
clc;

avg_PrS_sequence = [];
for rollout = 1:100

 
%-----------------------------------------------------USER INPUT----------------------------------------------------------------
beta=50; %for soft-max
problem=1;     % 1: pr satisfaction, 2:robustness degree 
    
Dim_grid=6;
caseStudy=2;
if caseStudy==1
    %STL specification 1: F_[0,7] G_[0,1] (x>4 and x<6 and y>4 and y<6)
    T=8;
    tau=1;
    %1 flag is defined since there is only one sub STL formula in the STL specification
    Flag = zeros(1,1);
end
if caseStudy==2
    %STL specification 2: G_[0,12] (F_[0,4](x>1 and x<2 and y>3 and y<4) and F_[0,4](x>2 and x<3 and y>2 and y<3))
    T=15;
    tau=3; % Both sub formulas, each has its own horizon tau
    %2 flags are defined. RdFlag(1) corresponds to F_[0,2](x>1 and x<2 and y>3 and y<4) 
    %RdFlag(2) corresponds to F_[0,2](x>1 and x<2 and y>3 and y<4)
    Flag = zeros(1,2);
end

%----------
gamma=0.9999;     %Discount factor
alpha=0.95;       %Learning rate
maxEpisode=10000; 
numSim=500;
%--------------------------------------------------------------------------

%Construct the state space and the adjacency matrix for the grid world 
delta_x=0.5;
delta_y=0.5;
k=1;
for j=1:Dim_grid
    for i=1:Dim_grid
        S(k,:)=[i-delta_x j-delta_y];
        k=k+1;
    end
end

% Action space
A = ["up";"up-right";"right";"down-right";"down";"down-left";"left";"up-left";"stay"];

labled_S=[1:1:size(S,1)];         %Generate the lables for each point in the state space
labled_A=[1:1:9];                 %Generate the lables for each action in the set of actions
Adj= Create_Ts_adj(S,A,Dim_grid); %Generate adjacency matix for the given action primitives



%% Q-Learning Implimentation 

if caseStudy==1  %STL specification 1: F_[0,10] G_[0,3] (x>4 and x<6 and y>4 and y<6)
    Q_table=full_fact(labled_S,0:(tau-1),labled_A);%current state/Flag value/actions
end
if caseStudy==2
    %STL specification 2: G_[0,12] (F_[0,3](x>1 and x<2 and y>3 and y<4) and F_[0,2](x>2 and x<3 and y>2 and y<3))
    Q_table=full_fact(labled_S,0:(tau-1),0:(tau-1),labled_A);%current state/Flag1 value/Flag2 value/actions
end

Q_table=[Q_table zeros(size(Q_table,1),1)]; %s_index / action_index / expected cumulative reward
% The above step also randomly intializes the Q_tablw with zero initial entries


labled_S = labled_S';
s_now=labled_S(8,:); % Random choice for intial state
%Off-policy TD learning (Q-learning)
for episode=1:maxEpisode
    fprintf('Iteration %d of %d of %d\n',episode,maxEpisode,rollout);
    % Reset flags in each run
    if caseStudy==1 
        Flag = zeros(1,1);
    elseif caseStudy==2 
        Flag = zeros(1,2); 
    end

    s_now=labled_S(8,:);   % Same random intial choice for state
    for t=1:T
        Flag_now = Flag;
        
        %Action selection
        a=eGreedy(Q_table,s_now,Flag_now,episode);
        
        %Flag update based on current flag value and s_now
        Flag = updateFlag(Flag_now,s_now,S,tau,caseStudy);
        
        %State update based on action chosen by eGreedy policy
        [b,s_next]=dynamics(s_now,a,Adj,S,Flag,Q_table);
        
        
        % Compute per step reward based on the flag value and s_next
        if problem==1
           if caseStudy==1
                satisfaction = Indicator(min([S(s_next,1)-4,6-S(s_next,1),S(s_next,2)-4,6-S(s_next,2)]));
                reward=exp(beta * Indicator(Flag(1) == (tau-1)) * satisfaction);
           end
           if caseStudy==2
                satisfaction1 = Indicator(min([S(s_next,1)-1,2-S(s_next,1),S(s_next,2)-3,4-S(s_next,2)])); % Satisfaction for F_[0,2](x>1 and x<2 and y>3 and y<4)
                satisfaction2 = Indicator(min([S(s_next,1)-2,3-S(s_next,1),S(s_next,2)-2,3-S(s_next,2)])); % Satisfaction for F_[0,2](x>2 and x<3 and y>2 and y<3)
                reward=-exp(-beta * (Indicator(Flag(1)) || satisfaction1) * (Indicator(Flag(1,2)) || satisfaction2));
           end
        end
        if problem==2
           fprintf('Not implimented');
        end
        
        %Update
        ind_Qprev=find(ismember(Q_table(:,1:end-1),[s_now,Flag_now,a],'rows'));
        Q_prev=Q_table(ind_Qprev,end);
        
        ind_Qstar=find(ismember(Q_table(:,1:end-1),[s_next,Flag,b],'rows'));
        Q_star=Q_table(ind_Qstar,end);
        
        Q=Q_prev+alpha^episode*(reward+gamma*(Q_star)-Q_prev);
        Q_table(ind_Qprev,end)=Q;
        s_now=s_next;
    end
end


%% Evaluate policy

s_now=labled_S(8,:);     %Intial state for each run in simulation
if caseStudy==1
    Flag = zeros(1);
end
if caseStudy==2
    Flag = zeros(1,2);
end
for i=1:numSim
    fprintf('Iteration %d\n',i);
    h(1,:)=s_now;
    for t=1:T-1
        q=[];
        ind2=find(ismember(Q_table(:,1:end-2),[h(t,:),Flag],'rows'));
        q=Q_table(ind2,end);
        candidates=find(q==max(q));
        a=candidates(randi(length(candidates)));
        Flag = updateFlag(Flag,h(t,:),S,tau,caseStudy);
        [b,h(t+1,:)]=dynamics(h(t,:),a,Adj,S,Flag,Q_table);  
    end
    %h=[14 11 14 11 14 11 14 11 14 11 14 11 14 11 14];
    Robustness(i)=CompRobustness_signal(h,caseStudy,S,tau,T);
    Prob(i)=Indicator(Robustness(i));
    traj=h;       %State trajectory from the known states 

    X(i,:)=traj;
    h=[];
end

% figure(121)
% hist(Robustness)
% xlabel('Robustness Degree')
% 
% figure(122)
% hist(Prob)
% xlabel('Satisfaction')
avg_RD = mean(Robustness)
avg_PrS = mean(Prob)

avg_PrS_sequence = [avg_PrS_sequence,avg_PrS]; 
end
%%
% Find trajectory with maximum Robustness degree
maxInd = find(Robustness == max(Robustness));
Index = maxInd(randi(size(maxInd,2)));


figure(2)
if caseStudy==1
    rect_H = rectangle('Position', [4, 4, 2, 2]);
    set(rect_H, 'FaceColor', [0, 1, 0]) 
end
if caseStudy==2
    rect_H1 = rectangle('Position', [1, 3, 1, 1]);
    set(rect_H1, 'FaceColor', [0, 1, 0]) 
    rect_H2 = rectangle('Position', [2, 2, 1, 1]);
    set(rect_H2, 'FaceColor', [0, 1, 1]) 
end
hold on
plot(S(:,1),S(:,2),'.','MarkerSize',15)
plot(S(X(Index,:),1),S(X(Index,:),2),'-k','LineWidth',2)
for i=0:Dim_grid
    plot([i,i],[0,Dim_grid],'b')
    plot([0,Dim_grid],[i,i],'b')
end
plot(S(s_now(1),1),S(s_now(1),2),'vk','MarkerSize',20)
xlabel('x')
ylabel('y')


    
figure(3)
subplot(211)
hold on
grid on
plot(0:1:size(X,2)-1,S(X(Index,:),1),'-k','LineWidth',4)
xlabel('t')
ylabel('x')

subplot(212)
plot(0:1:size(X,2)-1,S(X(Index,:),2),'-k','LineWidth',4)
grid on
xlabel('t')
ylabel('y')



