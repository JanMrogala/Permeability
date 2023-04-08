clear all; close all; profile clear; profile on;

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

dilationCounter = 0;
img = im2double(img);

do

  permeable = false;

  % Fill image starting from left border
  for i = 1:size(filledImg, 1)

      if(!(filledImg(i,1) == 0 || filledImg(i,1) == fillColor))
        filledImg = lineSeedFill2D(1,i,fillColor,filledImg);
      endif

  endfor

  % Plot current image
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(filledImg);
  title(sprintf('Step %d', num_images));

  % Check if right border side contains filled pixels
  for i = 1:size(filledImg, 1)

      if(filledImg(i,size(filledImg, 2)) == fillColor)
        permeable = true;
        break
      endif

endfor

  %% Dilatation of image
  if(permeable)
    img = ~img;

    img = imdilate(img, se);

    img = ~img;
    img = im2double(img);

    filledImg = img;
    dilationCounter += 1;
  endif

until(!permeable)

disp(sprintf('Size of critical passage: %d', dilationCounter));

% Show profiler information
profile off;
data = profile ("info");
profshow (data, 10);
