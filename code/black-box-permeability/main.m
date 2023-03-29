clear all; close all;

##imgName = "../resources/testImg/10x10.png";
##
##img = imread(imgName);
##img = uint8(img);
##img = uint8(random_bw_image(0.05,100,100));

imgName = "../resources/testImg/sample.png";
img = imread(imgName);
img = uint8(img);
img = 1 - img;
img = img*255;

marker = randi([10, 240], 3, 1);
fillColor = [255;0;0];
boundaryColor = [0;0;0];

counter = 1;
myAreasStart = struct();
myAreasEnd = struct();

%% 1. - 3. group start and end border pixels by region connectivity

filledImg = img;

for i = 1:rows(filledImg)

    reshaped = reshape(filledImg(i,1,:), [], 1);
    if(!isequal(reshaped, boundaryColor) && !isequal(reshaped, fillColor))
      filledImg = lineSeedFill2D(1,i,fillColor,boundaryColor,filledImg);
      myAreasStart = findNewFilledBorderPixelsStart(filledImg,myAreasStart,fillColor,counter);
      myAreasEnd = findNewFilledBorderPixelsEnd(filledImg,myAreasEnd,fillColor,counter);
      counter += 1;
    endif
end

num_images = 0;
plotX = 4;
plotY = 4;



se = {[0,0],[1,0],[0,1],[1,1]};

filledImg = img;

bool = false;

dilationCounter = 0;

do

  num_images++;

  subplot(plotX, plotY, num_images);
  imshow(double(img));
  title(sprintf('Image %d', num_images));

  fields = fieldnames(myAreasStart);
  for i = 1:numel(fields)
      pixels = myAreasStart.(fields{i});

      for j = 1:numel(pixels)
          pixel = pixels{j};
          reshaped = reshape(filledImg(pixel(2),pixel(1),:), [], 1);
          if(!isequal(reshaped, boundaryColor) && !isequal(reshaped, fillColor))
            filledImg = lineSeedFill2D(pixel(1),pixel(2),fillColor,boundaryColor,filledImg);

          endif
      endfor

  endfor

  num_images++;

  subplot(plotX, plotY, num_images);
  imshow(filledImg);
  title(sprintf('Image %d', num_images));

  bool = checkForEndPixels(myAreasEnd, filledImg, fillColor);
  if(bool)
    %% 4. dilatace hraničních pixelů
    img = dilation(img, se, boundaryColor);
    dilationCounter += 1;
    filledImg = img;
  endif

until(!bool)

disp(dilationCounter);

%% mark unique areas with different color

##fields = fieldnames(myAreasStart);
##for i = 1:numel(fields)
##    pixels = myAreasStart.(fields{i});
##    for j = 1:numel(pixels)
##        pixel = pixels{j};
##        filledImg(pixel(2),pixel(1),:) = marker;
##    endfor
##    pixels = myAreasEnd.(fields{i});
##    for j = 1:numel(pixels)
##        pixel = pixels{j};
##        filledImg(pixel(2),pixel(1),:) = marker;
##    endfor
##    marker = randi([10, 240], 3, 1);
##endfor
