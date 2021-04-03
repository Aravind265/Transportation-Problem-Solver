function [x,x1] = degeneracy_check( m,n,x,ZVAM,c )
    %% The degeneracy
     countx=0;
     
     x1 = zeros(m,n);
     x2 = zeros(m,n);
     
     numbasic = m+n-1;
     for i=1:m
         for j=1:n
             if x(i,j)>0
                 countx=countx+1;
                 x1(i,j)=x(i,j);
                 x2(i,j)=x(i,j);
             end
         end
     end
   if countx>=numbasic
         degen=0;
         disp('IBFS');
         disp(ZVAM);
         disp(x)
   else
         degen=1;
         disp('IBFS - (degeneracy)');
         disp(ZVAM);
         disp(x)
         %[x,x1] = degeneracy_correction(degen,m,n,c,x,countx,x1);
   end
end

