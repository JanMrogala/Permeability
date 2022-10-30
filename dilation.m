#{

the morphological operation dilation expands every pixel
with the target color by the structure element.

INPUT:
  matrix image [1,2;3,4;...]
  array structuringElement {[1,0],[0,1],...}
  vector targetColor [r;g;b]

OUTPUT:
  matrix ret [1,2;3,4;...]

#}

function ret = dilation(image, structuringElement, targetColor)

  dilatedVectors = {};
  xLimit = size(image)(1,2);
  yLimit = size(image)(1,1);

  imgVectors = convertPixelsToVectors(image, targetColor);

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
    image(y,x,:) = targetColor;

  endfor

  ret = image;

endfunction
