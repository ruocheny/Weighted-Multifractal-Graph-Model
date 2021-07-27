function [partition,tau,dimension,alpha,spectrum] = calcModelPartition(M,K,l,p,qvec)
epsi = (1/M)^(2*K);
helper = l' * l .* p;
for i = 1:length(qvec)
    q = qvec(i);
    partition(i) = sum(sum(helper.^q))^K;
    tau(i) = log(partition(i))/log(epsi);
    alpha(i) = 1/(-2*log(M)) / sum(sum(helper.^q)) * sum(sum(log(helper).*helper.^q));
    spectrum(i) = alpha(i) * q - tau(i);

    if(q~=1)
        dimension(i) = tau(i)/(1-q);
    else
        dimension(i)=0;%%%
    end
end


% % tmp2 = zeros(M,M,NW);
% % a = zeros(M,M);
% % for i = 1:M
% %     for j = 1:M
% %         a(i,j) = l(i)*l(j);
% %     end
% % end
% % 
% % for i = 1:length(qvec)
% %     q = qvec(i);
% %     for w = 1:NW
% %         tmp(w) = sum(sum((a .* p(:,:,w)).^q));
% %         
% %         % %         for ii = 1:M
% %         % %             for jj = 1:M
% %         % %                 tmp2(ii,jj,w) = log(a(ii,jj)*p(ii,jj,w))*(a(ii,jj)*p(ii,jj,w))^q;
% %         % %             end
% %         % %         end
% %         tmp2(:,:,w) = log(a.*p(:,:,w)) .* (a.*p(:,:,w)).^q;
% %     end
% %     
% %     partition(i) =  sum(tmp.^K);
% %     epsi = (1/M)^(2*K)*1/NW;
% %     if(q~=1)
% %         dimension(i) = (1/(q-1)) * log(partition(i)) / log(epsi) ;
% %         alpha(i) = 1/log(epsi) * 1/partition(i) * sum(K*tmp.^(K-1) .* squeeze(sum(sum(tmp2)))');
% %         spectrum(i) = alpha(i) * q - dimension(i) *(q-1);
% %     else
% %         dimension(i) = -1/(partition(i) * log(epsi)) *  sum(K*tmp.^(K-1) .* squeeze(sum(sum(tmp2)))');
% %         alpha(i) = 1/log(epsi) * 1/partition(i) * sum(K*tmp.^(K-1) .* squeeze(sum(sum(tmp2)))');
% %         spectrum(i) = alpha(i) * q - log(partition(i)) / log(epsi) ;
% % %         spectrum(i) = alpha(i);
% %     end
% % end
% % 
