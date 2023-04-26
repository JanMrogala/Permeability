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
        dilatedImg = imdilate(dilatedImg, seOpp);
      else
        dilatedImg = imdilate(dilatedImg, se);
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
        dilatedImg = imdilate(dilatedImg, seOpp);
      else
        dilatedImg = imdilate(dilatedImg, se);
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
fillColor = 0.01;
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
          fillColor = fillColor + 0.01;
          numberOfPassages++;
        endif
    endif
endfor

disp(sprintf('Number of permeable passages with same size: %d', numberOfPassages));
disp("-------------------------------------------------");

imToShow = zeros(size(filledImg,1),size(filledImg,2),3);
imToShow(:,:,1) = filledImg;
imToShow(:,:,2) = filledImg;
imToShow(:,:,3) = filledImg;

colors = { [1 0 0],
           [0 1 0],
           [0 0 1],
           [1 1 0],
           [0 1 1],
           [1 0 1],
           [0.5 0 0],
           [0 0.5 0],
           [0 0.5 0.5],
           [0.5 0.5 0] };

colorIdx = 1;
for i = 0.01:0.01:fillColor

    imToShow_r = imToShow(:,:,1);
    imToShow_r(imToShow_r == i) = colors{colorIdx}(1);
    imToShow(:,:,1) = imToShow_r;

    imToShow_g = imToShow(:,:,2);
    imToShow_g(imToShow_g == i) = colors{colorIdx}(2);
    imToShow(:,:,2) = imToShow_g;

    imToShow_b = imToShow(:,:,3);
    imToShow_b(imToShow_b == i) = colors{colorIdx}(3);
    imToShow(:,:,3) = imToShow_b;

    colorIdx++;

endfor

imToShow = imToShow*255;

% Plot all permeable passages
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(imToShow);
  title(sprintf('Permeable passages: %d', numberOfPassages));

img1 = imToShow; % example 3D matrix representing an image
img2 = zeros(size(img1)); % create new 3D matrix of the same size
img2(:,:,1) = img;
img2(:,:,2) = img;
img2(:,:,3) = img;
img2 = img2 * 255;

% create a logical matrix that is true where img1 is not black or white
notBlackOrWhite = ~(img1(:,:,1) == 0 & img1(:,:,2) == 0 & img1(:,:,3) == 0) & ...
                  ~(img1(:,:,1) == 255 & img1(:,:,2) == 255 & img1(:,:,3) == 255);

% transfer colors that are not black or white from img1 to img2
img2(repmat(notBlackOrWhite, [1, 1, 3])) = img1(repmat(notBlackOrWhite, [1, 1, 3]));


% Plot all permeable passages center lines
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(img2);
  title("Center passage in original");

% Show profiler information
data = profile ("info");
profshow (data, 10);
total_time = sum([data.FunctionTable.TotalTime])
