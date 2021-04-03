function [ x,x1 ] = degeneracy_correction( degen,m,n,c,x,countx,x1 )
%%correct degeneracy matrix
     numbasic = m+n-1;   
     if degen==1
        numdegen=numbasic-countx;
        iterationDegen=0;
     for A=1:numdegen 
        iterationDegen=iterationDegen+1;

     %% Construct the u-v variables
        udual=zeros(m,1);
        vdual=zeros(1,n);

        udual(1)=0;
        for i=1:1
           for j=1:n
               if x(i,j)>0
                   vdual(j)=c(i,j)-udual(i);
               end
           end
        end
       udual(3) = 5 - vdual(3);
       for j=1:1
           for i=1:m
               if x(i,j)>0
                   iu=i;
                   udual(iu)=c(i,j)-vdual(j);
               end
           end
       end
    for k=1:m*n 
         for i=1:m
           if udual(i)>0
              iu=i;
              for j=1:n
                if x(iu,j)>0

                 vdual(j)=c(iu,j)-udual(iu);
                end
              end
           end
        end
     for j=1:n
         if vdual(j)>0
             jv=j;
             for i=1:m
                 if x(i,jv)>0
                     udual(i)=c(i,jv)-vdual(jv);
                 end
             end
         end
     end
     countu=0;
     countv=0;
     for i=1:m
         if udual(i)<inf
          countu=countu+1;   
         end
     end
     for j=1:n
         if vdual(j)<inf
             countv=countv+1;
         end
     end
     %if (countu==m) && (countv==n)
     %    return 
     %end
    end
    
    
    %% Find the non-basic cells
      unx=zeros(m,n);
      for j=1:n
          for i=1:m
              if x(i,j)==0
                  unx(i,j)=c(i,j)-udual(i)-vdual(j);
              end
          end
      end
      %% Search maximum positive of udual+vdual-c(i,j) to reach a new basic variable
      maxunx=inf;
      for j=1:n
          for i=1:m
              if unx(i,j)<=maxunx
                  maxunx=unx(i,j);
                  imax=i;
                  jmax=j;
              end
          end
      end
       %% Count the number of  basic variable on each and row

         for j=1:n
             sumcol=0;
             for i=1:m
                 if x(i,j)>0
                     sumcol=sumcol+1;
                 end
             end
                 x(m+1,j)=sumcol;
         end
          for i=1:m
             sumrow=0;
             for j=1:n
                 if x(i,j)>0
                     sumrow=sumrow+1;
                 end
             end
                 x(i,n+1)=sumrow;
          end
            %% Construct the equipvalent x matrix
              for j=1:n+1
                  for i=1:m+1
                      x1(i,j)=x(i,j);
                  end
              end
         %% Eliminate an entering variable for adding a new one
             for j=1:n
                  for i=1:m
                      if (x(i,j)==1 || x1(i,j)==1)

                          x1(i,j)=0;
                      end
                  end
             end
              % Add a new entering variable to x1 matrix 
              % Assign the small value =1
              for j=1:n
                  for i=1:m

                      x1(imax,jmax)=1;
                  end
              end

     % Seaching and adding the entering point for corrective action
          for i=1:m
             if i~=imax
               if x1(i,jmax)>0
                  ienter=i;
                   for j=1:n
                      if j~=jmax
                       if x1(ienter,j)>0 && x1(imax,j)==0 
                           jenter=j;
                       end
                      end
                   end
                end
              end
          end
          x1(imax,jenter)=1;
          x(imax,jenter)=1;
     end
     end
end
          
     

