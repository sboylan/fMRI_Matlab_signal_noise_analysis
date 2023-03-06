function [tSNR,CNR,PVE,posCoefs,signifCoefs,signMask] = signal2noiseCalc(signal,error,stat,coefs,mask)

%%%
% This function studies the quality of fMRI signal regressions.
% inputs : The statistics need to be as pValue, for significance study.
% outputs : tSNR and CNR are a ratio while posCoefs & signifCoefs are percentages.
% signMask is the intersection between the grey matter mask and the
% significant voxels (pVal < 0.001)
%%%

if nargin < 5
    mask = ones(size(signal));
end
mask = double(mask) ;
mask(mask==0)=NaN;
signalMean = mean(signal,4,'omitnan') ;
nbreVoxels = sum(ones(size(coefs)).*mask,'all','omitnan');

% Percentage of variance explained
SSerr = sum((error).^2,'all','omitnan') ;
SStot = sum((signal - signalMean).^2,'all','omitnan');
PVE = 1 - SSerr/SStot ;

% tSNR        
tSNR=signalMean./std(error,[],4,'omitnan');
tSNR=tSNR.*mask;
tSNR=mean(tSNR,'all','omitnan');

% CNR
CNR=std(signal,[],4,'omitnan')./std(error,[],4,'omitnan');
CNR=CNR.*mask;
CNR=mean(CNR,'all','omitnan');

% mask of voxels that are significant after regression (pValue<0.001) 
signMask = (stat<0.001).*mask ;
signifCoefs = sum(signMask,'all','omitnan')/nbreVoxels ; 

% Positive Beta coefficients
posCoefs = sum((coefs>0).*mask,'all','omitnan')/nbreVoxels ; % three hick conditions 
end
    