clear all; close all;

imgName = "../resources/testImg/sample.png";

img = imread(imgName);
img = uint8(img);
##img(img == 1) = 0;
##img(img == 0) = 1;
img = 1 - img;
img = img*255;

imshow((img));
##img = uint8(random_bw_image(0.3,10,10));

marker = randi([10, 240], 3, 1);
fillColor = [255;0;0];
boundaryColor = [0;0;0];




counter = 1;
myAreasStart = struct();
myAreasEnd = struct();

%% 1. group border pixels by region connectivity

for i = 1:rows(img)

    reshaped = reshape(img(i,1,:), [], 1);
    if(!isequal(reshaped, boundaryColor) && !isequal(reshaped, fillColor))
      img = lineSeedFill2D(1,i,fillColor,boundaryColor,img);
      myAreasStart = findNewFilledBorderPixelsStart(img,myAreasStart,fillColor,counter);
      myAreasEnd = findNewFilledBorderPixelsEnd(img,myAreasEnd,fillColor,counter);
      counter += 1;
    endif
end

%% mark different areas

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

##imshow((img));
