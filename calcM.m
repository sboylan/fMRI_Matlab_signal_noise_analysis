function [M]=calcM(PWbetas,meanPW,MECbetas,meanMEC,writeNIIflag,mask)
%%%
%   This function will compute the M factor matrix calculation.
%   You need to provide the beta coefficients and baseline from the
%   breathhold regression.
%   The mask is optional (For segmentation WM or GM or brain only)
%   Voxels that are zero or negativ will be set to NaNs as they aren't
%   logical (outside the brain or negative CBF flow).
%%%
if nargin<5
    mask = ones(size(PWbetas));
end
if nargin<6
    writeNIIflag = false ;
end
alpha = 0.2;
beta = 1;
mask(mask==0)=NaN; 

% BOLDratio = MECbetas./meanMEC;
% CBFratio = PWbetas./meanPW;
BOLDratio = MECbetas./meanMEC;
CBFratio = PWbetas./meanPW + 1;
CBFratio(CBFratio<=0)=NaN;
M = BOLDratio./(1-CBFratio.^(alpha-beta));
M = M.*double(mask);
if writeNIIflag
    dnow = datestr(now,'dd-mm-yyyy_HH-MM-SS');
    niftiwrite(M,['M_',dnow,'.nii']);
    disp(['M matrix saved as : ','"M_',dnow,'.nii"']);
end
    
end
