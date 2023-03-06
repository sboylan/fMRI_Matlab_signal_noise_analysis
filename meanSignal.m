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

    meanResidualsGM = squeeze(mean(mean(mean(residuals.*mask,1,'omitnan'),2,'omitnan'),3,'omitnan'));
    meanSignalGM= squeeze(mean(mean(mean(signal.*mask,1,'omitnan'),2,'omitnan'),3,'omitnan')) ;

    for i=1 : numberRegressors
        meanSignal001(:,i) = squeeze(mean(mean(mean(signal.*signMask(:,:,:,i),1,'omitnan'),2,'omitnan'),3,'omitnan')) ;
        meanResiduals001(:,i) = squeeze(mean(mean(mean(residuals.*signMask(:,:,:,i),1,'omitnan'),2,'omitnan'),3,'omitnan'));
    end
end