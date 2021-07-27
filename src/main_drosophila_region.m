clear;close all;
ROI = {'ME_R','AME_R','LO_R','LOP_R'};
rptNum = 50;

%% hyper-para
M = 2;
K = 3;
[idx] = calcIdx(M,K);
isDirected = 0;
isBinary = 1;
keep_ParaL = 0;

%% estimation settings and stopping thresholds
iterMax = 300;
iterMaxE = 10;
iterMaxM = 100;
stepLen = 5e-6;
delta_stopping = 1e-1;
delta_stopping_M = 1e-3;

%% estimation initialization
% modelParaP0 = randi([10 40],M,M)/100;
modelParaP0 = [0.1,0.2;0.2,0.2];
modelParaL0 = ones(M,1)*1/M;

for roi_idx = 1:length(ROI)
    load(strcat("data_drosophila/network_",ROI{roi_idx}),'N','adj');
    region = ROI{roi_idx};
    
    %% make it symmetric ((pre,post)=(post,pre))
    for u=1:N
        for v=u+1:N
            tmp = adj(u,v) + adj(v,u);
            adj(u,v) = tmp;
            adj(v,u) = tmp;
        end
    end
       w_threshold = 0.99;
       networkIdx = double(adj > w_threshold);
        
    for rpt = 1:rptNum      
        main;
    end
end