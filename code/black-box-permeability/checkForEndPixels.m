function ret = checkForEndPixels(myAreasEnd, filledImg, fillColor)

  ret = false;

  fields = fieldnames(myAreasEnd);

  for i = 1:numel(fields)

      pixels = myAreasEnd.(fields{i});
      for j = 1:numel(pixels)
          pixel = pixels{j};
          reshaped = reshape(filledImg(pixel(2),pixel(1),:), [], 1);

          if(isequal(reshaped,fillColor))
            ret = true;
            return
          endif
      endfor
  endfor

endfunction
