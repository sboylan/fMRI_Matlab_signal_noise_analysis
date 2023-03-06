function [CMRO2out]=calcCMRO2(M,PWbetas,meanPW,MECbetas,meanMEC,mask,writeNIIflag)
%%%
%   This is the final step for CMRo2 calculation.
%   This function needs the factor M that has to be calculated through the
%   calcM.m function.
%   You PWbetas and MEC betas should be the same size, there should be as
%   many 3d matrices as there are conditions in the experiment.
%   The 4th dimenssion will be the number of conditions/regressors.
%   The baseline should be a 3d matrix of the brain
%   Negative ratios or null voxels will be set to NaN as they don't have
%   any signification (negative CBF or voxels outside the brain)
%%%
if nargin<5
    mask = ones(size(PWbetas,[1 2 3]));
end
if nargin<6
    writeNIIflag = false ;
end
    nbrCond=size(PWbetas,4);
    alpha = 0.2;
    beta = 1;
    BOLD0 = meanMEC ;
    CBF0 = meanPW ;
    CBF0(CBF0<=0)=NaN;
    BOLD0(BOLD0<=0)=NaN;
    strArr=['1','2','4'];
    for i = [1 2 3]
        eval(['deltaBOLDcond',strArr(i),' = MECbetas(:,:,:,i);']);
        eval(['CBFcond',strArr(i),' = MECbetas(:,:,:,i);']);
    end
    
    CBF1ratio = CBFcond1./CBF0 ;
    CBF1ratio(CBF1ratio<0)=NaN;
    CBF2ratio = CBFcond2./CBF0 ;
    CBF2ratio(CBF2ratio<0)=NaN;
    CBF4ratio = CBFcond4./CBF0 ;
    CBF4ratio(CBF4ratio<0)=NaN;
    
    BOLDratio1=deltaBOLDcond1./BOLD0;
    BOLDratio2=deltaBOLDcond2./BOLD0;
    BOLDratio4=deltaBOLDcond4./BOLD0;
    
    CMRO2cond1 = ((1-BOLDratio1./M).*((CBF1ratio).^(beta-alpha))).^1/beta ;
    CMRO2cond2 = ((1-BOLDratio2./M).*((CBF2ratio).^(beta-alpha))).^1/beta ;
    CMRO2cond4 = ((1-BOLDratio4./M).*((CBF4ratio).^(beta-alpha))).^1/beta ; 
    
    CMRO2out(:,:,:,1) = CMRO2cond1.*double(mask);
    CMRO2out(:,:,:,2) = CMRO2cond2.*double(mask);
    CMRO2out(:,:,:,3) = CMRO2cond4.*double(mask);

if writeNIIflag
    dnow = datestr(now,'dd-mm-yyyy_HH-MM-SS');
    niftiwrite(CMRO2cond1,['CMRO2_cond1',dnow,'.nii']);
    niftiwrite(CMRO2cond2,['CMRO2_cond2',dnow,'.nii']);
    niftiwrite(CMRO2cond4,['CMRO2_cond4',dnow,'.nii']);
    disp(['CMRO2 matrices saved as : ','"CMRO2_condX',dnow,'.nii"']);
end
end
