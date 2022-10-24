#{

finds solid pixels in an image and returns an array of vectors
describing those pixels.

INPUT:
  matrix image [1,2;3,4;...]
  vector boundaryColor [r;g;b]

OUTPUT:
  array ret {[1,0],[0,1],...}

#}

function ret = convertSolidPixelsToVectors(image, boundaryColor)

  ret = {};

  for y = 1:size(image)(1,1)
    for x = 1:size(image)(1,2)

      if (image(y,x,:) == boundaryColor)
        ret(end+1) = [x,y];
      endif

    endfor
  endfor

endfunction
