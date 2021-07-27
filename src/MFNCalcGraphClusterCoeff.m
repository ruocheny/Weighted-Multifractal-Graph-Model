function [cc] = MFNCalcGraphClusterCoeff(M,K,rMax,adj,N,def)
% clusterCoeff = zeros(1,M^K);
% clusterCoeff = zeros(1,length(class));
% % clusterCoeff2 = zeros(1,M^K);
% % cnt = zeros(1,M^K);

if(def==1)
    for i = 1:N
        triangleValue = 0;
        tripletValue = 0;
        for j = 1:N
            for q = 1:N
                if(adj(i,j)>0 && adj(i,q)>0)
                    tripletValue = tripletValue + 1;
                    if(adj(j,q)>0)
                        triangleValue = triangleValue + 1;
                    end
                end
            end
        end
        cc(i) = triangleValue/tripletValue;
        if(tripletValue == 0)
            cc(i)=0;
        end
        % %     clusterCoeff2(class(i)) = clusterCoeff2(class(i)) + cc(i);
        % %     cnt(class(i)) = cnt(class(i)) + 1;
    end
    % % clusterCoeff2 = clusterCoeff2 ./ cnt;
end

if(def==2)
    for i = 1:N
        triangleValue = 0;
        tripletValue = 0;
        for j = 1:N
            for q = 1:N
                if(adj(i,j)>0 && adj(i,q)>0)
                    tripletValue = tripletValue + (adj(i,j) + adj(i,q))/2;
                    if(adj(j,q)>0)
                        triangleValue = triangleValue + (adj(i,j) + adj(i,q) + adj(j,q))/3;
                    end
                end
                
            end
        end
        cc(i) = triangleValue/tripletValue;
        if(tripletValue == 0)
            cc(i)=0;
        end
        % %     clusterCoeff2(class(i)) = clusterCoeff2(class(i)) + cc(i);
        % %     cnt(class(i)) = cnt(class(i)) + 1;
    end
    % % clusterCoeff2 = clusterCoeff2 ./ cnt;
end

% % for i=1:M^K
% %     clusterCoeff(i) = sum(cc(find(class==i)))/length(find(class==i));
% % end