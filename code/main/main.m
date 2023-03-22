clear all; close all;

imgName = "../resources/testImg/10x10.png";
imgNameDil = "../output/10x10.png";
filledImgName = "../output/filled1.png";
filledImgNameDil = "../output/filled2.png";

x = 2;
y = 1;


image = uint8(imread(imgName));

fillColor = [254;0;0];
boundaryColor = [0;0;0];

filled = lineSeedFill2D(x, y, fillColor, boundaryColor, image);

narrowestPoints = narrowestPoints2D(image, fillColor, boundaryColor, [x,y])

for i = 1:columns(narrowestPoints)

  image(narrowestPoints{i}(1,2),narrowestPoints{i}(1,1),:) = fillColor;

endfor

#{
#x direction --------------

dilatedImageX = dilation(image, structuringElementX, boundaryColor);

filled2X = lineSeedFill2D(x, y, fillColor, boundaryColor, dilatedImageX);

dilatedFilledAreaX = dilation(filled2X, structuringElementOppX, fillColor);
dilatedFilledArea2X = dilation(filled2X, structuringElement, fillColor);

vec1 = convertPixelsToVectors(dilatedFilledAreaX, fillColor);
vec2 = convertPixelsToVectors(dilatedFilledArea2X, fillColor);
differenceVectors = difference(vec1, vec2);
image2X = image;
for i = 1:columns(differenceVectors)
  if(image(differenceVectors{i}(1,2),differenceVectors{i}(1,1),:) != boundaryColor)

    narrowestPoints(end+1) = differenceVectors{i};
  endif
endfor

for i = 1:columns(narrowestPoints)

  image2X(narrowestPoints{i}(1,2),narrowestPoints{i}(1,1),:) = fillColor;


endfor


imwrite(filled, filledImgName);


X1=double(imread(imgName));
X2=double(imread(imgNameDil));
X3=double(imread(filledImgName));
X4=double(imread(filledImgNameDil));
X5=double(dilatedFilledAreaX);
X6=double(image2X);

x_ = 2;
y_ = 3;

subplot(x_,y_,1), imshow(X1);
title("1. original");
subplot(x_,y_,2), imshow(X2);
title("2. dilated");
subplot(x_,y_,3), imshow(X3);
title("3. original filled");
subplot(x_,y_,4), imshow(X4);
title("4. dilated filled");
subplot(x_,y_,5), imshow(X5);
title("5. difference");
subplot(x_,y_,6), imshow(X6);
title("6. narrowest points");
#}
subplot(1,1,1), imshow(double(image));

