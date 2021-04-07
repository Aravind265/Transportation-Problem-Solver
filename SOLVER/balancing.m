function [m,n,s,d,c] = balancing(m,n,s,d,c,sums,sumd)
    disp('Balancing ...')
   if sums>sumd
       n = n+1;
       c(1,n) = 0;
       d(n) = sums-sumd;
       disp('The balanced demand matrix : ')
       disp(d)
       disp('The balanced cost matrix : ')
       disp(c)
   else
       m = m+1;
       c(m,1) = 0;
       s(m) = sumd-sums;
       disp('The balanced supply matrix : ')
       disp(s)
       disp('The balanced cost matrix : ')
       disp(c)
   end
end

