clear all; close all;
% define the number of images and their dimensions
num_images = 100;
image_rows = 100;
image_cols = 100;

% preallocate a 3D matrix to store the images
image_matrix = zeros(image_rows, image_cols, num_images);

% loop through the images and load them into the matrix
for i = 1:num_images
    % read the image as a matrix
    img = imread(sprintf('../resources/converted100x100/slice%d.tif', i-1));
    % convert the image to a logical matrix
    img = logical(img);
    % store the image in the 3D matrix
    image_matrix(:, :, i) = img;
end

% define the vertices of the cube
vertices = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 1 1; 1 1 1; 1 0 1; 0 0 1];

% define the faces of the cube
faces = [1 2 3 4; 2 3 6 7; 3 4 5 6; 4 5 8 1; 1 2 7 8;5 6 7 8];

% create a patch object to represent the cube
figure;
h = patch('Vertices', vertices, 'Faces', faces);

% set the axis limits and aspect ratio
axis([0,1,0,1,0,1]);
axis equal;

% set the face colors of the cube to display slices of the matrix
set(h, 'FaceColor', 'flat', 'FaceVertexCData', squeeze(image_matrix(1,:,:)));
