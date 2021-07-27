clear;close all;
simP0 = [0.8,0.5;0.5,0.4];
simL0 = [0.7,0.3];
p_link_add_all = [1e-3,1e-2,1e-1];
for iIdx = 1:length(p_link_add_all)
    for ssIdx = 1:10
        p_link_add = p_link_add_all(iIdx);
        load(strcat("result_sim/noisy/noise_add_",num2str(p_link_add*1e5),"_",num2str(ssIdx)));
        
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
sIdx = patch([p_link_add_all'; flip(p_link_add_all')], [squeeze(P_upper(1,1,:));flip(squeeze(P_lower(1,1,:)))],'b','LineStyle','none');
alpha(sIdx,0.4);
sIdx = patch([p_link_add_all'; flip(p_link_add_all')], [squeeze(P_upper(2,2,:));flip(squeeze(P_lower(2,2,:)))],'r','LineStyle','none');
alpha(sIdx,0.4);
sIdx = patch([p_link_add_all'; flip(p_link_add_all')], [squeeze(P_upper(1,2,:));flip(squeeze(P_lower(1,2,:)))],'g','LineStyle','none');
alpha(sIdx,0.4);
sIdx = patch([p_link_add_all'; flip(p_link_add_all')], [L_upper(1,:),flip(L_lower(1,:))]','k','LineStyle','none');
alpha(sIdx,0.4);

plot(p_link_add_all,squeeze(P_mean(1,1,:)),'b-','lineWidth',2)
plot(p_link_add_all,squeeze(P_mean(2,2,:)),'r-','lineWidth',2)
plot(p_link_add_all,squeeze(P_mean(1,2,:)),'g-','lineWidth',2)
plot(p_link_add_all,L_mean(1,:),'k-','lineWidth',2)

xlim([1e-3 3e-1])
ylim([0.35 0.85])
xticks(p_link_add_all)
xticklabels({'10^{-3}','3x10^{-3}','10^{-2}','3x10^{-2}','10^{-1}','3x10^{-1}'})
% xticks([3e-3,3e-2,3e-1])
% xticklabels({'3x10^{-3}','3x10^{-2}','3x10^{-1}'})
legend({'p_{11}=0.8','p_{22}=0.4','p_{12}=0.5','l_1=0.7'})
xlabel('Noise level');
ylabel('Reconstructed parameter');
% title('Reconstructing model with partial observations')
set(gca,'fontSize',25)
set(gca,'XScale','log')
legend('boxoff')
grid


%% mean error vs missingPct
% *** also add std here
err_mean = mean(err_all);
err_std = std(err_all) ;
err_upper = err_mean + err_std;
err_lower = err_mean - err_std;

figure;hold
sIdx = patch([p_link_add_all'; flip(p_link_add_all')], [err_upper';flip(err_lower')],'b','LineStyle','none');
alpha(sIdx,0.4)
plot(p_link_add_all,err_mean,'b','lineWidth',2)

xlim([1e-3 3e-1])
xticks(p_link_add_all)
xticklabels({'10^{-3}','3x10^{-3}','10^{-2}','3x10^{-2}','10^{-1}','3x10^{-1}'})
% xticks([3e-3,3e-2,3e-1])
% xticklabels({'3x10^{-3}','3x10^{-2}','3x10^{-1}'})

xlabel('Noise level')
ylabel('Mean RAE')
set(gca,'fontSize',25)
set(gca,'XScale','log')
grid