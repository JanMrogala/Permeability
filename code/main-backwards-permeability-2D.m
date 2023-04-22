clear all; close all; profile off; profile clear; profile on;

% Load image library
pkg load image;

% Load the image
imgName = "../resources/testImg/sample.png";
img = imread(imgName);
img = im2double(img);

% Make image monochrome
sz = size(img);

if(length(sz) == 3)
  img = rgb2gray(img);
endif

if !all(all((img == 1) | (img == 0)))
    img = im2bw(img);
endif

% inverse the sample image
img = ~img;
img = im2double(img);

filledImg = img;
fillColor = 0.5;

num_images = 0;
plotX = 4;
plotY = 4;

% Create a structuring element
se = [0 0 0;
      0 1 1;
      0 1 1];

seOpp = [1 1 0;
         1 1 0;
         0 0 0];

dilationCounter = 0;
img = im2double(img);
dilations = 0;

% Repeat until permeability is found
do

  permeable = false;

  % Rough dilation of image
  dilatedImg = img;
  dilatedImg = ~dilatedImg;

  dilationsTemp = dilations;
  dilations = uint8(max(size(filledImg, 1), size(filledImg, 2))/(2^dilationCounter));

  for i = 1:dilations

      if(mod(i,2) == 0)
        dilatedImg = imdilate(dilatedImg, se);
      else
        dilatedImg = imdilate(dilatedImg, seOpp);
      endif

  endfor
  dilationCounter++;
  dilatedImg = ~dilatedImg;
  dilatedImg = im2double(dilatedImg);
  filledImg = dilatedImg;

  % Fill image starting from left border
  if any(filledImg(:, 1) == 1)
      for i = 1:size(filledImg, 1)
          if(filledImg(i,1) == 1)
              filledImg = lineSeedFill2D(i,1,fillColor,filledImg);

          endif
      endfor
  endif

  % Plot current image
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(filledImg);
  title(sprintf('Rough dilations: %d', dilations));

  % Check if right border side contains filled pixels
  permeable = any(filledImg(:, end) == fillColor);

until(permeable)


% Return to previous dilation amount value before permeability was found
dilations = dilationsTemp;


% Repeat until permeability is found
do

  permeable = false;

  % Fine dilation of image
  dilatedImg = img;
  dilatedImg = ~dilatedImg;

  dilations--;
  for i = 1:dilations

      if(mod(i,2) == 0)
        dilatedImg = imdilate(dilatedImg, se);
      else
        dilatedImg = imdilate(dilatedImg, seOpp);
      endif

  endfor

  dilatedImg = ~dilatedImg;
  dilatedImg = im2double(dilatedImg);
  filledImg = dilatedImg;

  % Fill image starting from left border
  for i = 1:size(filledImg, 1)

      if(filledImg(i,1) == 1)
        filledImg = lineSeedFill2D(i,1,fillColor,filledImg);
      endif

  endfor

  % Plot current image
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(filledImg);
  title(sprintf('Fine dilations: %d', dilations));

  % Check if right border side contains filled pixels
  permeable = any(filledImg(:, end) == fillColor);

until(permeable)

finalDilations = dilations + 1;

disp("backwards-permeability-2D");
disp(sprintf('Size of critical passage: %d', finalDilations));

# Show final dilated filled image with differing colors for every distinct area
numberOfPassages = 0;
fillColor = 0.3;
filledImg = dilatedImg;
temp = filledImg;

for i = 1:size(filledImg, 1)
    if(temp(i,1) == 1)
        temp = lineSeedFill2D(i,1,fillColor,dilatedImg);
        % Check if right border side contains filled pixels
        permeable = any(temp(:, end) == fillColor);
        if(permeable)
          transfer_idx = find(temp == fillColor);
          filledImg(transfer_idx) = temp(transfer_idx);
          fillColor = fillColor + 0.2;
          numberOfPassages++;
        endif
    endif
endfor

disp(sprintf('Number of permeable passages with same size: %d', numberOfPassages));

% Plot current image
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(filledImg);
  title(sprintf('Permeable passages: %d', numberOfPassages));

transfer_idx = find(filledImg != 0);
img(transfer_idx) = filledImg(transfer_idx);

% Plot current image
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(img);
  title("Center passage in original");

% Show profiler information
data = profile ("info");
profshow (data, 10);
total_time = sum([data.FunctionTable.TotalTime])
