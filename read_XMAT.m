function Xmat=read_XMAT(name,nbreColumns)
    seperator = [];
    for i = 1 : nbreColumns
        seperator = [seperator, ' %f'];
    end

    fid = fopen(name,'r');
    Xmat = textscan(fid,seperator);
    fclose(fid);
end

y=0.6*t.^2.1.*exp(-t./1.6)-0.0023*t.^3.54.*exp(-t./4.25);