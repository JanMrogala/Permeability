

function ret = narrowestPoint2D(image, fillColor, boundaryColor, seedPos)

  structuringElement = {[0,0],[1,0],[-1,0],[0,1],[0,-1]};
  structuringElementY = {[0,0],[0,1]};
  structuringElementOppY = {[0,0],[0,-1]};
  structuringElementX = {[0,0],[1,0]};
  structuringElementOppX = {[0,0],[-1,0]};
  narrowestPointsY = {};
  narrowestPointsX = {};

  #y direction --------------
  temp = image;
  dilatedImage = dilation(temp, structuringElementY, boundaryColor, seedPos);

  for y = 1:(size(image)(1,1)-1)

    filled = lineSeedFill2D(seedPos(1,1), seedPos(1,2), fillColor, boundaryColor, dilatedImage);
    imwrite(double(dilatedImage), ["../output/" "dil" num2str(y) ".png"]);

    dilatedFilledArea = dilation(filled, structuringElementOppY, fillColor, seedPos);
    dilatedFilledArea2 = dilation(filled, structuringElement, fillColor, seedPos);

    vec1 = convertPixelsToVectors(dilatedFilledArea, fillColor);
    vec2 = convertPixelsToVectors(dilatedFilledArea2, fillColor);
    differenceVectors = difference(vec1, vec2)
    image2 = image;

    for i = 1:columns(differenceVectors)
      if(temp(differenceVectors{i}(1,2),differenceVectors{i}(1,1),:) != boundaryColor)
        narrowestPointsY(end+1) = differenceVectors{i};
      endif
    endfor

    if(size(narrowestPointsY)(1,1) > 0)
      break
    endif
    temp = dilatedImage;
    dilatedImage = dilation(dilatedImage, structuringElementY, boundaryColor, seedPos);

  endfor

  #x direction --------------
    temp = image;
    dilatedImage = dilation(temp, structuringElementX, boundaryColor, seedPos);

    for x = 1:(size(image)(1,2)-1)

      filled = lineSeedFill2D(seedPos(1,1), seedPos(1,2), fillColor, boundaryColor, dilatedImage);

      dilatedFilledArea = dilation(filled, structuringElementOppX, fillColor, seedPos);
      dilatedFilledArea2 = dilation(filled, structuringElement, fillColor, seedPos);

      vec1 = convertPixelsToVectors(dilatedFilledArea, fillColor);
      vec2 = convertPixelsToVectors(dilatedFilledArea2, fillColor);
      differenceVectors = difference(vec1, vec2)
      image2 = image;

      for i = 1:columns(differenceVectors)
        if(temp(differenceVectors{i}(1,2),differenceVectors{i}(1,1),:) != boundaryColor)
          narrowestPointsX(end+1) = differenceVectors{i};
        endif
      endfor

      if(size(narrowestPointsX)(1,1) > 0)
        break
      endif
      temp = dilatedImage;
      dilatedImage = dilation(dilatedImage, structuringElementX, boundaryColor, seedPos);

    endfor

ret = cat(2,narrowestPointsX, narrowestPointsY);

endfunction
