close all; clear all;

% Load the "image" package
pkg load image;

% Define a custom 3D matrix
A = zeros(3, 3, 3); % initialize all elements to 0

% Set the values of the matrix manually
A(1, 1, 1) = 1;
A(2, 1, 1) = 1;
A(3, 1, 1) = 1;
A(1, 2, 1) = 0;
A(2, 2, 1) = 0;
A(3, 2, 1) = 0;
A(1, 3, 1) = 1;
A(2, 3, 1) = 1;
A(3, 3, 1) = 1;

% Create a voxel image from the matrix
V = logical(A);

% Display the voxel image using vol3d
figure();
vol3d('CData', V, 'FaceAlpha', 0.5);
axis('equal');
axis('tight');
view(3);
