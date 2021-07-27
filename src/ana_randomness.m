%% error vs spectrum width with differen tlevel of randomness

clear;close all;

filename_all = {"result_sim/randomness_all_rnd","result_sim/randomness_fixed_p12","result_sim/randomness_center"};
color_all = {'b+','g*','ro'};

M=2;
S=100;

qvec = -4:0.1:4;
err_P_all = zeros(S,1);
err_L_all = zeros(S,1);
d_alpha_all = zeros(S,1);
deviation_all = zeros(S,1);

P_sample = zeros(M,M,S);
L_sample = zeros(M,S);
sim_P_sample = zeros(M,M,S);
sim_L_sample = zeros(M,S);
alpha_all = zeros(length(qvec),S);
spectrum_all = zeros(length(qvec),S);

for fIdx = 1:3
    cnt = 0;
    filename = filename_all{fIdx};
    
    load(filename);
    P_reshape = P;
    L_reshape = L;
    simP_reshape = simP;
    simL_reshape = simL;
    for s=1:S
        %% reshape the para
        if(P(1,1,s)>P(2,2,s))
            P_reshape(1,1,s) = P(2,2,s);
            P_reshape(2,2,s) = P(1,1,s);
            L_reshape(1,s) = L(2,s);
            L_reshape(2,s) = L(1,s);
        end
        if(simP(1,1,s)>simP(2,2,s))
            simP_reshape(1,1,s) = simP(2,2,s);
            simP_reshape(2,2,s) = simP(1,1,s);
            simL_reshape(1,s) = simL(2,s);
            simL_reshape(2,s) = simL(1,s);
        end
        
        %% sample error
        % clear out outliers (bad simulation): p<0.1 or p>0.9
        % clear out: p<0 and p>1 in the estimation process
        if((simP_reshape(2,2,s)<0.9) && (simP_reshape(1,1,s)>0.1)...
                &&(P_reshape(2,2,s)~=0.99)&&(P_reshape(1,1,s)~=0.01))
            cnt = cnt +1;
            [partition,dimension,alpha_all(:,cnt),spectrum_all(:,cnt)] = ...
                MFNCalcModelPartition(M,K,simL_reshape(:,s),simP_reshape(:,:,s),1,qvec);
            tmp = (simP_reshape(:,:,s) - P_reshape(:,:,s))./simP_reshape(:,:,s);
            err_P_all(cnt) = sum(sum(triu(abs(tmp))))/3;
            err_L_all(cnt) = abs(simL_reshape(1,s) - L_reshape(1,s))/simL_reshape(1,s);
            % %             err_P_all(cnt) = sum(sum(triu(tmp.^2)))/3;
            % %             err_L_all(cnt) = (simL_reshape(1,s) - L_reshape(1,s)).^2;
            d_alpha_all(cnt) = max(alpha_all(:,cnt))-min(alpha_all(:,cnt));
            deviation_all(cnt) = sum(sum((triu(abs(simP_reshape(:,:,s)-ones(M,M)*0.5)))));
            
            P_sample(:,:,cnt) = P_reshape(:,:,s);
            L_sample(:,cnt) = L_reshape(:,s);
            sim_P_sample(:,:,cnt) = simP_reshape(:,:,s);
            sim_L_sample(:,cnt) = simL_reshape(:,s);
        end
    end
    
    c_all(fIdx) = cnt;
    d_a(:,fIdx) = d_alpha_all;
    e_P(:,fIdx) = err_P_all;
    e_L(:,fIdx) = err_L_all;
end

e_all = (e_P*3 + e_L)/4;
% % figure;
% % subplot(1,2,1);hold on;
% % for fIdx=1:3
% %     plot(d_a(1:c_all(fIdx),fIdx),e_P(1:c_all(fIdx),fIdx),color_all{fIdx},'lineWidth',2);
% % end
% % xlabel('Multifractal spectrum width');
% % ylabel('Error of p');
% % set(gca,'fontSize',20);
% % % title('error per parameter');
% % grid;
% %
% % subplot(1,2,2);hold on;
% % for fIdx=1:3
% %     plot(d_a(1:c_all(fIdx),fIdx),e_L(1:c_all(fIdx),fIdx),color_all{fIdx},'lineWidth',2);
% % end
% % xlabel('Multifractal spectrum width');
% % ylabel('Error of l');
% % set(gca,'fontSize',20);
% % % title('error per parameter');
% % grid;
% %
% % legend({'fixed spectrum center','random p_{11},p_{22}','all random'});
% % set(gca,'fontSize',20);

figure;hold on;
for fIdx=1:3
    plot(d_a(1:c_all(fIdx),fIdx),e_all(1:c_all(fIdx),fIdx),color_all{fIdx},'lineWidth',2);
end
xlabel('Multifractal spectrum width');
ylabel('Mean relative absolute error');
% set(gca,'fontSize',20);
% title('error per parameter');
grid;
legend({'all rand','rand p_{11},p_{22}','fixed spectrum center'});
set(gca,'fontSize',25);
% set(gca,'YScale','log')
% set(gca,'XScale','log')
ylim([0 0.3]);
xlim([0 1.25]);
legend('boxoff')


