a = {[1,1],[0,0]};
b = {[1,1],[0,0]};

for i = 1:columns(a)
    for n = 1:columns(b)

      if(a{i} == b{n})
        printf(strcat( num2str(a{i}), "\n"));
      endif

    endfor
  endfor
