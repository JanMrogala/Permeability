#{

returns image with the specified area
filled by the line seed fill algorithm.

INPUT:
  integer xi
  integer yi
  integer zi
  vector fillColor <0,1>
  matrix image [0,1;0,1;...]

OUTPUT:
  matrix ret [[0,0.5;1,0.5;...], [0,0.5;1,0.5;...]]

#}

function ret = lineSeedFill3D(yi, xi, zi, fillColor, image)

  sizeRows = size(image, 1);
  sizeCols = size(image, 2);
  sizeDepth = size(image, 3);

	assert (!(xi > sizeCols || xi <= 0 ||
          yi > sizeRows || yi <= 0 ||
          zi > sizeDepth || zi <= 0),
          "the seed pixel is out of xyz bounds");

  assert (!(image(yi,xi, zi) == 0),
          "the seed pixel is inside boundary area");

  assert (!(image(yi,xi, zi) == fillColor),
          "the seed pixel is inside already filled area");

  stack = {};
	stack(end+1) = [xi,yi,zi];

	while (size(stack, 2) != 0)

    x = stack{end}(1,1);
		y = stack{end}(1,2);
    z = stack{end}(1,3);
		stack(end) = [];

		# find left bound

		while ((x-1) > 0 &&
         image(y,x-1,z) == 1)

			x--;

    endwhile

		# y direction

    # put seed below current scan line at left extreme
		if ((y - 1) > 0 &&
        image(y-1,x,z) == 1)

			# push pixel into stack if there is no boundary pixel on the left, or x is out of bounds
			if ((x - 1) > 0 &&
          image(y-1,x-1,z) != 0 ||
          (x - 1) <= 0)

        stack(end+1) = [x,y-1,z];

      endif
		endif

    # put seed above current scan line at left extreme
		if ((y + 1) <= sizeRows &&
        image(y+1,x,z) == 1)

			if ((x - 1) > 0 &&
          image(y+1,x-1,z) != 0 ||
          (x - 1) <= 0)

        stack(end+1) = [x,y+1,z];

			endif
    endif

		# z direcion
    if ((z + 1) <= sizeDepth &&
        image(y,x,z+1) == 1)

			if ((x - 1) > 0 &&
          image(y,x-1,z+1) != 0 ||
          (x - 1) <= 0)

        stack(end+1) = [x,y,z+1];

			endif
    endif

    if ((z - 1) > 0 &&
        image(y,x,z-1) == 1)

			if ((x - 1) > 0 &&
          image(y,x-1,z-1) != 0 ||
          (x - 1) <= 0)

        stack(end+1) = [x,y,z-1];

      endif
		endif

    # fill current scan line and find critical pixels
		while (x <= sizeCols &&
          image(y,x,z) == 1)

      image(y,x,z) = fillColor;

			if ((y - 1) > 0 && (x - 1) > 0 &&
          image(y-1,x,z) == 1 &&
          image(y-1,x-1,z) == 0)

        stack(end+1) = [x,y-1,z];

			endif

			if ((y + 1) <= sizeRows && (x - 1) > 0 &&
          image(y+1,x,z) == 1 &&
          image(y+1,x-1,z) == 0)

        stack(end+1) = [x,y+1,z];

			endif

			if ((z - 1) > 0 && (x - 1) > 0 &&
          image(y,x,z-1) == 1 &&
          image(y,x-1,z-1) == 0)

        stack(end+1) = [x,y,z-1];

			endif

			if ((z + 1) <= sizeDepth && (x - 1) > 0 &&
          image(y,x,z+1) == 1 &&
          image(y,x-1,z+1) == 0)

        stack(end+1) = [x,y,z+1];

			endif

			x++;

    endwhile
  endwhile

  ret = image;

endfunction

