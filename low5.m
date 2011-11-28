function [ fivelowest ] = low5( hand )
%LOW5 returns 5 sharp points nearest the bottom of the image
%   Takes a binary image of a hand (filled in) and reduces it to an
%   outline. The boundary points are sorted clockwise and sharpness is
%   calculated at each point. We find (9) points of sharp angles, then find
%   the five that are clsest to the bottom of the image and return them in
%   x,y coordinate pairs.

im = hand;

%im = imread('mask.jpg');
%im = double(rgb2gray(im));
%im = im > 100;

%imshow(im);
%pause;

%get edges of board
border = edge(im, 'canny');


border2 = bwmorph(border,'thin');
%imshow(border2);
%pause;

%make list of edge pixels
list = regionprops(border2,'pixellist');
%get ordered list of border pixels, clockwise
olist = sortEdges2(border2,list.PixelList);

%prepare a short list of corner candidates
cand = [];
[c,d] = size(olist);
%how long to draw the vectors for calculating angle
k = 30;

 imshow(border);
 hold on;
 
for q = (k+1) : 1 : (c-k)
    
    %get points for calculation
    p1 = olist(q-k,:);
    p2 = olist(q,:);
    p3 = olist(q+k,:);
    
    %fprintf('P1 = %d,%d, P2 = %d,%d, P3 = %d,%d',p1(1),p1(2),p2(1),p2(2),p3(1),p3(2));
   
    %shift vectors l1, l2 to origin
     p1 = p1-p2;
     p3 = p3 - p2;
     p2 = [0,0];
    
    %find the angle using projections
    theta = acos((p1(1)*p3(1)+p1(2)*p3(2))/((sqrt(p1(1)*p1(1)+p1(2)*p1(2)))*(sqrt(p3(1)*p3(1)+p3(2)*p3(2)))));
    %theta = acos(dot(p1,p3)/(sqrt(sum(p1.^2))+sqrt(sum(p3.^2))));
    
    %find corners within about 60 to 130 degrees (corners of board)
    if (real(theta) < (130*(pi/180)))
        
        %we have a corner
        
        p2 = olist(q,:);
        rad = real(theta);
        deg = real(theta)*(180/pi);
        %fprintf('theta is %d, or %d degrees\n',rad,deg);
        plot(p2(1),p2(2),'g*');
        cand = [cand; p2(1), p2(2), theta];
        
    end
end

%get missed angles too (due to wrap around)
for q = 1:1:k
    
    %get points for calculation
    p1 = olist(c-k+q,:);
    p2 = olist(q,:);
    p3 = olist(q+k,:);
    
    %fprintf('P1 = %d,%d, P2 = %d,%d, P3 = %d,%d',p1(1),p1(2),p2(1),p2(2),p3(1),p3(2));
   
    %shift vectors l1, l2 to origin
     p1 = p1-p2;
     p3 = p3 - p2;
     p2 = [0,0];
    
    %find the angle using projections
    theta = acos((p1(1)*p3(1)+p1(2)*p3(2))/((sqrt(p1(1)*p1(1)+p1(2)*p1(2)))*(sqrt(p3(1)*p3(1)+p3(2)*p3(2)))));
    %theta = acos(dot(p1,p3)/(sqrt(sum(p1.^2))+sqrt(sum(p3.^2))));
    
    %find corners within about 60 to 130 degrees (corners of board)
    if (real(theta) < (130*(pi/180)))
        
        %we have a corner
        
        p2 = olist(q,:);
        rad = real(theta);
        deg = real(theta)*(180/pi);
        %fprintf('theta is %d, or %d degrees\n',rad,deg);
        plot(p2(1),p2(2),'g*');
        cand = [cand; p2(1), p2(2), theta];
        
    end
    
end

%get the ones from the back end too
for q = c-k:1:c
    
    %get points for calculation
    p1 = olist(q-k,:);
    p2 = olist(q,:);
    p3 = olist(k-q+c,:);
    
    %fprintf('P1 = %d,%d, P2 = %d,%d, P3 = %d,%d',p1(1),p1(2),p2(1),p2(2),p3(1),p3(2));
   
    %shift vectors l1, l2 to origin
     p1 = p1-p2;
     p3 = p3 - p2;
     p2 = [0,0];
    
    %find the angle using projections
    theta = acos((p1(1)*p3(1)+p1(2)*p3(2))/((sqrt(p1(1)*p1(1)+p1(2)*p1(2)))*(sqrt(p3(1)*p3(1)+p3(2)*p3(2)))));
    %theta = acos(dot(p1,p3)/(sqrt(sum(p1.^2))+sqrt(sum(p3.^2))));
    
    %find corners within about 60 to 130 degrees (corners of board)
    if (real(theta) < (130*(pi/180)))
        
        %we have a corner
        
        p2 = olist(q,:);
        rad = real(theta);
        deg = real(theta)*(180/pi);
        %fprintf('theta is %d, or %d degrees\n',rad,deg);
        plot(p2(1),p2(2),'g*');
        cand = [cand; p2(1), p2(2), theta];
        
    end
    
end

hold off
disp('The corner clusters have been identified. Press ENTER.');
pause;

no = size(cand);

bins = [];

avgs = [];

max_samples = 9

nums = zeros(1:max_samples);

