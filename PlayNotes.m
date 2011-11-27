function [] = PlayNotes(v)
% PLAYNOTES Takes a vector of notes of size 0-7, each value = 1-7, and plays audio
% representing the piano key mapping of the notes passed to the function 
% (1 = C, 2 = D, 3 = E, 4 = F, 5 = G, 6 = A, 7 = B).

global C D E F G A B;
n = zeros(22050,2);
np = 44100;

for j=1:size(v,2)

    if v(j)==1
        n = n+C;
    elseif v(j)==2
        n = n+D;
    elseif v(j)==3
        n = n+E;
    elseif v(j)==4
        n = n+F;
    elseif v(j)==5
        n = n+G;
    elseif v(j)==6
        n = n+A;
    else % v(j) = 7
        n = n+B;
    end
    
end

sound(n,np);