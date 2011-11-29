function [ v ] = keyFromPoints( points )
% KEYFROMPOINTS Takes in a vector of (x,y) coordinates representing the
% position of all fingers in "tap" position, and returns a vector
% representing numbers that correspond to the piano keys that the fingers
% are pressing
global data keyLines;

v = [];
hold on;
for i = 1:size(points, 1)
    
    points1 = points(i,:);
    points1= [points1(1), -points1(2)];
    plot(points(i,1),points(i,2),'g*');
    
    if(((data(2,1)*points1(1) + data(2,2)) > points1(2)) && ((data(3,1)*points1(1) + data(3,2)) < points1(2)) && (((points1(2)-data(1,2))/data(1,1)) < points1(1)) && (((points1(2)-data(3,2))/data(3,1)) > points1(1)))
        sprintf('Point (%d, %d) inside bounds\n',points1(1), points1(2))
        % coordinates should be inside the piano boundary
        if((((points1(2)-keyLines(1,2))/keyLines(1,1)) > points1(1)))
            v = [v 1];
            sprintf('note: C\n');
        elseif((((points1(2)-keyLines(2,2))/keyLines(2,1)) > points1(1)))
            v = [v 2];
            sprintf('note: D\n');
        elseif((((points1(2)-keyLines(3,2))/keyLines(3,1)) > points1(1)))
            v = [v 3];
            sprintf('note: E\n');
        elseif((((points1(2)-keyLines(4,2))/keyLines(4,1)) > points1(1)))
            v = [v 4];
            sprintf('note: F\n');
        elseif((((points1(2)-keyLines(5,2))/keyLines(5,1)) > points1(1)))
            v = [v 5];
            sprintf('note: G\n');
        elseif((((points1(2)-keyLines(6,2))/keyLines(6,1)) > points1(1)))
            v = [v 6];
            sprintf('note: A\n');
        else
            v = [v 7];
            sprintf('note: B\n');
        end
        
    else
        sprintf('Point (%d, %d) out of bounds\n',points1(1,1), points1(1,2))
    end

end

hold off;