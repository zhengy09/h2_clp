%% Comparsion with centralized H2, IOP, SLS 
% If the plant has uncontrollable and unobserable stable modes, IOP is
% better than SLS

clc; clear all; close all
clear yalmip
% dynamics in discrete time
% Generalized state-space model
% x[t+1] = A x[t] + B1 w[t] + B2  u[t]
% z[t]   = C1x[t] + D11w[t] + D12 u[t]
% y[t]   = C2x[t] + D21w[t] + D22 u[t]

% n = 5; m = 2; p = 2;

n = 2;  % number of states
p = 2;  % number of outputs
m = 2;  % number of inputs
r = p;  % number of disturbances
%q = 2*p;  % number of performance signals

Q = eye(p);
R = eye(m);

A   = randi([-30,30],n,n)/pi;  B2  = randi([-5,5],n,m); %(rand(n,n)-rand(n,n));
C2  = randi([-5,5],p,n);  

% create an uncontrollable and unobserable stable mode
%n = n + 1;
%A = blkdiag(rand(1),A);B2 = [zeros(1,m);B2]; C2  = [zeros(p,1),C2];  

%[n,rank(ctrb(A,B2)),rank(obsv(A,C2))]

B1 = zeros(n,r); 
D21 = eye(p);     D22 = zeros(p,m);
C1  = [Q^(0.5)*C2;
        zeros(m,n)];
D11 = [Q^(0.5);
        zeros(m,p)];
D12 = [zeros(p,m);
        R^(0.5)];

%  generalized state-space model
B = [B1, B2];
C = [C1;C2];
D = [D11 D12;
     D21 D22];

P = ss(A,B,C,D,[]);  % discrete time model -- transfer matrices


%% standard H2 control
%[K,CL,gamma,info] = h2syn(P,p,m);




%% SLS
opts.N       = 8;

opts.type    = 1;
[Ksls,H2sls,infosls] = clph2(A,B2,C2,Q,R,opts);

%% IOP
opts.type    = 2;
opts.solver  = 'mosek';
[Kiop,H2iop,infoiop] = clph2(A,B2,C2,Q,R,opts);

%[H2iop,H2sls]

%% Test stability of SLS/IOP
%fprintf('The eigenvalues of Acl with Ksls are:\n')
%eig([A+B2*Kslsr.D*C2 B2*Kslsr.C;Kslsr.B*C2 Kslsr.A])
%fprintf('The eigenvalues of Acl with Kiop are:\n')
%eig([A+B2*Kiop.D*C2 B2*Kiop.C;Kiop.B*C2 Kiop.A])

%% closed-loop systems 
G      = ss(A,B2,C2,[],[]);
% sls
CLsls  = feedback(G,Ksls,+1);
% pole(CLsls)
% tzero(CLsls)
tol = 1e-14;
CLslsr = minreal(CLsls,tol);  % pole/zero cancellation in closed-loop responses
pole(CLslsr)

% pole/zero cancellation in controller
Kslsr = minreal(Ksls,tol);
CLslsr1  = feedback(G,Kslsr,+1);
pole(CLslsr1)



% iop
CLiop  = feedback(G,Kiop,+1);
% pole(CLiop)
% tzero(CLiop)
%tol = 1e-11;
CLiopr = minreal(CLiop,tol);
pole(CLiopr)

%Kiopr = minreal(Kiop,tol);
%CLiopr1  = feedback(G,Kiopr,+1);
%pole(CLiopr1)





