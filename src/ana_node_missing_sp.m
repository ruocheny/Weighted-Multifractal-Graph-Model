%% plot mean and std for partial observations
%%
clear;
close all;
N0 = 100000;
M = 2;
SMax = 10;

simP0 = [0.8,0.5;0.5,0.4];
simL0 = [0.7,0.3];
NN_all = 100:100:500;

I = length(NN_all);
P_all = zeros(M,M,SMax,I);
L_all = zeros(M,SMax,I);
err_P_all = zeros(M,M,SMax,I);
err_L_all = zeros(M,SMax,I);
err_all = zeros(SMax,I);
P_mean = zeros(M,M,I);
P_std = zeros(M,M,I);
L_mean = zeros(M,I);
L_std = zeros(M,I);

for iIdx = 1:length(NN_all)
    NN = NN_all(iIdx);
    for ssIdx=1:SMax
        filename = strcat('result_sim/nodePartial_sp - 50/',num2str(N0),'_',num2str(NN),'_',num2str(ssIdx));
        load(filename);
        P_reshape = modelParaP;
        L_reshape = modelParaL;
        if(modelParaP(1,1) < modelParaP(2,2))
            P_reshape(1,1) = modelParaP(2,2);
            P_reshape(2,2) = modelParaP(1,1);
            L_reshape(1) = modelParaL(2);
            L_reshape(2) = modelParaL(1);
        end
        P_all(:,:,ssIdx,iIdx) = P_reshape;
        L_all(:,ssIdx,iIdx) = L_reshape;
        err_P_all(:,:,ssIdx,iIdx) = abs(P_reshape - simP0)./simP0;
        err_L_all(:,ssIdx,iIdx) = abs(L_reshape - simL0)./simL0;

        % note: since constraint sum(L)=1 exist and P is symmetric, we only
        % use L(1:M-1) and triu(P) to calculate the error. What's more,
        % error here is defined as mean relative absolute error per parameter
        %         err_all(ssIdx,iIdx) = sum(err_L_all(1:M-1,ssIdx,iIdx))/(M-1) + ...
        %             sum(sum(triu(err_P_all(:,:,ssIdx,iIdx))))/((1+M)*M/2);
        err_all(ssIdx,iIdx) = (sum(err_L_all(1:M-1,ssIdx,iIdx))+ ...
            sum(sum(triu(err_P_all(:,:,ssIdx,iIdx)))))...
            /((1+M)*M/2 + (M-1));

    end
    P_mean(:,:,iIdx) = mean(P_all(:,:,:,iIdx),3);
    P_std(:,:,iIdx) = std(P_all(:,:,:,iIdx),0,3);
    L_mean(:,iIdx) = mean(L_all(:,:,iIdx),2);
    L_std(:,iIdx) = std(L_all(:,:,iIdx),0,2);

end
P_upper = P_mean + P_std;
P_lower = P_mean - P_std;
L_upper = L_mean + L_std;
L_lower = L_mean - L_std;





%% plot mean and std
figure;hold;
sIdx = patch([NN_all'; flip(NN_all')], [squeeze(P_upper(1,1,:));flip(squeeze(P_lower(1,1,:)))],'b','LineStyle','none');
alpha(sIdx,0.4);
sIdx = patch([NN_all'; flip(NN_all')], [squeeze(P_upper(2,2,:));flip(squeeze(P_lower(2,2,:)))],'r','LineStyle','none');
alpha(sIdx,0.4);
sIdx = patch([NN_all'; flip(NN_all')], [squeeze(P_upper(1,2,:));flip(squeeze(P_lower(1,2,:)))],'g','LineStyle','none');
alpha(sIdx,0.4);
sIdx = patch([NN_all'; flip(NN_all')], [L_upper(1,:),flip(L_lower(1,:))]','k','LineStyle','none');
alpha(sIdx,0.4);

plot(NN_all,squeeze(P_mean(1,1,:)),'b','lineWidth',2);
plot(NN_all,squeeze(P_mean(2,2,:)),'r','lineWidth',2);
plot(NN_all,squeeze(P_mean(1,2,:)),'g','lineWidth',2);
plot(NN_all,L_mean(1,:),'k','lineWidth',2);

legend({'p_{11}=0.8','p_{22}=0.4','p_{12}=0.5','l_1=0.7'});
xlabel('Number of nodes observed');
ylabel('Reconstructed parameter');
xticks(100:100:500);
set(gca,'fontSize',25);
legend('boxoff')
grid;


%% mean error vs missingPct
err_mean = mean(err_all);
err_std = std(err_all) ;
err_upper = err_mean + err_std;
err_lower = err_mean - err_std;

figure;hold;
sIdx = patch([NN_all'; flip(NN_all')], [err_upper';flip(err_lower')],'b','LineStyle','none');
alpha(sIdx,0.4);
plot(NN_all,err_mean,'b','lineWidth',2);
xticks(100:100:500);
xlabel('Number of nodes observed');
ylabel('Mean RAE');
set(gca,'fontSize',25);
grid;
