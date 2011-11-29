function retI=iSightCapture(iSight)
javaMethod('captureImage',iSight, 'temp');
retI=imread(fullfile(pwd,'temp'));