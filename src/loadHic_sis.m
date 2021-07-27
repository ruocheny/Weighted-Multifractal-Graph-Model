clear;close all;
load('data_hic/sis_chr21.mat');

[N0,~] = size(cis_chr21);
nBins=100;
N=floor(N0/nBins);

adj_cis = zeros(N,N);
[i_idx,j_idx,val] = find(cis_chr21);
for e=1:length(i_idx)
    i = floor(i_idx(e)/nBins);
    j = floor(j_idx(e)/nBins);
    adj_cis(i,j) = adj_cis(i,j) + val(e);
end

adj_trans = zeros(N,N);
[i_idx,j_idx,val] = find(trans_chr21);
for e=1:length(i_idx)
    i = floor(i_idx(e)/nBins);
    j = floor(j_idx(e)/nBins);
   adj_trans(i,j) = adj_trans(i,j) + val(e);
end

threshold=2;
adj_cis_bin=double(adj_cis>threshold);
adj_trans_bin=double(adj_trans>threshold);

% % save('data_hic/network_sis_chr21.mat','N','adj_cis','adj_trans','cis_chr21','trans_chr21','adj_cis_bin','adj_trans_bin');
% save('data_hic/network_sis_chr21.mat');
