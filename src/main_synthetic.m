clear; close all;

N_sim = 500;
M_sim = 2;
K_sim = 3;
stepLen = 1e-7;
delta_stopping = 1e-1;
delta_stopping_M = 1e-3;

isDirected = 0;
isBinary = 0;

keep_ParaL = 0;

%% EM settings
iterMax = 300;
iterMaxE = 10;
iterMaxM = 100;

%% calc iteration idx
[idx_sim] = calcIdx(M_sim,K_sim);

%% initialization
simP = [0.8,0.5;0.5,0.4];
simL = [0.7,0.3];

%% multifractal analysis
% qvec = -4:0.1:4;
% [partition,dimension,alpha,spectrum] = MFNCalcModelPartition(M_sim,K_sim,simL,simP,1,qvec);


%% simulation
simPK = calcPK(M_sim,K_sim,idx_sim,simP);
[simLK,simLKcum] = calcLK(M_sim,K_sim,idx_sim,simL);
[adjSim, classSim] = generateGraph(simPK,simLK,simLKcum,N_sim,isDirected,isBinary);

%% estimation
M = M_sim;
K = K_sim;
[idx] = calcIdx(M,K);
N = N_sim;

% modelParaP0 = randi([1 4],M,M);
% modelParaP0 = (modelParaP0 + modelParaP0')/20;
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0 = ones(M,1)*1/M;

% estimation on full observation
networkIdx = adjSim;
main;
% save("result_sim/sim500_weighted.mat")
