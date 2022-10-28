clear all; close all;

imgName = "resources/testImg/10x10.png";
imgNameDil = "output/10x10.png";
filledImgName = "output/filled1.png";
filledImgNameDil = "output/filled2.png";

x = 2;
y = 1;

structuringElement = {[0,0],[1,0]};

image = uint8(imread(imgName));

fillColor = [254;0;0];
boundaryColor = [0;0;0];
oldColor = image(y, x, :);

filled = lineSeedFill2D(x, y, fillColor, boundaryColor, image);

dilatedImage = dilation(image, structuringElement, boundaryColor);

filled2 = lineSeedFill2D(x, y, fillColor, boundaryColor, dilatedImage);

imwrite(filled, filledImgName);
imwrite(dilatedImage, imgNameDil);
imwrite(filled2, filledImgNameDil);


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
