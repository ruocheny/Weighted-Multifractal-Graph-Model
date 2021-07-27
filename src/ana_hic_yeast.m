% plot llh, para vs iterations; plot weight distributions; plot model for
% hic datasets
clear; close all;

filename_exp = 'result_hic/yeast/result_hic_exp';
load(filename_exp);
iter_exp = iter;
llh_exp = llh;
modelParaPK_exp = modelParaPK;
modelParaP_exp = modelParaP;
modelParaLK_exp = modelParaLK;
%% hist of weight
adj_vec = reshape(networkIdx,1,N^2);
xbins = 0:1:max(adj_vec);
adj_exp_hist = hist(adj_vec,xbins);
adj_exp_hist_recon = zeros(1,length(xbins));
for i=1:M^K
    for j = 1:M^K
        adj_exp_hist_recon = adj_exp_hist_recon + N^2*modelParaLK(i)*modelParaLK(j)...
            *modelParaPK(i,j).^xbins*(1-modelParaPK(i,j));
    end
end


filename_qui = 'result_hic/yeast/result_hic_qui';
load(filename_qui);
iter_qui = iter;
llh_qui = llh;
modelParaPK_qui = modelParaPK;
modelParaP_qui = modelParaP;
modelParaLK_qui = modelParaLK;
%% hist of weight
adj_vec = reshape(networkIdx,1,N^2);
xbins = 0:1:max(adj_vec);
adj_qui_hist = hist(adj_vec,xbins);
adj_qui_hist_recon = zeros(1,length(xbins));
for i=1:M^K
    for j = 1:M^K
        adj_qui_hist_recon = adj_qui_hist_recon + N^2*modelParaLK(i)*modelParaLK(j)...
            *modelParaPK(i,j).^xbins*(1-modelParaPK(i,j));
    end
end


%% calculate diagnoal and non-diagnoal values
exp = modelParaPK_exp .* (modelParaLK_exp' * modelParaLK_exp);
diag_exp = sum(diag(exp));
nondiag_exp = sum(sum(exp)) - sum(diag(exp));

qui = modelParaPK_qui .* (modelParaLK_qui' * modelParaLK_qui);
diag_qui = sum(diag(qui));
nondiag_qui = sum(sum(qui)) - sum(diag(qui));

%% plot

%% model
cm = 'summer';
[model_exp] = plotmodel_2D(M,K,N,modelParaPK_exp,modelParaLK_exp,cm,0);
[model_qui] = plotmodel_2D(M,K,N,modelParaPK_qui,modelParaLK_qui,cm,0);

%% weight cmf
pdf_exp = adj_exp_hist/sum(adj_exp_hist);
pdf_qui = adj_qui_hist/sum(adj_qui_hist);
cmf_exp = cumsum(pdf_exp);
cmf_qui = cumsum(pdf_qui);

figure;hold on;
plot(xbins,cmf_exp,'lineWidth',2);
plot(xbins,cmf_qui,'lineWidth',2);
xlabel('Weight category');
ylabel({'Cumulative distribution'});
set(gca,'fontSize',25);
legend({'Exponential growth','Quiescence'});
legend('boxoff');
xlim([0 9]);
ylim([0.72 1]);
grid;