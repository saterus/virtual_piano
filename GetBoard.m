function [keys, keyLines] = GetBoard( bgimage, boardim )
%GETBOARD Locates the paper keyboard and keys
%   Takes in a bg image without the keyboard
%   followed by an image with the keyboard
%   (hard coded file locations) and detects the location of the board
%   within the image. Then it divides the keyboard region into
%   regions representing keys.
%
%   Returns the slope and y-intercept of each line
%   where lines outline the keyboard and divide the keys


%covert rgb to grey
[h, w, d] = size(bgimage);
if(d > 0)
    disp('is rgb');
    im1 = double(rgb2gray(bgimage));
    im2 = double(rgb2gray(boardim));
else
    disp('is not rgb');
    im1 = double(bgimage);
    im2 = double(boardim);
end

[hei, wid] = size(im1);

%prepare a results image
diff = zeros(hei,wid);
yiq1 = rgb2ntsc(bgimage);
yiq2 = rgb2ntsc(boardim);
T = .05;
for y=1:1:hei
    for x=1:1:wid
        if abs(yiq1(y,x,2)-yiq2(y,x,2)) + abs(yiq1(y,x,3)-yiq2(y,x,3)) > T
            temp(y,x) = 1;
        else
            temp(y,x) = 0;
        end
    end
end
imshow(temp);
disp('temp');
pause;

[diff, num] = bwlabel(temp, 8);
%determine number of groups
maxim = max(max(diff))

for i = 1: 1 : maxim
    %count members in each group
    loc(i) = length(find(diff == i));
end

%select largest group
most_members = max(loc)
which_group = find(loc == most_members)
[h,w] = size(diff);
for y = 1:h
    for x = 1:w
        %select pixels from this group
        if diff(y,x) == which_group
            diff(y,x) = 1;
        else
            diff(y,x) = 0;
        end
    end
end
imshow(diff);
pause;

%locate board using bg subtraction method 1:

%get size
% [hei, wid] = size(im1);
% 
% %prepare a results image
% diff = zeros(hei,wid);
% 
% %loop from low to high threshold
% T = 25;
% 
% %set a threshold
% %T = 40;
% 
% %Perform subtraction with threshold
% for y=1:1:hei
%     for x=1:1:wid
%         if abs(im2(y,x)-im1(y,x))>T
%             diff(y,x) = 1;
%         else
%             diff(y,x) = 0;
%         end
%     end
% end

%clean shape
diff = bwmorph(diff, 'close');
diff = bwmorph(diff, 'majority');
diff = bwmorph(diff, 'hbreak',4);
%diff = bwmorph(diff, 'thicken');

diff = imfilter(diff,fspecial('gaussian',10,18));

%imshow(diff);
%pause;

%Find board
%board = regionprops(diff, 'boundingbox', 'extrema');

%get edges of board
border = edge(diff, 'canny');

disp('showing');
imshow(border);
pause;

%smooth edges of board??

%make list of edge pixels
list = regionprops(border,'pixellist')

list.PixelList

%get ordered list of border pixels, clockwise
olist = sortEdges2(border,list.PixelList);

%prepare a short list of corner candidates
cand = [];

%locate board corners using sharpness metric:


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
    if (real(theta) < (130*(pi/180))) && (real(theta) > (50*(pi/180)))

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
    if (real(theta) < (130*(pi/180))) && (real(theta) > (50*(pi/180)))

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
    if (real(theta) < (130*(pi/180))) && (real(theta) > (50*(pi/180)))

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
%pause;

no = size(cand);

bins = [];

avgs = [];

nums = [0 0 0 0];

%IN PROGRESS - narrow corner clusters to one point per cluster
for e = 1:1:no(1)

    h = 1;
    while h < 5

        %test
        %num = nums;
        %end

        z = size(bins);

        if z(1) >= h

            can(1:3) = cand(e,:);
            %binned(1:3) = bins(h,1,1:3)

            %magical number 10
            %if the candidate is close to bin h's average, enter it
            if(sqrt(sum((can(1,1:2) - avgs(h,1:2)).^2)) < 10)
                %it fits in the h-th bin

%                 tmp(1:nums(h),1:3) = bins(h,1:nums(h),1:3)
%                 tmp = [tmp; cand(e,1:3)]
%                 bins(h,1:nums(h)+1,1:3) = tmp(1:nums(h)+1),1:3)

                %clear state1;
                %state1(1:nums(h),1:3) = bins(h,1:nums(h),1:3)
                %bins(h,:,:) = bins(h,1:nums(h),1:3);

                clear temp;
                temp(1:nums(h),1:3) = bins(h,1:nums(h),1:3);
                temp = [temp; cand(e,1:3)];
                bins(h,1:nums(h)+1,1:3) = temp(1:nums(h)+1,1:3);

                %clear state2;
                %state2(1:nums(h)+1,1:3) = bins(h,1:nums(h)+1,1:3)

                %fprintf('value %d %d %d, bin %d\n',cand(e,1:3),h);

                avgs(h,1:2) = avgs(h,1:2)*(nums(h)/(nums(h)+1)) + (1/(nums(h)+1))*cand(e,1:2);

                nums(h) = nums(h) + 1;

                h = 5;

            end
            %otherwise, go to the next bin

        else

            %bin h does not have entries
            %disp('making bin');

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
            h = 5;

        end

        h = h + 1;

        %z = size(bins);

    end

