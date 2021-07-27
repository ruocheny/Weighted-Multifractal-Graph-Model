function [link_relia,edgeIdx,edgeCnt] = getLinkReliability(M,K,N,networkIdx,tau,modelParaPK,modelParaLK)

link_relia = zeros(N,N);
for u=1:N
    for v=u+1:N
        link_relia(u,v) = sum(tau(u,:).*log(modelParaLK)) + sum(tau(v,:).*log(modelParaLK));
%         link_relia(u,v) = sum(tau(u,:).*log(modelParaLK)) + sum(tau(v,:).*log(modelParaLK)) ...
%             - sum(tau(u,:).*log(tau(u,:))) - sum(tau(v,:).*log(tau(v,:)));
        for q=1:M^K
            for h=1:M^K
                link_relia(u,v) = link_relia(u,v) + tau(u,q)*tau(v,h)*...
                    log(modelParaPK(q,h)^networkIdx(u,v)*(1-modelParaPK(q,h))^(1-networkIdx(u,v)));
            end
        end
%         link_relia(v,u) = link_relia(u,v);
    end
end

edgeCnt = 0;
edgeIdx = zeros(floor(N^2/2),4); % edgeIdx(e,:)=[node u, node v, weight r,reliability]
for u=1:N
    for v = u+1:N
        %     for v=1:N
        if(networkIdx(u,v)==1)
            edgeIdx(edgeCnt+1,:) = [u,v,networkIdx(u,v),link_relia(u,v)];
            edgeCnt  = edgeCnt + 1;
        end
    end
end