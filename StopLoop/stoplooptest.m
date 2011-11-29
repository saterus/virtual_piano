tic ; % We will measure elapsed time in a loop 
                   % Set up the stop box: 
FS = stoploop({'Stop me before', '5 seconds have elapsed'}) ; 
           % Display elapsed time 
fprintf('\nSTOPLOOP: elapsed time (s): %5.2f\n',toc) 
           % start the loop 
while(~FS.Stop() && toc < 5), % Check if the loop has to be stopped 
 fprintf('%c',repmat(8,6,1)) ; % clear up previous time 
 fprintf('%5.2f\n',toc) ; % display elapsed time 
end 
FS.Clear() ; % Clear up the box 
clear FS ; % this structure has no use anymore