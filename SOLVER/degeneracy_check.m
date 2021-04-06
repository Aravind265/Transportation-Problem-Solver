function [] = degeneracy_check( m,n,x,Z,degen_flag )
   disp('Checking for degeneracy ...')
   if degen_flag == 1
         disp('--- IBFS - (degeneracy) ---');
         disp('Optimum value : ')
         disp(Z);
         disp('Allocation matrix : ')
         disp(x)
         disp('--- NOTE : inf here refers to Epsilon -> a negligable amount of allocation ---')
   else
         disp('--- IBFS ---');
         disp('Optimum value : ')
         disp(Z);
         disp('Allocation matrix : ')
         disp(x)
   end
end

