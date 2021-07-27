% main for hemibrain (fruit fly brain connectome): data preprocessing:
% subgraph of 500 nodes, mapping weight to weight index:
% w(r)={0,2,4,8,16,32,64,max}. the original graph is directed. To use our
% model, we consider a undirected graph, i.e. the value is added.
% connections are considering both with u->v and v->u

clear;close all;

%% load data and prepossing: AL in MB
load('data_drosophila/hemibrain_mushroom.mat');
edgeList = edge_AL_L;
[idx_sort_pre,idx_pre]=sort(edgeList(:,1));
idxMax_pre = 6201; 
edge = edgeList(idx_pre(1:idxMax_pre),:);
[idx_sort_post,idx_post]=sort(edge(:,2));

[E,~] = size(edge);
N = max(max(edge));
adj = zeros(N,N);
for e=1:E
    adj(edge(e,1),edge(e,2)) = adj(edge(e,1),edge(e,2)) +1;
end
%% make it symmetric ((pre,post)=(post,pre))
for u=1:N
    for v=u+1:N
        tmp = adj(u,v) + adj(v,u);
        adj(u,v) = tmp;
        adj(v,u) = tmp;
    end
end
%% discretize and weight distribution analysis
adj_vec = reshape(adj,1,N^2);
adj_hist = hist(adj_vec,0:1:max(adj_vec));
adj_d = zeros(N,N);
wbins = [0,2,4,8,16,32,64,max(adj_vec)];
for u=1:N
    for v=1:N
        adj_d(u,v) = find(adj(u,v)<=wbins,1)-1;
    end
end

adj_vec = reshape(adj_d,1,N^2);
xbins = 0:1:max(adj_vec);
adj_hist = hist(adj_vec,xbins);
adj_hist_norm = adj_hist/sum(adj_hist);

%% start estimation
M = 2;
K = 3;
[idx] = calcIdx(M,K);

isDirected = 0;
isBinary = 0;
keep_ParaL = 0;

%% EM settings and initialization
iterMax = 300;
iterMaxE = 10;
iterMaxM = 100;
stepLen = 5e-7;
delta_stopping = 1e-1;
delta_stopping_M = 1e-3;

modelParaP0 = [0.1,0.12;0.12,0.1];
modelParaL0 = ones(M,1)*1/M;
% % modelParaP0 = [0.1,0.2;0.2,0.2];
% % modelParaL0 = ones(M,1)*1/M;

%% run varEM
networkIdx = adj_d;
main;
save('result_drosophila/result_mushroom2.mat');
