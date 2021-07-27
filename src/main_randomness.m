clear;close all;

S = 100; % total experiment num
N = 200;
M = 2;
K = 3;
[idx] = calcIdx(M,K);

isDirected = 0;
isBinary = 0;
keep_ParaL = 0;

delta_stopping = 1e-1;
delta_stopping_M = 1e-3;
stepLen = 5e-6;

%% EM settings
iterMax = 100;
iterMaxE = 10;
iterMaxM = 100;

%% initialization
% % modelParaP0 = ones(M,M)*0.2;
% % modelParaL0= ones(1,M)/M;
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0 = [0.5,0.5];
% % modelParaP0 = randi([2 4],M,M);
% % modelParaP0 = (modelParaP0 + modelParaP0')/20;
% % modelParaL0 = ones(M,1);
% % modelParaL0 = modelParaL0/sum(modelParaL0);

P = zeros(M,M,S);
L = zeros(M,S);
P_all = zeros(M,M,iterMax,S);
L_all = zeros(M,iterMax,S);
iter_stop = zeros(1,S);
llh_all = zeros(iterMax,S);

for filename = ["randomness_center","randomness_all_rnd","randomness_fixed_p12"]
    load(strcat("data_syn\",filename));
    %% estimation
    for s=1:S
        networkIdx = network_all(:,:,s);
        % model estimation initialization: same for all
        modelParaP = modelParaP0;
        modelParaL = modelParaL0;
        modelParaPK = calcPK(M,K,idx,modelParaP);
        [modelParaLK,~] = calcLK(M,K,idx,modelParaL);
        
        % model estimation
        main;
        % save results
        P(:,:,s) = modelParaP;
        L(:,s) = modelParaL;
        P_all(:,:,:,s) = paraP_all;
        L_all(:,:,s) = paraL_all;
        iter_stop(s) = iter;
        llh_all(:,s) = llh;
        
        disp(strcat('s=',num2str(s),' finished.'));
    end
    
    save(strcat("result_sim\",filename));
end