

function ret = difference(vectors1, vectors2)

   temp = vectors1;
   ret = {};

   for i = 1:columns(vectors1)
    for n = 1:columns(vectors2)

      if(vectors1{i} == vectors2{n})
        temp{i} = [];
        break
      endif

    endfor
  endfor

  for i = 1:columns(temp)
    if(!isempty(temp{i}))
      ret(end+1) = temp{i};
    endif
  endfor
endfunction
