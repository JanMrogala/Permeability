clear all; close all;

imgName = "../resources/testImg/10x10.png";

function img = random_bw_image(white_percentage,width,height)
  threshold = round(white_percentage * 10);
  img = repmat(randi([0, 10], width, height) > threshold, [1, 1, 3]) * 255;
endfunction

img = imread(imgName);
img = uint8(img);
img = uint8(random_bw_image(0.3,10,10))

marker = randi([10, 240], 3, 1);
fillColor = [255;0;0];
boundaryColor = [0;0;0];


%% 1. group border pixels by region connectivity

counter = 1;
myAreasStart = struct();
myAreasEnd = struct();

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


for i = 1:rows(img)

    reshaped = reshape(img(i,1,:), [], 1);
    if(!isequal(reshaped, boundaryColor) && !isequal(reshaped, fillColor))
      img = lineSeedFill2D(1,i,fillColor,boundaryColor,img);

      myAreasStart = findNewFilledBorderPixelsStart(img,myAreasStart,fillColor,counter);
      myAreasEnd = findNewFilledBorderPixelsEnd(img,myAreasEnd,fillColor,counter);
      counter += 1;
    endif
end

fields = fieldnames(myAreasStart);
for i = 1:numel(fields)
    pixels = myAreasStart.(fields{i});
    for j = 1:numel(pixels)
        pixel = pixels{j};
        img(pixel(2),pixel(1),:) = marker;
    endfor
    pixels = myAreasEnd.(fields{i});
    for j = 1:numel(pixels)
        pixel = pixels{j};
        img(pixel(2),pixel(1),:) = marker;
    endfor
    marker = randi([10, 240], 3, 1);
endfor
img
imshow((img));
