function img = random_bw_image(white_percentage,width,height)
  threshold = round(white_percentage * 10);
  img = repmat(randi([0, 10], width, height) > threshold, [1, 1, 3]) * 255;
endfunction
