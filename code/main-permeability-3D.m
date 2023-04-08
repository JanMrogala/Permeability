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
se(:,:,2) = [0 0 0; 0 1 1; 0 1 1];

image_matrix = ~image_matrix;

for i = 1:5

  image_matrix = imdilate(image_matrix, se);


end

image_matrix = ~image_matrix;
image_matrix = double(image_matrix);
filled_matrix = image_matrix;

do

  permeable = false;

  % Fill image starting from left face
  for i = 1:size(filled_matrix,2)
      for j = 1:size(filled_matrix,3)

          if(filled_matrix(i,1,j) == 1)
            filled_matrix = lineSeedFill3D(1,i,j,fillColor,filled_matrix);
          endif

      end
  end

  % Check if right face side contains filled pixels
  for i = 1:size(filled_matrix,2)
      for j = 1:size(filled_matrix,3)

          if(filled_matrix(i,size(filled_matrix,1),j) == fillColor)
            permeable = true;
            break
          endif

      end
  end

  if(dilationCounter == 9)
    for i = 1:size(filled_matrix,3)
        imwrite(filled_matrix(:,:,i), sprintf('slices/slice_%d.png', i));
    end
  endif

  %% Dilatation of image
  if(permeable)
    image_matrix = ~image_matrix;

    image_matrix = imdilate(image_matrix, se);

    image_matrix = ~image_matrix;
    image_matrix = double(image_matrix);

    filled_matrix = image_matrix;
    dilationCounter += 1;
  endif

until(!permeable)



disp(sprintf('Size of critical passage: %d', dilationCounter));

% Show profiler information
data = profile ("info");
profshow (data, 10);
