function [partition,dimension,alpha,spectrum] = MFNCalcModelPartition(M,K,l,p,NW,qvec)

tmp2 = zeros(M,M,NW);
a = zeros(M,M);
for i = 1:M
    for j = 1:M
        a(i,j) = l(i)*l(j);
    end
end

for i = 1:length(qvec)
    q = qvec(i);
    for w = 1:NW
        tmp(w) = sum(sum((a .* p(:,:,w)).^q));
        
        % %         for ii = 1:M
        % %             for jj = 1:M
        % %                 tmp2(ii,jj,w) = log(a(ii,jj)*p(ii,jj,w))*(a(ii,jj)*p(ii,jj,w))^q;
        % %             end
        % %         end
        tmp2(:,:,w) = log(a.*p(:,:,w)) .* (a.*p(:,:,w)).^q;
    end
    
    partition(i) =  sum(tmp.^K);
    epsi = (1/M)^(2*K)*1/NW;
    if(q~=1)
        dimension(i) = (1/(q-1)) * log(partition(i)) / log(epsi) ;
        alpha(i) = 1/log(epsi) * 1/partition(i) * sum(K*tmp.^(K-1) .* squeeze(sum(sum(tmp2)))');
        spectrum(i) = alpha(i) * q - dimension(i) *(q-1);
    else
        dimension(i) = -1/(partition(i) * log(epsi)) *  sum(K*tmp.^(K-1) .* squeeze(sum(sum(tmp2)))');
        alpha(i) = 1/log(epsi) * 1/partition(i) * sum(K*tmp.^(K-1) .* squeeze(sum(sum(tmp2)))');
        spectrum(i) = alpha(i) * q - log(partition(i)) / log(epsi) ;
%         spectrum(i) = alpha(i);
    end
end

