addpath('iSight', 'StopLoop');
height = 640;
width = 480;

FS = stoploop({'Push to stop camera.'}) ; 
iSight=iSightInit([height,width]);
while(~FS.Stop())
    bg = iSightCapture(iSight);
    imagesc(bg);
end
FS.Clear();
iSightClose(iSight);


FS = stoploop({'Push to stop camera.'}) ; 
iSight=iSightInit([height,width]);
while(~FS.Stop())
    kb = iSightCapture(iSight);
    imagesc(kb);
end
FS.Clear();
iSightClose(iSight);


FS = stoploop({'Push to stop camera.'}) ; 
iSight=iSightInit([height,width]);
while(~FS.Stop())
    hand1 = iSightCapture(iSight);
    imagesc(hand1);
end
FS.Clear();
iSightClose(iSight);


FS = stoploop({'Push to stop camera.'}) ; 
iSight=iSightInit([height,width]);
while(~FS.Stop())
    hand2 = iSightCapture(iSight);
    imagesc(hand2);
end
FS.Clear();
iSightClose(iSight);

FS = stoploop({'Push to stop camera.'}) ; 
iSight=iSightInit([height,width]);
while(~FS.Stop())
    hand3 = iSightCapture(iSight);
    imagesc(hand3);
end
FS.Clear();
iSightClose(iSight);
