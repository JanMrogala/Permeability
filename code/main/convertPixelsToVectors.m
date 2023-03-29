#{
finds pixels specified by color in an image and returns an array
of vectors describing those pixels.

INPUT:
  matrix image [1,2;3,4;...]
  vector targetColor [r;g;b]

OUTPUT:
  array ret {[1,0],[0,1],...}
#}

function ret = convertPixelsToVectors(image, targetColor)
  # Find the pixels that match the target color
  match = all(image == targetColor, 3);

  # Get the coordinates of the matching pixels
  [y, x] = find(match);

  # Combine the coordinates into an array of vectors
  ret = [x, y];
endfunction
