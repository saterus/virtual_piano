function result = isListed2D( list, point )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[hei,wid] = size(list);

result = 0;

r = 1;
while r <= hei
   
    if (list(r,1) == point(1)) && (list(r,2) == point(2))
        result = 1;
        r = hei;
    end
    
    r = r+1;
    
end

end

