% sampled as graph with 500 nodes, mapping weight to weight index:
% w(r)={200:100:1000,max}.

clear;close all;

%% load data and prepossing: in quiescence/exponential growth
load('data_hic/Yeast_expGrowth');
contactVec = Yeast_expGrowth;
resolution = 24;
[N,network0_exp] = loadHic(contactVec,resolution);
load('data_hic/Yeast_quiescent');
contactVec = Yeast_quiescent;
[~,network0_qui] = loadHic(contactVec,resolution);

%% discretize and weight distribution analysis
wbins = [200:100:1000,max(max(max(network0_exp)),max(max(network0_qui)))];
for u=1:N
    for v=1:N
        network_exp(u,v) = find(network0_exp(u,v)<=wbins,1)-1;
        network_qui(u,v) = find(network0_qui(u,v)<=wbins,1)-1;
    end
end

adj_vec = reshape(network_exp,1,N^2);
xbins = 0:1:max(adj_vec);
adj_hist = hist(adj_vec,xbins);
adj_exp_hist_norm = adj_hist/sum(adj_hist);

adj_vec = reshape(network_qui,1,N^2);
xbins = 0:1:max(adj_vec);
adj_hist = hist(adj_vec,xbins);
adj_qui_hist_norm = adj_hist/sum(adj_hist);

%% start estimation
M = 2;
K = 3;
[idx] = calcIdx(M,K);

isDirected = 0;
isBinary = 0;

%% EM settings and initialization
iterMax = 300;
iterMaxE = 10;
iterMaxM = 100;
stepLen = 1e-7; %5e-8
delta_stopping = 1e-1;
delta_stopping_M = 1e-3;

% % modelParaP0 = [0.1,0.12;0.12,0.1];
% % modelParaL0 = ones(M,1)*1/M;
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0 = ones(M,1)*1/M;


%% run varEM on quiesence
networkIdx = network_qui;
keep_ParaL = 0;
main;
save('result_hic/yeast/result_hic_qui')

%% run varEM on exppnential growth
networkIdx = network_exp;
modelParaL0 = modelParaL;
keep_ParaL = 1;
main;
save('result_hic/yeast/result_hic_exp')
