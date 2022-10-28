function ret = rapidSeedFill2D(int x, int y, fillColor, boundaryColor, image)

	assert (x > size(image)(1,2) || x <= 0 ||
          y > size(image)(1,1) || y <= 0,
          "the seed pixel is out of xy bounds");

  assert (image(y,x,:) == boundaryColor || image(y,x,:) == fillColor,
          "the seed pixel is inside boundary or already filled area");

	int xl, xr, xpl, xpr, currY, dir, templ, tempr;
	std::stack<Node2D*> rangeStack;

	Operations2D::extractValidRange(xl, xr, x, x, y, boundaryColor, fillColor, filledPx, image, metrics);

	Node2D* range1 = new Node2D(xl, xr, y+1, +1);
	Node2D* range2 = new Node2D(xl, xr, y-1, -1);
	rangeStack.push(range1);
	rangeStack.push(range2);
	metrics[1] += 2;

	while (!rangeStack.empty())
	{
		xpl = rangeStack.top()->xl;
		xpr = rangeStack.top()->xr;
		currY = rangeStack.top()->y;
		dir = rangeStack.top()->directionZ;

		if (rangeStack.size() > metrics[2])
			metrics[2] = rangeStack.size();

		rangeStack.pop();
		metrics[1] += 1;

		if (currY >= 0 && currY < image->h &&
			Operations2D::extractValidRange(xl, xr, xpl, xpr, currY, boundaryColor, fillColor, filledPx, image, metrics))
		{
			templ = xl;
			tempr = xr;
			Node2D* r = new Node2D(xl, xr, currY + dir, dir);
			rangeStack.push(r);
			metrics[1] += 1;

			// find other ranges at scanline y
			while (tempr < xpr &&
				Operations2D::extractValidRange(templ, tempr, xr, xpr, currY, boundaryColor, fillColor, filledPx, image, metrics))
			{
				if (templ <= xpr)
				{
					Node2D* r = new Node2D(templ, tempr, currY+dir, dir);
					rangeStack.push(r);
					metrics[1] += 1;
				}
			}
			// find other ranges on left side of scanline yp
			while (xl < xpl - 1 &&
				Operations2D::extractValidRange(templ, tempr, xl, xpl - 2, currY - dir, boundaryColor, fillColor, filledPx, image, metrics))
			{
				Node2D* r = new Node2D(templ, tempr, currY - 2 * dir, -dir);
				rangeStack.push(r);
				metrics[1] += 1;
			}
			// find other ranges on right side of scanline yp

			while (tempr > xpr + 1 &&
				Operations2D::extractValidRange(templ, tempr, xpr + 2, tempr, currY - dir, boundaryColor, fillColor, filledPx, image, metrics))
			{
				Node2D* r = new Node2D(templ, tempr, currY - 2 * dir, -dir);
				rangeStack.push(r);
				metrics[1] += 1;
			}
		}
	}
	return metrics;

endfunction




function extractValidRange(xl, xr, xpl, xpr, y, boundaryColor, fillColor, image)

	for (int i = xpl; i <= xpr; i++)   // find valid range for xl xr
	{
		if (!image->compareColors(i, y, boundaryColor) &&
			!image->compareColors(i, y, fillColor))
		{
			xl = i;
			while ((xl-1) >= 0 &&
				!image->compareColors(xl - 1, y, boundaryColor) &&   // find left bound
				!image->compareColors(xl - 1, y, fillColor))
			{
				xl--;
			}
			xr = xl;
			while ((xr + 1) < image->w &&
				!image->compareColors(xr + 1, y, boundaryColor) &&   // find right bound
				!image->compareColors(xr + 1, y, fillColor))
			{
				xr++;
			}
			for (int i = xl; i <= xr; i++)  // extract pixels
			{
				image->setPixel(i, y, fillColor);
				metrics[0] += 1;
			}

			filledPx->push_back(new Pixel(xl, y));
			filledPx->push_back(new Pixel(xr, y));
			return true;
		}
	}
	return false;
endfunction
