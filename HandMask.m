function [] = HandMask(bg, u, path)
global img chan_diff chan_diff_mask filtered;

% Original Image
fprintf('Path: %s\n', path);
img = double( imread(path) );
subplot(3,2,1);
imshow(uint8(img));

% Take Color Channel Differences of Original Images
chan_diff = (abs(ChannelDifferences(img) - ChannelDifferences(bg)) * 0.1 ).^3;
% Clean it up
filtered = medfilt2(chan_diff);
chan_diff = imfilter(chan_diff, fspecial('gaussian', 5, 3), 'replicate');
chan_diff = imfilter(chan_diff, fspecial('unsharp'), 'replicate');
chan_diff = (chan_diff ./ (max(max(chan_diff))));
subplot(3,2,2);
imshow(uint8(255 * chan_diff));

% Take Laplacian of Gaussian of the original images to find edges
logImg = medfilt2(rgb2gray(imfilter(img,fspecial('log',10,2),'replicate')), [8,8]);
logBG =  medfilt2(rgb2gray(imfilter(bg, fspecial('log',15,3),'replicate')), [8,8]);
logBG = imfilter(logBG, fspecial('gaussian', 8, 3), 'replicate');
% Filter the filter
filtered = logImg - (logBG > 0.3);
filtered = filtered .* (filtered > 0);
filtered = medfilt2(filtered, [8 8]);

% Show the LOG Filter
subplot(3,2,3);
imshow(filtered);

% Combine the Channel Difference and the LOG Filter
chan_diff = SubWithMin(chan_diff + filtered, 0, 3);

subplot(3,2,4);
imshow(chan_diff);

% Create a binary mask from the channel differences and filter
subplot(3,2,5);
chan_diff_mask = chan_diff > 0.06;
chan_diff_mask = bwmorph(chan_diff_mask, 'dilate');
chan_diff_mask = bwmorph(chan_diff_mask, 'close',Inf);
[labeled, num] = bwlabel(chan_diff_mask, 8);
chan_diff_mask = bwareaopen(labeled, 1000);
imshow(chan_diff_mask);

% Mask Overlay on the faint Image
subplot(3,2,6);
imshow(uint8(ImageMaskShadow(img, 0.10, chan_diff_mask)));
