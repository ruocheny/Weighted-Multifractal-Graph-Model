% plot llh, para vs iterations; plot degree distributions, clustering coefficients, weight distributions; plot model
%% load data
clear;close all;
filename = 'result_drosophila/result_mushroom2.mat';
load(filename);

N_sim = N;
adjSim = networkIdx;
% use reconstructed model to generate a synthetic network
modelParaLKcum = cumsum(modelParaLK);
[adjSyn, classSyn] = generateGraph(modelParaPK,modelParaLK,modelParaLKcum,N_sim,isDirected,isBinary);


%% llh vs iter
figure;
plot(llh(1:iter),'lineWidth',2);
grid;
xlabel('EM iterations');
ylabel('Lower bound of log-likelihood');
xlim([0 70]);
ylim([-14500 -9500]);
set(gca,'fontSize',25);

%% para vs iter
figure;
hold on;
plot(squeeze(paraP_all(1,1,1:iter)),'lineWidth',2);
plot(squeeze(paraP_all(1,2,1:iter)),'lineWidth',2);
plot(squeeze(paraP_all(2,2,1:iter)),'lineWidth',2);
plot(paraL_all(1,1:iter),'lineWidth',2);
grid;
xlabel('EM iterations');
ylabel('Reconstructed parameters');
legend({'p_{11}','p_{12}','p_{22}','l_1'});
legend('boxoff');
set(gca,'fontSize',25);
xlim([0 70]);
ylim([0 1]);

%% plot model
% [model_log] = plotmodel_2D_lined(M,K,N,log(modelParaPK),modelParaLK,'summer',1);
[model_log] = plotmodel_2D(M,K,N,log(modelParaPK),modelParaLK,'summer',1);

%% hist of weight
adj_vec_sim = reshape(adjSim,1,N_sim^2);
adj_vec_syn = reshape(adjSyn,1,N_sim^2);
wbins = 0:1:max(max(adj_vec_syn),max(adj_vec_sim));

% empirical weight distribution of the entire graph (full oberservation)
adj_hist = hist(adj_vec_sim,wbins);
weight_cum_emp = cumsum(adj_hist/sum(adj_hist));

% synthetic weight distribution of reconstructed model
adj_hist = hist(adj_vec_syn,wbins);
weight_cum_syn = cumsum(adj_hist/sum(adj_hist));


figure;hold;
plot(wbins,weight_cum_emp,'lineWidth',2);
plot(wbins,weight_cum_syn,'lineWidth',2);
legend({'Empirical','Reconstructed'});
legend('boxoff');
xlabel('Weight category');
xticks(0:7);
ylabel({'Cumulative distribution'});
xlim([0 7]);
set(gca,'fontSize',25);
grid;


%% degree distribution (we first binarize the graph)
adj_bin = double(adjSim>0);
degreeCnt_emp = zeros(N_sim,1);
for u=1:N_sim
    degreeCnt_emp(u) = sum(adj_bin(u,:));
end

adj_bin = double(adjSyn>0);
degreeCnt_syn = zeros(N_sim,1);
for u=1:N_sim
    degreeCnt_syn(u) = sum(adj_bin(u,:));
end

ddegreeBins = 1;
degreeBins = min(min(degreeCnt_emp),min(degreeCnt_syn)):ddegreeBins:max(max(degreeCnt_emp),max(degreeCnt_syn));

% empirical (full observation, entire graph)
degree_hist = hist(degreeCnt_emp,degreeBins);
degree_emp = degree_hist(1:end)/sum(degree_hist(1:end));
degree_emp_cum = cumsum(degree_emp);

% reconstructed (synthetic graph from reconstructed model)
degree_hist = hist(degreeCnt_syn,degreeBins);
degree_syn= degree_hist(1:end)/sum(degree_hist(1:end));
degree_syn_cum = cumsum(degree_syn);

figure;
hold on;
plot(degreeBins,degree_emp,'lineWidth',2);
plot(degreeBins,degree_syn,'lineWidth',2);
grid;
legend({'Empirical','Reconstructed'});
xlabel('Degree');
ylabel('Probability density');
legend('boxoff');
set(gca,'fontSize',25);

%% clustering coefficients
clusterCoeffDef = 2;
[cc_emp] = calcEmpCC(adjSim,N_sim,clusterCoeffDef);
[cc_syn] = calcEmpCC(adjSyn,N_sim,clusterCoeffDef);
dccBins = 0.05;
ccBins = min(min(cc_emp),min(cc_syn)):dccBins:max(max(cc_emp),max(cc_syn));
cc_hist_emp = hist(cc_emp,ccBins);
cc_hist_emp = cc_hist_emp/sum(cc_hist_emp);
cc_hist_syn = hist(cc_syn,ccBins);
cc_hist_syn = cc_hist_syn/sum(cc_hist_syn);

figure;
hold on;
plot(ccBins,cc_hist_emp,'lineWidth',2);
plot(ccBins,cc_hist_syn,'lineWidth',2);
grid;
xlim([0,1]);
legend({'Empirical','Reconstructed'});
xlabel('Clustering Coefficients');
ylabel('Probability density');
legend('boxoff');
set(gca,'fontSize',25);