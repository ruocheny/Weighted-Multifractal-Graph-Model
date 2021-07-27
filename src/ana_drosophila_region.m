clear;close all;
ROI = {'ME_R','AME_R','LO_R','LOP_R'};
rpt_Num = 50;
for rrr = 1:length(ROI)
    region = ROI{rrr};

    for rpt = 1:rpt_Num
        load(strcat("result_drosophila/full/result_",ROI{rrr},"_",num2str(rpt)));
        ROI = {'ME_R','AME_R','LO_R','LOP_R'};
        
        adj_all{rrr} = networkIdx;
        
        paraP{rrr}(:,:,rpt) = modelParaP;
        paraL{rrr}(:,rpt) = modelParaL;
        
        if modelParaP(1,1) > modelParaP(2,2)
            paraL{rrr}(1,rpt) = modelParaL(2);
            paraL{rrr}(2,rpt) = modelParaL(1);
            paraP{rrr}(1,1,rpt) = modelParaP(2,2);
            paraP{rrr}(2,2,rpt) = modelParaP(1,1);
        end
        
        model{rrr}(:,:,rpt) = paraP{rrr}(:,:,rpt) .* (paraL{rrr}(:,rpt) * paraL{rrr}(:,rpt)');
    end
    
    mean_P{rrr} = mean(paraP{rrr},3);
    mean_L{rrr} = mean(paraL{rrr},2);
    std_P{rrr} = std(paraP{rrr},0,3);
    std_L{rrr} = std(paraL{rrr},0,2);
end


NN = 500;
colormap = 'summer';
for rrr=1:length(ROI)
    [mean_LK{rrr},~] = calcLK(M,K,idx,mean_L{rrr});
    mean_PK{rrr} = calcPK(M,K,idx,mean_P{rrr});
    model = plotmodel_2D_lined(M,1,NN,mean_P{rrr},mean_L{rrr},colormap,0);
    
end
