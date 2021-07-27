clear;close all;

load('data_hic/network_sis_chr21.mat','N','adj_cis_bin');

%% start estimation
M = 2;
K = 3;
[idx] = calcIdx(M,K);

isDirected = 0;
isBinary = 1;
keep_ParaL = 0;

%% EM settings and initialization
iterMax = 300;
iterMaxE = 10;
iterMaxM = 100;
stepLen = 2e-7;
% delta_stopping = 1e-1;
delta_stopping = 5e-1;
delta_stopping_M = 1e-3;

% % modelParaP0 = [0.1,0.12;0.12,0.1];
% % modelParaL0 = ones(M,1)*1/M;
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0 = ones(M,1)*1/M;

rptNum = 1;
for rptIdx=1:rptNum

    networkIdx = adj_cis_bin;
    main;
    save(strcat('result_hic/sis_chr21/cis_',num2str(rptIdx)));
    
end

