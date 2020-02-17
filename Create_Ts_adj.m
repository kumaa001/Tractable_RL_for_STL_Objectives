function [adj] = Create_Ts_adj(S,A,dim_Grid)

    %create transtion matrix (each node has an index)
    
    N = dim_Grid;%sqrt(size(S,1)); 
    M = dim_Grid;%sqrt(size(S,1));                  %# grid size
    CONNECTED = size(A,1)-1;                 %# 4-/8- connected points

    %# which distance function
    if CONNECTED == 4,     distFunc = 'cityblock';
    elseif CONNECTED == 8, distFunc = 'chebychev'; end

    %# compute adjacency matrix
    [X Y] = meshgrid(1:N,1:M);
    X = X(:); Y = Y(:);
    adj = squareform( pdist([X Y], distFunc) == 1 );
    adj=adj+eye(size(S,1));
   
      
end

