% flag: 1-input is log; 0-input is the original value
function [model] = plotmodel_2D_lined(M,K,N,modelParaPK,modelParaLK,cm,flag)

modelParaLKcum = cumsum(modelParaLK);
for i=1:M^K
    interval_name{i} = num2str(round(modelParaLK(i)*100)/100);
end
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
%     imagesc(model,[0 0.12]);
end
colormap(cm);
if flag==1
    colorbar('Ticks',[-6,-3,-2,-1,-0.66], 'TickLabels', {'0.003','0.050','0.135','0.368','0.517'})
else
    colorbar;
end
set(gca,'fontSize',25);
xticks(round(N*modelParaLKcum));
yticks(round(N*modelParaLKcum));
hold on;
xticklabels({});
yticklabels({});


%% add line of subblocks
lineClr = [50 50 50]/255;
for i=1:M^K-1
    line([0,sum(N_LK)],[sum(N_LK(1:i)),sum(N_LK(1:i))],'Color',lineClr,'lineWidth',2);
    line([sum(N_LK(1:i)),sum(N_LK(1:i))],[0,sum(N_LK)],'Color',lineClr,'lineWidth',2);
end
%% add numerical values
for i=1:M^K
    i_pos = sum(N_LK(1:i-1)) + N_LK(i)/2;
    text(i_pos-15 ,-10,num2str(modelParaLK(i),'%0.2f'),'fontSize',15);
    text(-40,i_pos,num2str(modelParaLK(i),'%0.2f'),'fontSize',15);
    for j=1:M^K
        j_pos = sum(N_LK(1:j-1)) + N_LK(j)/2;
        if flag==1
            text(i_pos - 15,j_pos,num2str(exp(modelParaPK(i,j)),'%0.2f'),'fontSize',15);
        else
            text(i_pos - 15,j_pos,num2str(modelParaPK(i,j),'%0.2f'),'fontSize',15);
        end
    end
end

% % for i=1:M^K
% %     i_pos = sum(N_LK(1:i-1)) + N_LK(i)/2;
% %     text(i_pos-15 ,-10,num2str(modelParaLK(i),'%0.2f'),'fontSize',15);
% %     text(-40,i_pos,num2str(modelParaLK(i),'%0.2f'),'fontSize',15);
% %     for j=1:M^K
% %         j_pos = sum(N_LK(1:j-1)) + N_LK(j)/2;
% %         text(i_pos - 15,j_pos,num2str(exp(modelParaPK(i,j)),'%0.2f'),'fontSize',15);
% %     end
% % end
% % xticklabels(interval_name);
% % yticklabels(interval_name);