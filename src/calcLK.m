function [LK,LKcum] = calcLK(M,K,idx,L)
% calculate K-1 th kronecker product of L
LK = zeros(1,M^K);
LKcum  = zeros(1,M^K);
for i=1:M^K
    LK(i) = prod(L(idx(:,i)));
    LKcum(i) = sum(LK(1:i));
end
