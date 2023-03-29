function result = findNewFilledBorderPixelsStart(img, dict, fillColor, counter)

    pixels = {};

    for i = 1:rows(img)

      reshaped = reshape(img(i,1,:), [], 1);
      if(isequal(reshaped, fillColor) && !isPixelPresentInDict(1,i,dict))
        pixels{end+1} = [1 i];
      endif
    endfor
    result = setfield(dict, int2str(counter), pixels);
end
