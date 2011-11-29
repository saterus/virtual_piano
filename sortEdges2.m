function [ sortedlist ] = sortEdges2( image, pixellist )
%sortedges2 returns a clockwise sorted list of boundary pixels
%given a binary image and a pixellist
%   sortEdges2 takes a binary image returned from a [canny] edge detector
%   and the PixelList returned from RegionProps. It takes the first pixel
%   from the list, then follows 8-connected neighbor pixels clockwise 
%   around the contour and returns the corresponding ordered list.

%get the size of the list
dims = size(pixellist);
no_entries = dims(1);

sortedlist = zeros(dims);

%grab a point
point = pixellist(1,:);

%grab the eight neighbors' coordinants
nebs = [point(1)-1,point(2)-1;point(1),point(2)-1;point(1)+1,point(2)-1;point(1)-1,point(2);point(1)+1,point(2);point(1)-1,point(2)+1;point(1),point(2)+1;point(1)+1,point(2)+1];
hold off;
imshow(image);
hold on;
plot(point(1),point(2),'b+');

sortedlist(1,1:2) = point;

%check 8 neighbors for value = 1
for p = 1: 1: 8
    
    %snap(1:3,1:3) = image(point(2)-1:point(2)+1,point(1)-1:point(1)+1)
    
   %1st priority: up
   if (image(nebs(2,2),nebs(2,1)) == 1)
       %disp('move up');
      hits = [nebs(2,1), nebs(2,2)]; 
      p = 9;  
   %2nd priority: tr
   elseif (image(nebs(3,2),nebs(3,1)) == 1)
       %disp('move up and right');
      hits = [nebs(3,1), nebs(3,2)]; 
      p = 9;
   %3rd priority: right
   elseif (image(nebs(6,2),nebs(6,1)) == 1)
       %disp('move right');
      hits = [nebs(6,1), nebs(6,2)]; 
      p = 9;
   %4th priority: br
   elseif (image(nebs(8,2),nebs(8,1)) == 1)
       %disp('move down and right');
      hits = [nebs(8,1), nebs(8,2)]; 
      p = 9;
   %5th priority: down
   elseif (image(nebs(7,2),nebs(7,1)) == 1)
       %disp('move down');
      hits = [nebs(7,1), nebs(7,2)]; 
      p = 9;
   %6th priority: bl
   elseif (image(nebs(6,2),nebs(6,1)) == 1)
       %disp('move down and left');
      hits = [nebs(6,1), nebs(6,2)]; 
      p = 9;
   %7th priority: left
   elseif (image(nebs(4,2),nebs(4,1)) == 1)
       %disp('move left');
      hits = [nebs(4,1), nebs(4,2)]; 
      p = 9;
   %8th priority: tl
   elseif (image(nebs(1,2),nebs(1,1)) == 1)
       %disp('move up and left');
      hits = [nebs(1,1), nebs(1,2)]; 
      p = 9;
   end
   
end
%there should only be two entries

%enter the current point into an ordered list and repeat the process
%for the neighbor you chose
sortedlist(2,1:2) = hits;

prev = point;
curr = hits;

plot(hits(1),hits(2),'y+');

%GET SECOND PIXEL IN THE ORDER
    
    point = hits;
    
    %grab the eight neighbors' coordinants
    nebs = [point(1)-1,point(2)-1;point(1),point(2)-1;point(1)+1,point(2)-1;point(1)-1,point(2);point(1)+1,point(2);point(1)-1,point(2)+1;point(1),point(2)+1;point(1)+1,point(2)+1];
    
    %check 8 neighbors for value = 1
    p = 1;
    while p < 8
        
           %1st priority: up
           if (image(nebs(2,2),nebs(2,1)) == 1)
               %disp('move up');
              hits = [nebs(2,1), nebs(2,2)]; 
              p = 9;  
           %2nd priority: tr
           elseif (image(nebs(3,2),nebs(3,1)) == 1)
               %disp('move up and right');
              hits = [nebs(3,1), nebs(3,2)]; 
              p = 9;
           %3rd priority: right
           elseif (image(nebs(6,2),nebs(6,1)) == 1)
               %disp('move right');
              hits = [nebs(6,1), nebs(6,2)]; 
              p = 9;
           %4th priority: br
           elseif (image(nebs(8,2),nebs(8,1)) == 1)
               %disp('move down and right');
              hits = [nebs(8,1), nebs(8,2)]; 
              p = 9;
           %5th priority: down
           elseif (image(nebs(7,2),nebs(7,1)) == 1)
               %disp('move down');
              hits = [nebs(7,1), nebs(7,2)]; 
              p = 9;
           %6th priority: bl
           elseif (image(nebs(6,2),nebs(6,1)) == 1)
               %disp('move down and left');
              hits = [nebs(6,1), nebs(6,2)]; 
              p = 9;
           %7th priority: left
           elseif (image(nebs(4,2),nebs(4,1)) == 1)
               %disp('move left');
              hits = [nebs(4,1), nebs(4,2)]; 
              p = 9;
           %8th priority: tl
           elseif (image(nebs(1,2),nebs(1,1)) == 1)
               %disp('move up and left');
              hits = [nebs(1,1), nebs(1,2)]; 
              p = 9;
           end
        
    end
    
    sortedlist(3,1:2) = hits;

