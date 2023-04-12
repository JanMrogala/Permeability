clear all; close all; profile off; profile clear; profile on;

pkg load image;

% Load slices
image_matrix = zeros(3,3,3);
for i = 1:3
    % Load the image
    imgName = sprintf('../resources/testSlices/diagonal/slice_%d.png', i-1);
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
    image_matrix(:,:,i) = img;
end

fillColor = 0.5;
dilationCounter = 0;

% Create a structuring element
se = zeros(3,3,3);
se(:,:,1) = [0 0 0; 0 0 0; 0 0 0];
se(:,:,2) = [0 0 0; 0 1 1; 0 1 1];
se(:,:,3) = [0 0 0; 0 1 1; 0 1 1];

seOpp = zeros(3,3,3);
seOpp(:,:,1) = [1 1 0; 1 1 0; 0 0 0];
seOpp(:,:,2) = [1 1 0; 1 1 0; 0 0 0];
seOpp(:,:,3) = [0 0 0; 0 0 0; 0 0 0];


image_matrix = double(image_matrix);
filled_matrix = image_matrix;

num_images = 0;
plotX = 4;
plotY = 6;

dilations = 0;

do

  permeable = false;

  % Rough dilation of image
  dilatedMatrix = image_matrix;
  dilatedMatrix = ~dilatedMatrix;

  dilationsTemp = dilations;
  dilations = uint8(max([size(filled_matrix, 1) size(filled_matrix, 2) size(filled_matrix, 3)])/(2^dilationCounter));

  for i = 1:dilations

      if(mod(i,2) == 0)
        dilatedMatrix = imdilate(dilatedMatrix, se);
      else
        dilatedMatrix = imdilate(dilatedMatrix, seOpp);
      endif

  endfor

  dilationCounter++;
  dilatedMatrix = ~dilatedMatrix;
  dilatedMatrix = im2double(dilatedMatrix);
  filled_matrix = dilatedMatrix;

  % Fill image starting from left face
  if any(any(filled_matrix(:, 1, :) == 1))
      for i = 1:size(filled_matrix,1)
          for j = 1:size(filled_matrix,3)
              if(filled_matrix(i,1,j) == 1)
                  filled_matrix = lineSeedFill3D(i,1,j,fillColor,filled_matrix);
              endif
          end
      end
  endif

  % display faces
  if(true)

    matrixToShow = permute(filled_matrix(:, 1, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title(sprintf('|| (F1) Rough dilations: %d', dilations));

    matrixToShow = permute(filled_matrix(:, end, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title(sprintf('(F2) Rough dilations: %d ||', dilations));

  endif

  % Check if right face side contains filled pixels
  permeable = any(any(filled_matrix(:, end, :) == fillColor));

  % Write filled dilated slices to disk
##  if(dilationCounter == 7)
##    for i = 1:size(filled_matrix,3)
##        imwrite(filled_matrix(:,:,i), sprintf('slices/slice_%d.png', i));
##    end
##  endif

until(permeable)


% Return to previous dilation amount value before permeability was found
dilations = dilationsTemp;


% Repeat until permeability is found
do

  permeable = false;

  % Fine dilation of image
  dilatedMatrix = image_matrix;
  dilatedMatrix = ~dilatedMatrix;

  dilations--;

  for i = 1:dilations

      if(mod(i,2) == 0)
        dilatedMatrix = imdilate(dilatedMatrix, se);
      else
        dilatedMatrix = imdilate(dilatedMatrix, seOpp);
      endif

  endfor

  dilatedMatrix = ~dilatedMatrix;
  dilatedMatrix = im2double(dilatedMatrix);
  filled_matrix = dilatedMatrix;

  % Fill image starting from left face
  if any(any(filled_matrix(:, 1, :) == 1))
      for i = 1:size(filled_matrix,1)
          for j = 1:size(filled_matrix,3)
              if(filled_matrix(i,1,j) == 1)
                  filled_matrix = lineSeedFill3D(i,1,j,fillColor,filled_matrix);
              endif
          end
      end
  endif

  % display faces
  if(true)

    matrixToShow = permute(filled_matrix(:, 1, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title(sprintf('|| (F1) Fine dilations: %d', dilations));

    matrixToShow = permute(filled_matrix(:, end, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title(sprintf('(F2) Fine dilations: %d ||', dilations));

  endif

  % Check if right border side contains filled pixels
  permeable = any(any(filled_matrix(:, end, :) == fillColor));

until(permeable)

finalDilations = dilations + 1;

disp("backwards-permeability-3D");
disp(sprintf('Size of critical passage: %d', finalDilations));

% Show profiler information
data = profile ("info");
profshow (data, 10);
total_time = sum([data.FunctionTable.TotalTime])
