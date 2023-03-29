function result = isPixelPresentInDict(x,y,dict)
    result = false;
    fields = fieldnames(dict);
    for i = 1:numel(fields)
        pixels = dict.(fields{i});
        for j = 1:numel(pixels)
            pixel = pixels{j};
            if pixel(1) == x && pixel(2) == y
                result = true;
                return;
            endif
        endfor
    endfor
end