prev = curr;
curr = hits;


%GET ALL REMAINING PIXELS IN THE ORDER

plot(hits(1),hits(2),'y+');

%go through the rest of the list
are_more = 1;
r = 4;
while(are_more)
%while(r<500)
    point = hits;
    
    %grab the eight neighbors' coordinants
    nebs = [point(1)-1,point(2)-1;point(1),point(2)-1;point(1)+1,point(2)-1;point(1)-1,point(2);point(1)+1,point(2);point(1)-1,point(2)+1;point(1),point(2)+1;point(1)+1,point(2)+1];
    
    %check 8 neighbors for value = 1
    p = 1;
    while p < 8
        
        %snap(1:3,1:3) = image(point(2)-1:point(2)+1,point(1)-1:point(1)+1)
        
           %1st priority: up
           if (image(nebs(2,2),nebs(2,1)) == 1) && (~(isListed2D(sortedlist,nebs(2,:))))  
               %disp('move up');
              hits = [nebs(2,1), nebs(2,2)]; 
              p = 9;  
           %2nd priority: tr
           elseif (image(nebs(3,2),nebs(3,1)) == 1) && (~(isListed2D(sortedlist,nebs(3,:))))
               %disp('move up and right');
              hits = [nebs(3,1), nebs(3,2)]; 
              p = 9;
           %3rd priority: right
           elseif (image(nebs(5,2),nebs(5,1)) == 1) && (~(isListed2D(sortedlist,nebs(5,:))))
               %disp('move right');
              hits = [nebs(5,1), nebs(5,2)]; 
              p = 9;
           %4th priority: br
           elseif (image(nebs(8,2),nebs(8,1)) == 1) && (~(isListed2D(sortedlist,nebs(8,:))))
               %disp('move down and right');
              hits = [nebs(8,1), nebs(8,2)]; 
              p = 9;
           %5th priority: down
           elseif (image(nebs(7,2),nebs(7,1)) == 1) && (~(isListed2D(sortedlist,nebs(7,:))))
               %disp('move down');
              hits = [nebs(7,1), nebs(7,2)]; 
              p = 9;
           %6th priority: bl
           elseif (image(nebs(6,2),nebs(6,1)) == 1) && (~(isListed2D(sortedlist,nebs(6,:))))
               %disp('move down and left');
              hits = [nebs(6,1), nebs(6,2)]; 
              p = 9;
           %7th priority: left
           elseif (image(nebs(4,2),nebs(4,1)) == 1) && (~(isListed2D(sortedlist,nebs(4,:))))
               %disp('move left');
              hits = [nebs(4,1), nebs(4,2)]; 
              p = 9;
           %8th priority: tl
           elseif (image(nebs(1,2),nebs(1,1)) == 1) && (~(isListed2D(sortedlist,nebs(1,:))))
               %disp('move up and left');
              hits = [nebs(1,1), nebs(1,2)]; 
              p = 9;
           else
               %all eight neighbors have been encountered before
               %IE we have processed "all" of the perimeter points (-x)
               are_more = 0;
               p = 9;
           end
    end
    
    prev = curr;
    curr = hits;
    
    plot(hits(1),hits(2),'y+');
    
    sortedlist(r,1:2) = hits;
    
    r = r+1;
end

hold off;

%sortedlist has a number of empty ([0,0]) entires at the bottom.
% Remove these entires (make sortedlist shorter by removing these)
r = r-1;
%si1 = size(sortedlist)
sortedlist = sortedlist(1:r,1:2);
%si2 = size(sortedlist)

disp('The boundary pixels are found and sorted. Press ENTER.');
%pause;

end

