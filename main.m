clear all; close all;

imgName = "resources/testImg/10x10.png";
imgNameDil = "output/10x10.png";
filledImgName = "output/filled1.png";
filledImgNameDil = "output/filled2.png";

x = 2;
y = 1;

structuringElement = {[0,0],[1,0]};
structuringElement2 = {[0,0],[1,0],[-1,0],[0,1],[0,-1]};

image = uint8(imread(imgName));

fillColor = [254;0;0];
boundaryColor = [0;0;0];
oldColor = image(y, x, :);

filled = lineSeedFill2D(x, y, fillColor, boundaryColor, image);

dilatedImage = dilation(image, structuringElement, boundaryColor);

filled2 = lineSeedFill2D(x, y, fillColor, boundaryColor, dilatedImage);


dilatedFilledArea = dilation(filled2, structuringElement2, fillColor);

vec1 = convertPixelsToVectors(filled, fillColor);
vec2 = convertPixelsToVectors(filled2, fillColor);
differenceVectors = difference(vec1, vec2)
for i = 1:columns(differenceVectors)
  if(dilatedImage(differenceVectors{i}(1,2),differenceVectors{i}(1,1),:) != boundaryColor)
    image(differenceVectors{i}(1,2),differenceVectors{i}(1,1),:) = fillColor;
  endif
endfor

imwrite(filled, filledImgName);
imwrite(dilatedImage, imgNameDil);
imwrite(filled2, filledImgNameDil);


X1=double(imread(imgName));
X2=double(imread(imgNameDil));
X3=double(imread(filledImgName));
X4=double(imread(filledImgNameDil));
X5=double(image);

x_ = 3;
y_ = 2;

subplot(x_,y_,1), imshow(X1);
title("original");
subplot(x_,y_,2), imshow(X2);
title("dilated");
subplot(x_,y_,3), imshow(X3);
title("original filled");
subplot(x_,y_,4), imshow(X4);
title("dilated filled");
subplot(x_,y_,5), imshow(X5);
title("difference");

