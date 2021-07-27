function [cc_sym_bin,cc_syn_bin_hist,degree_syn_hist,degree_syn] = MFNCalcSyn(M,K,N,rMax,w,LK,PK,def,cc_bins,simRpt,isDirected,isBinary)
% Clustering coefficients of a synthetic graph from the model

[idx] = calcIdx(M,K);
LKcum = cumsum(LK);
% simRpt=50;
for r=1:simRpt
    [adjSim(:,:,r), classSim(:,r)] = generateGraph(PK,LK,LKcum,N,isDirected,isBinary);
end

for r=1:simRpt
    
    %% cc
    networkPartial = adjSim(:,:,r);
    cc_sym_bin(:,r) = MFNCalcGraphClusterCoeff(M,K,rMax,networkPartial,N,def);
    cc_syn_bin_hist(:,r) = hist(cc_sym_bin(:,r),cc_bins);
    %     cum_cc_emp_bin(:,r) = cumsum(cc_emp_bin_hist/sum(cc_emp_bin_hist));
    
    %% degree
    adj_bin = double(networkPartial>0);
    degreeCnt = zeros(N,1);
    for u=1:N
        degreeCnt(u) = sum(adj_bin(u,:));
    end
    degree_hist = hist(degreeCnt,0:N);
    degree_syn_hist(:,r) = degree_hist(1:end)/sum(degree_hist(1:end));
    degree_syn(:,r) = degreeCnt;
end
