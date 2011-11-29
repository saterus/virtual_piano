function [img] = ChannelDifferences(orig)

img = zeros(size(orig(:,:,1)));

for i = 1:3
  % sum of differences = (red - green) + (red - blue) + (green - blue)
  img(:,:) = abs(orig(:,:,1) - orig(:,:,2)) +...
             abs(orig(:,:,1) - orig(:,:,3)) +...
             abs(orig(:,:,2) - orig(:,:,3));
end
