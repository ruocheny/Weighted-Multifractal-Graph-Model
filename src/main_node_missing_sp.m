clear; close all;
%% missing nodes: we can only oberseved partial network (nodes are missing)
% can we still reconstruct the graph? (i.e. a smaller graph)
N_sim = 100000; % 1e6, 5e5 with edgelist still exceed the matlab size limit
M_sim = 2;
K_sim = 3;
[idx_sim] = calcIdx(M_sim,K_sim);

isDirected = 0;
isBinary = 0;

delta_stopping = 1e-1; % make sure this is identical for all N
delta_stopping_M = 1e-3;
keep_ParaL = 0;

%% EM settings
iterMax = 200;
iterMaxE = 10;
iterMaxM = 100;

%% estimation initialization
M = M_sim;
K = K_sim;
idx = calcIdx(M,K);
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0= ones(1,M)/M;

N_all = 50:50:500;
stepLen0 = [1e-5,1e-5,5e-6,3e-6,5e-7,5e-7,5e-7,1e-7,1e-7,1e-7];
S = 10; % rptNum

for sIdx = 1:S
     for nIdx = 1:length(N_all)
        N = N_all(nIdx);
        stepLen = stepLen0(nIdx);
        % randomly sampling nodes and construct the observed network from
        filename = strcat('data_syn\nodePartial_sp\network_',num2str(N_sim),'_',num2str(N),'_',num2str(sIdx));
        load(filename, 'networkIdx');     
        % estimation
        main;
        % save result
        filename_result = strcat('result_sim\nodePartial_sp\',num2str(N_sim),'_',num2str(N),'_',num2str(sIdx));
        save(filename_result);
    end
end