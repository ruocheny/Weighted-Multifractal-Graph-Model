clear; close all;
N_sim = 100000; % 1e6, 5e5 with edgelist still exceed the matlab size limit
S = 10; % rptNum

%% simulation
% use same networkIdx0 (fully observed network when reconstructing on partial observations)
filenameAdj = strcat('data_syn\nodePartial_sp\nodePartial_edgeListSim_',num2str(N_sim));
filenamePos = strcat('data_syn\nodePartial_sp\nodePartial_edgeListSim_',num2str(N_sim),'_start_pos');
% % simP0 = [0.8,0.5;0.5,0.4];
% % simL0 = [0.7,0.3];
% % PK = calcPK(M_sim,K_sim,idx_sim,simP0);
% % [LK,LKcum] = calcLK(M_sim,K_sim,idx_sim,simL0);
% % [edgeListSim, classSim] = generateGraphSp(PK,LK,LKcum,N_sim,isDirected,isBinary);
% % save(filenameAdj, 'edgeListSim', 'classSim');
load(filenameAdj, 'edgeListSim');

% %  [start] = getSubgraphSpPos(edgeListSim,N_sim);
% % save(filenamePos,'start');
load(filenamePos,'start'); % marks the start position of u

%% subgraph extraction
N_all = 50:50:500;
N_start = 1;
for nIdx = 1:length(N_all)
    for sIdx = 1:S
        N = N_all(nIdx);
        % randomly sampling nodes and construct the observed network from the edgeList
        networkIdx = subGraphSp(N, N_start, N_sim, edgeListSim, start);
        % save result
        filename = strcat('data_syn\nodePartial_sp\network_',num2str(N_sim),'_',num2str(N),'_',num2str(sIdx));
        save(filename, 'networkIdx');
        N_start = N_start + N; % subgraphs are non-overlapping
    end
end