function [img] = ImageMaskShadow(orig, threshold, mask)

img = zeros(size(orig));

for i = 1:3
  img(:,:,i) = orig(:,:,i) .* (threshold + double(mask));
end
