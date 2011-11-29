%You need to add toolbox path in preference,
%and change path information in 'iSightPath.m' file.

iSight=iSightInit([640,480]);
pause(5);
retI=iSightCapture(iSight);
imshow(retI);%axis image;
iSightClose(iSight);