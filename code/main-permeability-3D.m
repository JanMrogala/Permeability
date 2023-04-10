clear all; close all; profile off; profile clear; profile on;

pkg load image;

% Load slices
image_matrix = zeros(100,100,100);
for i = 1:100
    image_matrix(:,:,i) = ~imread(sprintf('../resources/converted100x100/slice%d.tif', i-1));
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
plotY = 4;

% Repeat until not permeable anymore
do

  permeable = false;

  % Fill image starting from left face
  for i = 1:size(filled_matrix,1)
      for j = 1:size(filled_matrix,3)
          if(filled_matrix(i,1,j) == 1)
            filled_matrix = lineSeedFill3D(i,1,j,fillColor,filled_matrix);
          endif
      end
  end

  % Display faces
  ##  if(mod(dilationCounter, 2) == 0)
  if(true)
    matrixToShow = permute(filled_matrix(:, 1, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title(sprintf('|| (F1) Dilations: %d', dilationCounter));

    matrixToShow = permute(filled_matrix(:, end, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title(sprintf('(F2) Dilations: %d ||', dilationCounter));

  endif

  % Check if right face side contains filled pixels
  permeable = any(any(filled_matrix(:, end, :) == fillColor));

  % Write filled dilated slices to disk
##  if(dilationCounter == 7)
##    for i = 1:size(filled_matrix,3)
##        imwrite(filled_matrix(:,:,i), sprintf('slices/slice_%d.png', i));
##    end
##  endif

  % Dilation of image
  if(permeable)
    image_matrix = ~image_matrix;

    if(mod(dilationCounter,2) == 0)
      image_matrix = imdilate(image_matrix, se);
    else
      image_matrix = imdilate(image_matrix, seOpp);
    endif

    image_matrix = ~image_matrix;
    image_matrix = double(image_matrix);

    filled_matrix = image_matrix;
    dilationCounter++;
  endif

until(!permeable)

disp("permeability-3D");
disp(sprintf('Size of critical passage: %d', dilationCounter));

% Show profiler information
data = profile ("info");
profshow (data, 10);
total_time = sum([data.FunctionTable.TotalTime])
