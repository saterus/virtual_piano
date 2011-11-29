function retObj=iSightInit(size)
isight_path=iSightPath();
javaaddpath(isight_path);
retObj=javaObject('ISightJpgCapture',size(1),size(2));