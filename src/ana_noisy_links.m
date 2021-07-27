% link reliability for nosiy graph(with spurious links). this is the binary
% version of the model and the algorithm. for binary graph. p is simply
% considered as the linking probability in Erdos Renyi model

clear;close all;

%% load adjNoise and model
filepath = "result_sim/";
filestr = "noise_add_1e_1";
load(strcat(filepath,filestr));

%% calc link reliability, sort and classify (true pos/false pos)
adjNoise = networkIdx;
adjOrg = networkIdx0;
[link_relia,edgeIdx,edgeCnt] = getLinkReliability(M,K,N,adjNoise,tau,modelParaPK,modelParaLK);
[link_relia_sort,edgeIdx_sort] = sort(edgeIdx(1:edgeCnt,4));
cnt_pos_f = 0;
cnt_pos_t = 0;
pos_false = zeros(edgeCnt,4);
pos_true = zeros(edgeCnt,4);
for e=1:edgeCnt
    u = edgeIdx(edgeIdx_sort(e),1);
    v = edgeIdx(edgeIdx_sort(e),2);
    % check if the link is false positive
    if(adjOrg(u,v)==0)
        cnt_pos_f = cnt_pos_f+1;
        % [u,v,rank,link_reliability]
        pos_false(cnt_pos_f,:) = [u,v,e,link_relia_sort(e)];
    end
    % check if the link is true positive
    if(adjOrg(u,v)==1)
        cnt_pos_t = cnt_pos_t+1;
        pos_true(cnt_pos_t,:) = [u,v,e,link_relia_sort(e)];
    end
end
% % save(strcat(filepath,'ranked/',filestr));
% % load(strcat(filepath,'ranked/',filestr));

%% plot cdf
hbins = min(min(pos_true(1:cnt_pos_t,4)),min(pos_false(1:cnt_pos_f,4))):...
    0.05:max(max(pos_true(1:cnt_pos_t,4)),max(pos_false(1:cnt_pos_f,4)));
h_pos_t = hist(pos_true(1:cnt_pos_t,4),hbins);
h_pos_f = hist(pos_false(1:cnt_pos_f,4),hbins);
pdf_pos_t = h_pos_t/sum(h_pos_t);
pdf_pos_f = h_pos_f/sum(h_pos_f);
cmf_pos_t = cumsum(h_pos_t/sum(h_pos_t));
cmf_pos_f = cumsum(h_pos_f/sum(h_pos_f));

figure;hold on;
plot(hbins,cmf_pos_t,'lineWidth',2);
plot(hbins,cmf_pos_f,'lineWidth',2);
% % plot(hbins,pdf_pos_t,'lineWidth',2);
% % plot(hbins,pdf_pos_f,'lineWidth',2);
legend({'True positive','False positive'});
ylabel('Cumulative distribution');
xlabel('Link reliability');
xlim([hbins(1) hbins(end)]);
ylim([0 1]);
set(gca,'fontSize',25);
grid;