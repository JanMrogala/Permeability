clear all; close all; profile clear; profile on;

image_matrix = zeros(100,100,100);
for i = 1:100
    image_matrix(:,:,i) = ~imread(sprintf('../resources/converted100x100/slice%d.tif', i-1));
end

##figure;
##for i = 1:100
##    subplot(2,5,i);
##    imagesc(image_matrix(:,:,i));
##    colormap(gray);
##    axis square;
##end

fillColor = 0.5;
filled_matrix = lineSeedFill3D(1,1,1,fillColor,image_matrix);

% display the matrix in text form

##figure;
##for i = 1:10
##    subplot(2,5,i);
##    imagesc(filled_matrix(:,:,i));
##    colormap(gray);
##    axis square;
##end

for i = 1:size(filled_matrix,3)
    imwrite(filled_matrix(:,:,i), sprintf('slices/slice_%d.png', i));
end

% Show profiler information
profile off;
data = profile ("info");
profshow (data, 10);
