function [img] = SubToMin(img, min, v)

  img = (img >= min) .* img;
