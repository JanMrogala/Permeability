

function ret = intersection(vectors1, vectors2)

   ret = {};

   for i = 1:columns(vectors1)
    for n = 1:columns(vectors2)

      if(vectors1{i} == vectors2{n})
        ret(end+1) = vectors1{i};
      endif

    endfor
  endfor

endfunction
