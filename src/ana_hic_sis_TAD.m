clear;close all;

%% load reconstrcuted WMG model
rpt = 1;
load(strcat("result_hic/sis_chr21/cis_",num2str(rpt)));

paraP = modelParaP;
paraL = modelParaL;
if modelParaP(1,1) > modelParaP(2,2)
    paraL(1) = modelParaL(2);
    paraL(2) = modelParaL(1);
    paraP(1,1) = modelParaP(2,2);
    paraP(2,2) = modelParaP(1,1);
end

model_cis = paraP .* (paraL * paraL');


%% calc entropy for tau with each node
for u = 1:N
    entropy(u) = -sum(tau(u).*log(tau(u)));
end

%% compare entropy and TADs
load('data_hic/network_sis_chr21.mat','adj_cis');
figure;
imagesc(adj_cis_bin);
xticks([0:100:N]);
yticks([0:100:N]);
set(gca,'fontSize',25);
cm = [ones(256,1),linspace(1, 0, 256)',linspace(1, 0, 256)'];
% colormap('gray');
colormap(cm)
% imagesc(adj_cis);

figure;
plot(entropy,'lineWidth',2);
xticks([0:100:N]);
xlabel('Position');
ylabel('Entropy');
set(gca,'fontSize',25);
grid;
