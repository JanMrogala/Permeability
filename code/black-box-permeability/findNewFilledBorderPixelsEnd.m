function result = findNewFilledBorderPixelsEnd(img, dict, fillColor, counter)

    pixels = {};

    for i = 1:rows(img)

      reshaped = reshape(img(i,size(img)(2),:), [], 1);
      if(isequal(reshaped, fillColor) && !isPixelPresentInDict(size(img)(2),i,dict))
        pixels{end+1} = [size(img)(2) i];
      endif
    endfor
    result = setfield(dict, int2str(counter), pixels);
end
