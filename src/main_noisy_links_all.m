%% estimation on nosiy observations (with false positive links), binary case
clear; close all;

N_sim = 500;
M_sim = 2;
K_sim = 3;
[idx_sim] = calcIdx(M_sim,K_sim);

stepLen = 1e-7;
delta_stopping = 1e-1;
delta_stopping_M = 1e-3;

isDirected = 0;
isBinary = 1;
keep_ParaL = 0;

%% EM settings
iterMax = 200;
iterMaxE = 10;
iterMaxM = 100;

%% simulation
% % simP0 = [0.8,0.5;0.5,0.4];
% % simL0 = [0.7,0.3];
% % PK = calcPK(M_sim,K_sim,idx_sim,simP0);
% % [LK,LKcum] = calcLK(M_sim,K_sim,idx_sim,simL0);
% % [adjSim, classSim] = generateGraph(PK,LK,LKcum,N_sim,isDirected,isBinary);
% % networkIdx0 = adjSim;
% % save("data_syn/noise_0")
load("data_syn/noise_0",'networkIdx0');

N = N_sim;
M = M_sim;
K = K_sim;
[idx] = calcIdx(M,K);
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0 = ones(M,1)*1/M;

%% adding noise: randomly add links
for rpt = 1:10
%     for p_link_add = [1e-3,3e-3,1e-2,3e-2,1e-1,3e-1]
    for p_link_add = [1e-3,1e-2,1e-1]
        
        networkIdx = networkIdx0;
        for u=1:N_sim
            for v=u+1:N_sim
                if (networkIdx(u,v)==0)
                    tmp = rand;
                    if (tmp<p_link_add)
                        networkIdx(u,v) = 1;
                        networkIdx(v,u) = 1;
                    end
                end
            end
        end
        
        %% estimation on noisy graph
        main;
        save(strcat("result_sim/noisyLinks/all/noise_add_",num2str(p_link_add*1e5),"_",num2str(rpt)));
    end
end