function [N,networkTarOrg] = loadHic(contactVec,resolution)

% % N = max(contactVec(:,1))/resolution + 1;
% % networkTarOrg = zeros(N,N);
% % for i = 1:length(contactVec)
% %     networkTarOrg(contactVec(i,1)/resolution+1,contactVec(i,2)/resolution+1) = contactVec(i,3);
% %     networkTarOrg(contactVec(i,2)/resolution+1,contactVec(i,1)/resolution+1) = contactVec(i,3);
% % end

N = max(contactVec(:,1))/resolution + 1;
networkTarOrg = zeros(N,N);
for i = 1:length(contactVec)
    networkTarOrg(contactVec(i,1)/resolution+1,contactVec(i,2)/resolution+1) = ...
        networkTarOrg(contactVec(i,1)/resolution+1,contactVec(i,2)/resolution+1) + contactVec(i,3);
    
    networkTarOrg(contactVec(i,2)/resolution+1,contactVec(i,1)/resolution+1) = ...
        networkTarOrg(contactVec(i,2)/resolution+1,contactVec(i,1)/resolution+1) + contactVec(i,3);
end