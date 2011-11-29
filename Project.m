clear
clc

disp('The Virtual Keyboard - Burkart, Chima, Daines');

%This is the main program which will make calls to helper functions
%and execute all code for the Computer Vision final project.

%get raw bg without piano keyboard
bg = imread('test_images/bg.jpg');
%imshow(bg);
%pause;

%get bg image with piano keyboard
bbg = imread('test_images/bbg.jpg');
%imshow(bbg);
%pause;

%locate individual keys:
%(slope, y-intercept forms of bounding lines)
%data = GetBoard(bg, bbg);
%NOTE*** - the list will be m,b pairs. The first pair will represent the top
%of the keyboard, and the second pair will represent the bottom. The
%subsequent (eight) pairs will distinguish the keys.

%disp('Bounding lines are these:');
%data

%TODO - observe video/series of input images and analyze hand signals
%Respond by giving us the (x,y) coordinant pairs for the fingertips
%as they touch the keyboard
global img chan_diff chan_diff_mask;
bg = double( imread('test_images/noHands.jpg') );
bg = bg(:,1:435,:);
u = mean(mean(mean(bg)));
images = {'test_images/FingersDown.jpg'
          'test_images/FingersUp.jpg'
          'test_images/PinkyDown.jpg'
          'test_images/PointerDown.jpg'
          'test_images/RingDown.jpg'
          'test_images/ThreeBlack.jpg'
          'test_images/ThreeWhite.jpg'
          'test_images/ThumbPinkyDown.jpg'
          'test_images/TwoDown.jpg'
          'test_images/TwoHands.jpg'};
for i = 1:length(images)
  HandMask(bg, u, images{i});
  pause;
end

%TODO - match the finger tip position with a key by comparing the point to
%the slope-intercept line equation

%TODO - make beautiful sounds

%TODO - report by Thursday classtime.

disp('Ta-Da!');
