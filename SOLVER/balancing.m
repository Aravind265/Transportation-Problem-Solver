function [m,n,s,d,c] = balancing(m,n,s,d,c,sums,sumd)
    disp('Balancing ...')
   if sums>sumd
       n = n+1;
       c(1,n) = 0;
       d(n) = sums-sumd;
       disp(d)
       disp(c)
   else
       m = m+1;
       c(m,1) = 0;
       s(m) = sumd-sums;
       disp(s)
       disp(c)
   end
end

