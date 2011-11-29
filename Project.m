

disp('The Virtual Keyboard - Burkart, Chima, Daines');

%This is the main program which will make calls to helper functions
%and execute all code for the Computer Vision final project.

%get raw bg without piano keyboard
bg = imread('test_images/SampleDataGrey1/bg4.jpg');
%bg = imread('Keith2.jpg');
%imshow(bg);
%pause;

%get bg image with piano keyboard
bbg = imread('test_images/SampleDataGrey1/kb4.jpg');
%bbg = imread('Keith1.jpg');
%imshow(bbg);
%pause;

ScanSoundFiles;
% addpath('iSight', 'StopLoop');
% height = 640;
% width = 480;
% FS = stoploop({'Push to stop camera.'}) ;
% iSight=iSightInit([height,width]);
% f = figure('Name', 'Scene', 'NumberTitle','off');
% 
% while(~FS.Stop())
%     bg = iSightCapture(iSight);
%     imagesc(bg);
% end
% 
% FS = stoploop({'Push to stop camera.'}) ;
% 
% while(~FS.Stop())
%     bbg = iSightCapture(iSight);
%     imagesc(bbg);
% end
% 
% FS.Clear();
% iSightClose(iSight);
% pause;

%locate individual keys:
%(slope, y-intercept forms of bounding lines)
global data keyLines;
[data, keyLines, boardMask] = GetBoard(bg, bbg);

% FS = stoploop({'Push to stop testing loop.'}) ;
% while(~FS.Stop())

%NOTE*** - the list will be m,b pairs. The first pair will represent the top
%of the keyboard, and the second pair will represent the bottom. The
%subsequent (eight) pairs will distinguish the keys.

%disp('Bounding lines are these:');
%data

%TODO - observe video/series of input images and analyze hand signals
%Respond by giving us the (x,y) coordinant pairs for the fingertips
%as they touch the keyboard

global img chan_diff chan_diff_mask;
% bg2 = double( imread('test_images/noHands.jpg') );
% bg2 = bg2(:,1:435,:);
% u = mean(mean(mean(bg2)));
% images = {'test_images/FingersDown.jpg'
%           'test_images/FingersUp.jpg'
%           'test_images/PinkyDown.jpg'
%           'test_images/PointerDown.jpg'
%           'test_images/RingDown.jpg'
%           'test_images/ThreeBlack.jpg'
%           'test_images/ThreeWhite.jpg'
%           'test_images/ThumbPinkyDown.jpg'
%           'test_images/TwoDown.jpg'
%           'test_images/TwoHands.jpg'};
% for i = 1:length(images)
%   HandMask(bg2, u, images{i});
%   pause;
% end



% iSight=iSightInit([height,width]);
% GS = stoploop({'Push to take hand photo.'}) ;
% 
% 
% while(~GS.Stop())
%     hand = iSightCapture(iSight);
%     imagesc(hand);
% end
% iSightClose(iSight);

HandMask(bbg, 'test_images/SampleDataGrey1/hand34.jpg');
dims = size(bbg);
barmask = [zeros(100,dims(2));ones(dims(1)-100,dims(2))];
chan_diff_mask = chan_diff_mask & barmask;
figure;imshow(chan_diff_mask);pause;
finger_points = low5(chan_diff_mask);

finger_points = [finger_points(1,1) finger_points(1,2) ; finger_points(2,1) finger_points(2,2)];

%points = [256,256; 300, 330; 430, 330];
keys = keyFromPoints(finger_points)

PlayNotes(keys);
%GS.Clear();

%end

%TODO - match the finger tip position with a key by comparing the point to
%the slope-intercept line equation

%TODO - make beautiful sounds

%TODO - report by Thursday classtime.

clear
clc
clear('java');
