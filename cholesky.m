function [R] = cholesky(A, n)

  % Check that A is positive definite
  for i=1:n
    if (A(i, i) <= 0)
      disp("The matrix is not positive definite.");
      return;
    endif
  endfor

  % Create the empty R matrix
  R = zeros(n);

  % Fill the R matrix
  for i=1:n
    for j=1:n
      if(i == j)
        squares = 0;
        for k=1:j-1
          squares = squares + (R(j,k))^2;
        endfor
        R(j,j) = sqrt(A(j,j) - squares);
      %elseif(i > j)
        summation = 0;
        for k=1:j-1
          summation = summation+ R(i,k)*R(j,k);
        endfor
        R(i,j) = ((A(i,j)-summation)/(R(j,j)));
      endif
    endfor
  endfor

  % redifine R as its transpose
  R = R';

  % Check that R is upper triangular
  if(istriu(R) != 1)
    disp("R is not upper triangular.");
    return;
  endif

endfunction
