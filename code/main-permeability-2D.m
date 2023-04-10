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
plotX = 3;
plotY = 3;

% Create a structuring element
se = [0 0 0;
      0 1 1;
      0 1 1];

seOpp = [1 1 0;
         1 1 0;
         0 0 0];

dilationCounter = 0;
img = im2double(img);

% Repeat until not permeable anymore
do

  permeable = false;

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
  title(sprintf('Dilations: %d', dilationCounter));

  % Check if right border side contains filled pixels
  permeable = any(filledImg(:, end) == fillColor);

  %% Dilatation of image
  if(permeable)
    img = ~img;

    if(mod(dilationCounter,2) == 0)
      img = imdilate(img, se);
    else
      img = imdilate(img, seOpp);
    endif

    img = ~img;
    img = im2double(img);

    filledImg = img;
    dilationCounter++;
  endif

until(!permeable)

disp("permeability-2D");
disp(sprintf('Size of critical passage: %d', dilationCounter));

% Show profiler information
data = profile ("info");
profshow (data, 10);
total_time = sum([data.FunctionTable.TotalTime])
