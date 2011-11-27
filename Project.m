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
data = GetBoard(bg, bbg);
%NOTE*** - the list will be m,b pairs. The first pair will represent the top
%of the keyboard, and the second pair will represent the bottom. The
%subsequent (eight) pairs will distinguish the keys.

disp('Bounding lines are these:');
data

%TODO - observe video/series of input images and analyze hand signals
%Respond by giving us the x,y (or y,x) coordinant pairs for the fingertips
%as they touch the keyboard

%TODO - match the finger tip position with a key by comparing the point to
%the slope-intercept line equation

%TODO - make beautiful sounds

%TODO - report by Thursday classtime.

disp('Tad-Da!');