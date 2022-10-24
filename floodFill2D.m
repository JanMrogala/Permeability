#{

creates a new image with the specified area
filled by the flood fill algorithm.

INPUT:
  integer x
  integer y
  vector fillColor [r;g;b]
  vector oldColor [r;g;b]
  string imgName "image.png"

OUTPUT:
  null

#}

function floodFill2D(x, y, fillColor, oldColor, imgName)

  image = uint8(imread(imgName));

	if (x > size(image)(1,2) || x <= 0 || y > size(image)(1,1) || y <= 0)
		return;
  endif

	if (image(y,x,:) == oldColor)
    image(y,x,:) = fillColor;
    imwrite(image, imgName);
		floodFill2D(x + 1, y, fillColor, oldColor, imgName);
    floodFill2D(x - 1, y, fillColor, oldColor, imgName);
	  floodFill2D(x, y + 1, fillColor, oldColor, imgName);
		floodFill2D(x, y - 1, fillColor, oldColor, imgName);
  endif

endfunction

