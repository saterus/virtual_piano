function [img] = NormBrightness(orig)

img = zeros(size(orig));

for i = 1:3
  img(:,:,i) = orig(:,:,i) ./ sum(orig, 3);
end
