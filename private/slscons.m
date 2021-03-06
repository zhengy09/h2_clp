function Const = slscons(A,B,C,R,M,N,L,T)
% encoding achivability constraint in SLS

    [n,m] = size(B);      % system dimension
    [p,~] = size(C);
  
    Const = [];
    % first spectral component
    Const = [Const, R(:,1:n) == zeros(n),...
                    M(:,1:n) == zeros(m,n), ...
                    N(:,1:p) == zeros(n,p)];    
    
    % second spectral component
    Const =[Const,R(:,n+1:2*n) == eye(n), ...
                  N(:,p+1:2*p) == B*L(:,1:p), ...
                  M(:,n+1:2*n) == L(:,1:p)*C];
    
    % the rest of them
    for t = 2:T
        Const = [Const, R(:,t*n+1:(t+1)*n) == A*R(:,(t-1)*n+1:t*n) + B*M(:,(t-1)*n+1:t*n), ...
                        N(:,t*p+1:(t+1)*p) == A*N(:,(t-1)*p+1:t*p) + B*L(:,(t-1)*p+1:t*p), ...
                        R(:,t*n+1:(t+1)*n) == R(:,(t-1)*n+1:t*n)*A + N(:,(t-1)*p+1:t*p)*C, ...
                        M(:,t*n+1:(t+1)*n) == M(:,(t-1)*n+1:t*n)*A + L(:,(t-1)*p+1:t*p)*C];
    end
    
    % the last component
    Const =[Const, A*R(:,T*n+1:end) + B*M(:,T*n+1:end) == 0, ...
                   A*N(:,T*p+1:end) + B*L(:,T*p+1:end) == 0, ...
                   R(:,T*n+1:end)*A + N(:,T*p+1:end)*C == 0, ...
                   M(:,T*n+1:end)*A + L(:,T*p+1:end)*C == 0];
end
