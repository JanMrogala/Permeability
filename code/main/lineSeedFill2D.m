#{

returns image with the specified area
filled by the line seed fill algorithm.

INPUT:
  integer xi
  integer yi
  vector fillColor [r;g;b]
  vector oldColor [r;g;b]
  matrix image [1,2;3,4;...]

OUTPUT:
  matrix ret [1,2;3,4;...]

#}

function ret = lineSeedFill2D(xi, yi, fillColor, boundaryColor, image)

	assert (!(xi > size(image)(1,2) || xi <= 0 ||
          yi > size(image)(1,1) || yi <= 0),
          "the seed pixel is out of xy bounds");

  assert (!(image(yi,xi,:) == boundaryColor || image(yi,xi,:) == fillColor),
          "the seed pixel is inside boundary or already filled area");

  stack = {};
	stack(end+1) = [xi,yi];

	while (size(stack)(1,2) != 0)

		x = stack{end}(1,1);
		y = stack{end}(1,2);
		stack(end) = [];

		# find left bound

		while ((x-1) > 0 &&
         image(y,x-1,:) != boundaryColor &&
         image(y,x-1,:) != fillColor)

			x--;

		endwhile

		# put seed below current scan line at left extreme
		if ((y - 1) > 0 &&
        image(y-1,x,:) != boundaryColor &&
        image(y-1,x,:) != fillColor)

			# push pixel into stack if there is no boundary pixel on the left, or x is out of bounds
			if ((x - 1) > 0 &&
          image(y-1,x-1,:) != boundaryColor ||
          (x - 1) <= 0)

        stack(end+1) = [x,y-1];

      endif
		endif

		# put seed above current scan line at left extreme
		if ((y + 1) <= size(image)(1,1) &&
        image(y+1,x,:) != boundaryColor &&
        image(y+1,x,:) != fillColor)

			if ((x - 1) > 0 &&
          image(y+1,x-1,:) != boundaryColor
          || (x - 1) <= 0)

        stack(end+1) = [x,y+1];

			endif
    endif

		# fill current scan line and find critical pixels
		while (x <= size(image)(1,2) &&
          image(y,x,:) != boundaryColor &&
          image(y,x,:) != fillColor)

      image(y,x,:) = fillColor;

			if ((y - 1) > 0 && (x - 1) > 0 &&
          image(y-1,x,:) != boundaryColor &&
          image(y-1,x,:) != fillColor &&
          image(y-1,x-1,:) == boundaryColor)

        stack(end+1) = [x,y-1];

			endif

			if ((y + 1) <= size(image)(1,1) && (x - 1) > 0 &&
          image(y+1,x,:) != boundaryColor &&
          image(y+1,x,:) != fillColor &&
          image(y+1,x-1,:) == boundaryColor)

        stack(end+1) = [x,y+1];

			endif

			x++;

    endwhile
  endwhile

  ret = image;

endfunction
