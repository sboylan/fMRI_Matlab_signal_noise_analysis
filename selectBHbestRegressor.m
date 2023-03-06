function [bestCoefs,bestTscores,bestResiduals,bestpValues]=selectBHbestRegressor(coefs,tscores,residuals,pVal)

    if nargin < 2
        error("You need at least the tscores to select best delayed regressor")
    end
    if nargin < 3
        residuals = zeros(size(tscores));
        pVal = zeros(size(tscores));
    end
    if nargin < 4
        pVal = zeros(size(tscores));
    end
    tscores = squeeze(tscores);
    coefs = squeeze(coefs);
    residuals = squeeze(residuals);
    pVal = squeeze(pVal);
    
    sizes=size(tscores);
    nbreTR = size(residuals,4)/11;
    [~,delayDim] = min(sizes);
    bestCoefs = zeros(sizes(1:3));
    bestResiduals = zeros([sizes(1:3),nbreTR]);
    bestTscores = zeros(sizes(1:3));
    bestpValues = zeros(sizes(1:3));
    
    
    tscores(coefs<0)=0;

    [temp,I] = max(tscores,[],delayDim);
    
    for i = 1 : size(tscores,1)
        for j = 1 : size(tscores,2)
            for k = 1 : size(tscores,3)
                bestCoefs(i,j,k) = coefs(i,j,k,I(i,j,k));
                bestpValues(i,j,k) = pVal(i,j,k,I(i,j,k)) ;
                bestTscores(i,j,k) = tscores(i,j,k,I(i,j,k));
                bestResiduals(i,j,k,:)=residuals(i,j,k,(1+(I(i,j,k)-1)*nbreTR):((I(i,j,k))*nbreTR));
            end
        end
    end
end
