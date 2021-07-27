function [model] = plotmodel_2D(M,K,N,modelParaPK,modelParaLK,cm,flag)

% [modelParaLK,~] = calcLK(M,K,idx,modelParaL);
% % for i=1:M^K
% %     interval_name{i} = num2str(round(modelParaLK(i)*100)/100);
% % end
N_LK = round(N*modelParaLK);
model = zeros(sum(N_LK));
for i=1:M^K
    for j=1:M^K
        model(sum(N_LK(1:i-1))+1:sum(N_LK(1:i)),sum(N_LK(1:j-1))+1:sum(N_LK(1:j)))...
            = modelParaPK(i,j)*ones(N_LK(i),N_LK(j));
    end
end
figure;
if flag==1
    imagesc(model);
else
    imagesc(model,[0 1]);
end
colormap(cm);
if flag==1
    colorbar('Ticks',[-6,-3,-2,-1,-0.66], 'TickLabels', {'0.00','0.05','0.14','0.37','0.52'})
else
    colorbar;
end
set(gca,'fontSize',25);
% % xticks(round(N*modelParaLKcum));
% % yticks(round(N*modelParaLKcum));
xticklabels({});
yticklabels({});
% % xticklabels(interval_name);
% % yticklabels(interval_name);