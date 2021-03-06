%% open-loop stable systems

clc; clear all; close all
clear yalmip
% dynamics in discrete time
% Generalized state-space model
% x[t+1] = A x[t] + B1 w[t] + B2  u[t]
% z[t]   = C1x[t] + D11w[t] + D12 u[t]
% y[t]   = C2x[t] + D21w[t] + D22 u[t]

% n = 5; m = 2; p = 2;

n = 2;  % number of states
p = 1;  % number of outputs
m = 1;  % number of inputs
r = p;  % number of disturbances
%q = 2*p;  % number of performance signals

Q = eye(p);
R = eye(m);

A   = randi([-15,15],n,n)/5; B2  = randi([-2,2],n,m);
C2  = randi([-2,2],p,n);  

A  = A./max(abs(eig(A)))/1.1;


hA = blkdiag(-0.5,A);
hB2 = [0;B2];
hC2 = [0 C2];


% create an uncontrollable and unobserable stable mode
%n = n + 1;
%A = blkdiag(rand(1),A);B2 = [zeros(1,m);B2]; C2  = [zeros(p,1),C2];  

%[n,rank(ctrb(A,B2)),rank(obsv(A,C2))]

% B1 = zeros(n,r); 
% D21 = eye(p);     D22 = zeros(p,m);
% C1  = [Q^(0.5)*C2;
%         zeros(m,n)];
% D11 = [Q^(0.5);
%         zeros(m,p)];
% D12 = [zeros(p,m);
%         R^(0.5)];
% 
% %  generalized state-space model
% B = [B1, B2];
% C = [C1;C2];
% D = [D11 D12;
%      D21 D22];
% 
% P = ss(A,B,C,D,[]);  % discrete time model -- transfer matrices

%% standard H2 control
%[K,CL,gamma,info] = h2syn(P,p,m);

%% IOP
opts.N       = 20;
opts.type    = 2;
opts.solver  = 'mosek';
opts.costType = 2;
[Kiop,H2iop,infoiop] = clph2(hA,hB2,hC2,Q,R,opts);

%% SLS
opts.type    = 1;
[Ksls,H2sls,infosls] = clph2(A,B2,C2,Q,R,opts);

[H2iop,H2sls]

%% Test stability of SLS/IOP
%fprintf('The eigenvalues of Acl with Ksls are:\n')
%abs(eig([A+B2*Ksls.D*C2 B2*Ksls.C;Ksls.B*C2 Ksls.A]))
%fprintf('The eigenvalues of Acl with Kiop are:\n')
%eig([A+B2*Kiop.D*C2 B2*Kiop.C;Kiop.B*C2 Kiop.A])




