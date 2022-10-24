#{

the morphological operation dilation expands
image boundary pixels by the structure element.

INPUT:
  matrix image [1,2;3,4;...]
  array structuringElement {[1,0],[0,1],...}
  vector boundaryColor [r;g;b]

OUTPUT:
  matrix ret [1,2;3,4;...]

#}

function ret = dilation(image, structuringElement, boundaryColor)

  dilatedVectors = {};
  xLimit = size(image)(1,2);
  yLimit = size(image)(1,1);

  imgVectors = convertSolidPixelsToVectors(image, boundaryColor);

  for i = 1:columns(structuringElement)
    for n = 1:columns(imgVectors)

      v = structuringElement{i} + imgVectors{n};
      if(v(1,1) <= 0 || v(1,1) > xLimit || v(1,2) <= 0 || v(1,2) > yLimit)
        continue
      else
        dilatedVectors(end+1) = v;
      endif

    endfor
  endfor

  for i = 1:columns(dilatedVectors)

    x = dilatedVectors{i}(1,1);
    y = dilatedVectors{i}(1,2);
    image(y,x,:) = boundaryColor;

  endfor

  ret = image;

endfunction
