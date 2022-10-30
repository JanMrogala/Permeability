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

  ret = {};

  for y = 1:size(image)(1,1)
    for x = 1:size(image)(1,2)

      if (image(y,x,1) == targetColor(1,1) &&
          image(y,x,2) == targetColor(2,1) &&
          image(y,x,3) == targetColor(3,1))
        ret(end+1) = [x,y];
      endif

    endfor
  endfor

endfunction
