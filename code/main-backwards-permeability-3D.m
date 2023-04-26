clear all; close all; profile off; profile clear; profile on;

pkg load image;

% Load slices
image_matrix = zeros(100,100,100);
for i = 1:100
  img = im2double(imread(sprintf('../resources/converted100x100/slice%d.tif', i-1)));
  sz = size(img);

  if(length(sz) == 3)
    img = rgb2gray(img);
  endif

  if !all(all((img == 1) | (img == 0)))
      img = im2bw(img);
  endif
    image_matrix(:,:,i) = ~img;
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
plotX = 5;
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
        dilatedMatrix = imdilate(dilatedMatrix, seOpp);
      else
        dilatedMatrix = imdilate(dilatedMatrix, se);
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
    title(sprintf('< (F1) Rough dilations: %d', dilations));

    matrixToShow = permute(filled_matrix(:, end, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title('(F2) >');

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
        dilatedMatrix = imdilate(dilatedMatrix, seOpp);
      else
        dilatedMatrix = imdilate(dilatedMatrix, se);
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
    title(sprintf('< (F1) Fine dilations: %d', dilations));

    matrixToShow = permute(filled_matrix(:, end, :), [3, 1, 2]);

    num_images++;
    subplot(plotX, plotY, num_images);
    imshow(matrixToShow);
    title('(F2) >');

  endif

  % Check if right border side contains filled pixels
  permeable = any(any(filled_matrix(:, end, :) == fillColor));

until(permeable)

finalDilations = dilations + 1;

disp("backwards-permeability-3D");
disp(sprintf('Size of critical passage: %d', finalDilations));



# Show final dilated filled image with differing colors for every distinct area
numberOfPassages = 0;
fillColor = 0.01;
filledImg = dilatedMatrix;
temp = filledImg;

for i = 1:size(filledImg,1)
    for j = 1:size(filledImg,3)
        if(temp(i,1,j) == 1)
            temp = lineSeedFill3D(i,1,j,fillColor,temp);
            % Check if right face contains filled pixels
            permeable = any(any(temp(:, end, :) == fillColor));
            if(permeable)
              transfer_idx = find(temp == fillColor);
              filledImg(transfer_idx) = temp(transfer_idx);

              fillColor = fillColor + 0.01;
              numberOfPassages++;
            endif

            temp(temp == fillColor) = 0;

        endif
    end
end

disp(sprintf('Number of permeable passages with same size: %d', numberOfPassages));
disp("-------------------------------------------------");

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

imgF1 = permute(filledImg(:, 1, :), [3, 1, 2]);
imgF2 = permute(filledImg(:, end, :), [3, 1, 2]);

imToShow = zeros(size(imgF1,1),size(imgF1,2),3);
imToShow(:,:,1) = imgF1;
imToShow(:,:,2) = imgF1;
imToShow(:,:,3) = imgF1;

imToShow2 = zeros(size(imgF2,1),size(imgF2,2),3);
imToShow2(:,:,1) = imgF2;
imToShow2(:,:,2) = imgF2;
imToShow2(:,:,3) = imgF2;

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


    imToShow_r = imToShow2(:,:,1);
    imToShow_r(imToShow_r == i) = colors{colorIdx}(1);
    imToShow2(:,:,1) = imToShow_r;

    imToShow_g = imToShow2(:,:,2);
    imToShow_g(imToShow_g == i) = colors{colorIdx}(2);
    imToShow2(:,:,2) = imToShow_g;

    imToShow_b = imToShow2(:,:,3);
    imToShow_b(imToShow_b == i) = colors{colorIdx}(3);
    imToShow2(:,:,3) = imToShow_b;

    colorIdx++;
    if(size(colors,1) > colorIdx)
      colors{end+1} = rand(1,3);
    endif

endfor

imToShow = imToShow*255;
imToShow2 = imToShow2*255;

% Plot all permeable passages
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(imToShow);
  title(sprintf('< (F1) Permeable passages: %d', numberOfPassages));

% Plot all permeable passages
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(imToShow2);
  title("(F2) >");

##
imgOrig = permute(image_matrix(:, 1, :), [3, 1, 2]);
imgOrig2 = permute(image_matrix(:, end, :), [3, 1, 2]);

img1 = imToShow; % example 3D matrix representing an image
img2 = zeros(size(img1)); % create new 3D matrix of the same size
img2(:,:,1) = imgOrig;
img2(:,:,2) = imgOrig;
img2(:,:,3) = imgOrig;
img2 = img2 * 255;
##
% create a logical matrix that is true where img1 is not black or white
notBlackOrWhite = ~(img1(:,:,1) == 0 & img1(:,:,2) == 0 & img1(:,:,3) == 0) & ...
                  ~(img1(:,:,1) == 255 & img1(:,:,2) == 255 & img1(:,:,3) == 255);

% transfer colors that are not black or white from img1 to img2
img2(repmat(notBlackOrWhite, [1, 1, 3])) = img1(repmat(notBlackOrWhite, [1, 1, 3]));


% Plot all permeable passages center lines
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(img2);
  title("< (F1) Center of passage in original");

% Face 2

img1 = imToShow2; % example 3D matrix representing an image
img2 = zeros(size(img1)); % create new 3D matrix of the same size
img2(:,:,1) = imgOrig2;
img2(:,:,2) = imgOrig2;
img2(:,:,3) = imgOrig2;
img2 = img2 * 255;
##
% create a logical matrix that is true where img1 is not black or white
notBlackOrWhite = ~(img1(:,:,1) == 0 & img1(:,:,2) == 0 & img1(:,:,3) == 0) & ...
                  ~(img1(:,:,1) == 255 & img1(:,:,2) == 255 & img1(:,:,3) == 255);

% transfer colors that are not black or white from img1 to img2
img2(repmat(notBlackOrWhite, [1, 1, 3])) = img1(repmat(notBlackOrWhite, [1, 1, 3]));


% Plot all permeable passages center lines
  num_images++;
  subplot(plotX, plotY, num_images);
  imshow(img2);
  title("(F2) >");

% Show profiler information
data = profile ("info");
profshow (data, 10);
total_time = sum([data.FunctionTable.TotalTime])
