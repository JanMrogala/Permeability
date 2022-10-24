clear all; close all;

imgName = "resources/testImg/10x10.png";
imgNameDil = "output/10x10.png";
filledImgName = "output/filled1.png";
filledImgNameDil = "output/filled2.png";

x = 2;
y = 1;

image = uint8(imread(imgName));
imwrite(image, filledImgName);

fillColor = [254;0;0];
boundaryColor = [0;0;0];
oldColor = image(y, x, :);

floodFill2D(x, y, fillColor, oldColor, filledImgName);

filled = uint8(imread(filledImgName));
imwrite(filled, filledImgName);

#######################################################

structuringElement = {[0,0],[1,0]};

dilatedImage = dilation(image, structuringElement, boundaryColor);

imwrite(dilatedImage, imgNameDil);
imwrite(dilatedImage, filledImgNameDil);

floodFill2D(x, y, fillColor, oldColor, filledImgNameDil);
filled2 = uint8(imread(filledImgName));
imwrite(filled2, filledImgName);


X1=double(imread(imgName));
X2=double(imread(imgNameDil));
X3=double(imread(filledImgName));
X4=double(imread(filledImgNameDil));

subplot(2,2,1), imshow(X1);
title("original");
subplot(2,2,2), imshow(X2);
title("dilated");
subplot(2,2,3), imshow(X3);
title("original filled");
subplot(2,2,4), imshow(X4);
title("dilated filled");