end

%avgs contains average pixel location for each corner cluster
%bins contains the groups of clusters

c1(1:nums(1),1:3) = bins(1,1:nums(1),1:3);
c2(1:nums(2),1:3) = bins(2,1:nums(2),1:3);
c3(1:nums(3),1:3) = bins(3,1:nums(3),1:3);
c4(1:nums(4),1:3) = bins(4,1:nums(4),1:3);

av1(1,1:2) = c1(find(c1(:,3) == min(c1(:,3))),1:2);
av2(1,1:2) = c2(find(c2(:,3) == min(c2(:,3))),1:2);
av3(1,1:2) = c3(find(c3(:,3) == min(c3(:,3))),1:2);
av4(1,1:2) = c4(find(c4(:,3) == min(c4(:,3))),1:2);

corners = [av1;av2;av3;av4]

imshow(border);
hold on
plot(corners(1,1),corners(1,2),'b*');
plot(corners(2,1),corners(2,2),'b*');
plot(corners(3,1),corners(3,2),'b*');
plot(corners(4,1),corners(4,2),'b*');
hold off
disp('Corner pixels have been found. Press ENTER.');
%pause;

%TODO - now that we have the corners of the board, we can determine the
%regions corresponding to each individual key

%array of (m,b) pairs for line definitions
lines = [];

%TODO - identify 'horizontal' lines (top and bottom of board)
temp = [];


%sort points left to right (or by increasing x)
order = sort(corners(:,1));
ord(1,1:2) = corners(find(corners(:,1) == order(1)),1:2);
ord(2,1:2) = corners(find(corners(:,1) == order(2)),1:2);
ord(3,1:2) = corners(find(corners(:,1) == order(3)),1:2);
ord(4,1:2) = corners(find(corners(:,1) == order(4)),1:2);

%calculate slope for each pair
%I put minus signs before the y's so that the slope would mach that shown
%on the screen (images use increasing y going down, vs cartesian method)
temp = [temp; ((-ord(2,2))-(-ord(1,2)))/(ord(2,1)-ord(1,1))];
temp = [temp; ((-ord(3,2))-(-ord(2,2)))/(ord(3,1)-ord(2,1))];
temp = [temp; ((-ord(4,2))-(-ord(1,2)))/(ord(4,1)-ord(1,1))];
temp = [temp; ((-ord(4,2))-(-ord(3,2)))/(ord(4,1)-ord(3,1))]

%TODO - sort by least slope. The two least are the front and back of the board.

%sort points top to bottom (or by increasing +y)
order2 = sort(corners(:,2));
ord2(1,1:2) = corners(find(corners(:,2) == order2(1)),1:2);
ord2(2,1:2) = corners(find(corners(:,2) == order2(2)),1:2);
ord2(3,1:2) = corners(find(corners(:,2) == order2(3)),1:2);
ord2(4,1:2) = corners(find(corners(:,2) == order2(4)),1:2);
%find two most positive y values


%calculate y-intercept
b1 = -ord(1,2) - temp(1)*ord(1,1);
b2 = -ord(2,2) - temp(2)*ord(2,1);
b3 = -ord(1,2) - temp(3)*ord(1,1);
b4 = -ord(3,2) - temp(4)*ord(3,1);

%format bank
lines = [temp(1), b1; temp(2),b2; temp(3),b3; temp(4),b4]

temp = [];
b = [];
keyPointsTop = [];
keyPointsBottom = [];

for j=1:6
    keyPointsTop = [keyPointsTop; ord(2,:)+j*(ord(3,:)-ord(2,:))/7];
    keyPointsBottom = [keyPointsBottom; ord(1,:)+j*(ord(4, :)-ord(1,:))/7];
    temp = [temp; ((-keyPointsTop(j,2)-(-keyPointsBottom(j,2)))/(keyPointsTop(j,1))-keyPointsBottom(j,1))];
    b = [b; -keyPointsTop(j,2)-temp(j)*keyPointsBottom(j,1)];
end

%format bank
keyLines = [temp(1), b(1); temp(2),b(2); temp(3),b(3); temp(4),b(4); temp(5),b(5); temp(6),b(6)];

%TODO - write equation for each verticle line

%sample output:
%lines = [-3 100; -3 350; -80 1280; -76 1100];

%TODO - let BOARD have the bounding coordinates for the keys
%keys = board;

keys = lines;

end