%IN PROGRESS - narrow corner clusters to one point per cluster
for e = 1:1:no(1)
    
    h = 1;
    while h <= max_samples
        
        z = size(bins);
        
        if z(1) >= h
            
            can(1:3) = cand(e,:);
            %binned(1:3) = bins(h,1,1:3)
            
            %magical number 10
            %if the candidate is close to bin h's average, enter it
            if(sqrt(sum((can(1,1:2) - avgs(h,1:2)).^2)) < 20)
                %it fits in the h-th bin
                
                clear temp;
                temp(1:nums(h),1:3) = bins(h,1:nums(h),1:3);
                temp = [temp; cand(e,1:3)];
                bins(h,1:nums(h)+1,1:3) = temp(1:nums(h)+1,1:3);
                
                avgs(h,1:2) = avgs(h,1:2)*(nums(h)/(nums(h)+1)) + (1/(nums(h)+1))*cand(e,1:2);
                
                nums(h) = nums(h) + 1;
                
                h = max_samples+1;
                
            end
            %otherwise, go to the next bin
            
        else
            
            %bin h does not have entries

            %test
            can1 = cand(e,:);
            binned1 = [0 0 0];
            
            %insert candidate into bin h
            bins(h,1,1:3) = cand(e,1:3);
            
            %calculate average for bin h
            avgs(h,1:2) = cand(e,1:2);
            
            %increase count of elements in bin h
            nums(h) = nums(h) + 1;
            
            %exit loop
            h = max_samples+1;
            
        end
        
        h = h + 1;
        
        %z = size(bins);
        
    end
        
end


%avgs contains average pixel location for each corner cluster
%bins contains the groups of clusters

% for g = 1:1:max_samples
%    
%     if nums(g) > 0 && z(1) >= g
%        
%         c(g,1:nums(g),1:3) = bins(g,1:nums(g),1:3);
%         
%     end
%     
% end
% 
% temp(2,1:nums(1),1:3) = c(2,1:nums(1),1:3)

c1(1:nums(1),1:3) = bins(1,1:nums(1),1:3)
c2(1:nums(2),1:3) = bins(2,1:nums(2),1:3)
c3(1:nums(3),1:3) = bins(3,1:nums(3),1:3)
c4(1:nums(4),1:3) = bins(4,1:nums(4),1:3)
c5(1:nums(5),1:3) = bins(5,1:nums(5),1:3)
c6(1:nums(6),1:3) = bins(6,1:nums(6),1:3)
c7(1:nums(7),1:3) = bins(7,1:nums(7),1:3)
c8(1:nums(8),1:3) = bins(8,1:nums(8),1:3)

f1 = find(c1(:,3) == min(c1(:,3)))
f2 = find(c2(:,3) == min(c2(:,3)))
f3 = find(c3(:,3) == min(c3(:,3)))
f4 = find(c4(:,3) == min(c4(:,3)))
f5 = find(c5(:,3) == min(c5(:,3)))
f6 = find(c6(:,3) == min(c6(:,3)))
f7 = find(c7(:,3) == min(c7(:,3)))
f8 = find(c8(:,3) == min(c8(:,3)))

av1(1,1:2) = c1(f1(1),1:2);
av2(1,1:2) = c2(f2(1),1:2);
av3(1,1:2) = c3(f3(1),1:2);
av4(1,1:2) = c4(f4(1),1:2);
av5(1,1:2) = c5(f5(1),1:2);
av6(1,1:2) = c6(f6(1),1:2);
av7(1,1:2) = c7(f7(1),1:2);
av8(1,1:2) = c8(f8(1),1:2);

corners = [av1;av2;av3;av4;av5;av6;av7;av8]

imshow(border);
hold on
plot(corners(1,1),corners(1,2),'b*');
plot(corners(2,1),corners(2,2),'b*');
plot(corners(3,1),corners(3,2),'b*');
plot(corners(4,1),corners(4,2),'b*');
plot(corners(5,1),corners(5,2),'b*');
plot(corners(6,1),corners(6,2),'b*');
plot(corners(7,1),corners(7,2),'b*');
plot(corners(8,1),corners(8,2),'b*');
hold off
disp('Corner pixels have been found. Press ENTER.');
pause;

corners(:,2)

%for lower y :: lower pixel
%lowest = sort(corners(:,2))

%for higher y :: lower pixel
lowest = sort(corners(:,2));
lowest = lowest*-1;
lowest = sort(lowest);
lowest = lowest*-1;

no1 = find(corners(:,2) == lowest(1))
no2 = find(corners(:,2) == lowest(2))
no3 = find(corners(:,2) == lowest(3))
no4 = find(corners(:,2) == lowest(4))
no5 = find(corners(:,2) == lowest(5))

a = corners(find(corners(:,2) == lowest(1)),1:2)
b = corners(find(corners(:,2) == lowest(2)),1:2)
c = corners(find(corners(:,2) == lowest(3)),1:2)
d = corners(find(corners(:,2) == lowest(4)),1:2)
e = corners(find(corners(:,2) == lowest(5)),1:2)

%poly(:,1:2) = [a;b;c;d;e]
fivelowest = [];
if ~(isListed2D(fivelowest,a(1,1:2)))
   fivelowest(:,1:2) = [fivelowest;a];
end
%poly(:,1:2) = a;
if ~(isListed2D(fivelowest,b(1,1:2)))
   fivelowest = [fivelowest;b];
end
if ~(isListed2D(fivelowest,c(1,1:2)))
   fivelowest = [fivelowest;c];
end
if ~(isListed2D(fivelowest,d(1,1:2)))
   fivelowest = [fivelowest;d];
end
if ~(isListed2D(fivelowest,e(1,1:2)))
   fivelowest = [fivelowest;e];
end


end

