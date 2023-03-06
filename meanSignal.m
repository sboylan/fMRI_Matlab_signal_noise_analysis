function [meanSignalGM,meanSignal001,meanResidualsGM,meanResiduals001] = meanSignal(signal,residuals,mask,signMask)

if nargin < 3
   mask = ones(size(signal)); 
end
if nargin < 2
    residuals = zeros(size(signal));
end
if nargin < 4
   signMask = mask ;  
end
    mask = squeeze(double(mask)) ;
    signMask = squeeze(double(signMask)) ;
    numberRegressors = size(signMask,4) ;

    meanResiduals001 = zeros(size(residuals,4),numberRegressors);
    meanSignal001 = meanResiduals001;

    meanResidualsGM = squeeze(nanmean(residuals.*mask,[1 2 3])) ;
    meanSignalGM= squeeze(nanmean(signal.*mask,[1 2 3])) ;

    for i=1 : numberRegressors
        meanSignal001(:,i) = nanmean(signal.*signMask(:,:,:,i),[1 2 3]) ;
        meanResiduals001(:,i) = nanmean(residuals.*signMask(:,:,:,i),[1 2 3]) ;
    end
end