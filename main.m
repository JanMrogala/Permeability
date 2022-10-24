clear all; close all;

imgName = "resources/testImg/8x8.png";
filledImgName = "output/filled.png";
x = 2;
y = 1;

image = uint8(imread(imgName));
imwrite(image, filledImgName);

fillColor = [254;0;0];
oldColor = image(y, x, :);

floodFill2D(x, y, fillColor, oldColor, filledImgName);

filled = uint8(imread(filledImgName));
imshow(filled);
