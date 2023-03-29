% Read in the input RGB image
imgName = "../resources/testImg/10x10.png";

img = imread(imgName);
input_image = uint8(img);


% Define the structuring element as a binary matrix
structuring_element = [0, 1, 1, 0;
                       0, 0, 1, 1;
                       0, 0, 0, 1;
                       0, 0, 0, 0];

% Apply dilation to each color channel of the image using the structuring element
red_channel = imdilate(input_image(:, :, 1), strel(structuring_element));
green_channel = imdilate(input_image(:, :, 2), strel(structuring_element));
blue_channel = imdilate(input_image(:, :, 3), strel(structuring_element));
output_image = cat(3, red_channel, green_channel, blue_channel);

% Display the input and output images side by side
figure;
subplot(1, 2, 1); imshow(double(input_image)); title('Input Image');
subplot(1, 2, 2); imshow(double(output_image)); title('Dilated Image');
