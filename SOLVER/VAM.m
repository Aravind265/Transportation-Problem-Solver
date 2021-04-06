function [Z, x, degen_flag] = VAM( m,n,c,c_dup,d_dup,s_dup,x )
    disp('Starting  Vogel''s Approximation Method ... ')
    iteration_count=0;
    flag = 0;
    degen_flag = 0;
    for k=1:m+n-1
        iteration_count=iteration_count+1;
        
    %% finding the two minimum cost elements in each row
    row_min_1=zeros(m,1);
    row_min_2=zeros(m,1);
    jmin=zeros(1,m);
    for i=1:m
        min1=inf;
        for j=1:n
           if c_dup(i,j)<min1
               min1=c_dup(i,j);
               jmin(i)=j;% position of min1 each row
           end
        end
        row_min_1(i)=min1;
    end
    for i=1:m
        min2=inf;
        for j=1:n
           if j~=jmin(i)
              if c_dup(i,j)<=min2
                  min2=c_dup(i,j);
              end
           end       
        end
        row_min_2(i)=min2;
    end
    %% finding the two minimum cost elements in each column
    col_min_1=zeros(1,n);
    col_min_2=zeros(1,n);
    imin=zeros(n,1);
    for j=1:n
        minR1=inf;
        for i=1:m
            if c_dup(i,j)<minR1
                minR1=c_dup(i,j);
                imin(j)=i;% position of minR1 each column
            end
        end
        col_min_1(j)=minR1;
    end
    for j=1:n
        minR2=inf;
        for i=1:m
           if i~=imin(j)
              if c_dup(i,j)<=minR2
                  minR2=c_dup(i,j);
              end
           end      
        end
        col_min_2(j)=minR2;
    end
    %% Penalty
     diffrow=zeros(m,1);
     diffcol=zeros(1,n);
     for i=1:m
         diffrow(i)=abs(row_min_2(i)-row_min_1(i));
     end
     for j=1:n
         diffcol(j)=abs(col_min_2(j)-col_min_1(j));
     end
     %% The greatest penalty
        R=0;
        Row=zeros(m,1);
        for i=1:m
            if diffrow(i)>=R
                R=diffrow(i);
                iminrow=i; % the greatest diff. on column
            end
        end
        Row(iminrow)=R;
        S=0;
        Col=zeros(1,n);
        for j=1:n
            if diffcol(j)>=S
                S=diffcol(j);
                jmincol=j;% the greatest diff. on row
            end
        end
        Col(jmincol)=S;
        great=zeros(1,n);
        for j=1:n
        if S>=R
            great(jmincol)=Col(jmincol);
            Colline=1;
        else
            great(iminrow)=Row(iminrow);
            Colline=0;
        end
        end

        %% Find the lowest cost in the highest penalty row or column
       
         if Colline==1% column has the highest penalty
             j=jmincol;
             R1=inf;
             for i=1:m
                 if c_dup(i,jmincol)<=R1
                     R1=c_dup(i,jmincol);
                     igreat=i; % the lowest cost on the jmincol
                 end
             end
                
             % allocation 
             if s_dup(igreat)>d_dup(jmincol)
                 x(igreat,jmincol)=d_dup(jmincol);
                 s_dup(igreat)=s_dup(igreat)-d_dup(jmincol);
                 d_dup(jmincol)=0;
                 eliminaterow=0; % If current demand =0 (eliminaterow=0), eliminate a column.
             elseif s_dup(igreat)<d_dup(jmincol)
                 x(igreat,jmincol)=s_dup(igreat); 
                 d_dup(jmincol)=d_dup(jmincol)-s_dup(igreat);
                 s_dup(igreat)=0;

                 eliminaterow=1; % If supply =0 (eliminaterow=1), eliminate a row.
             elseif s_dup(igreat)==d_dup(jmincol)
                  x(igreat,jmincol)=s_dup(igreat); 
                 d_dup(jmincol)=0;
                 s_dup(igreat)=0;
                 eliminaterow=2;% If supply=demnad (eliminaterow=2),eliminate both a row and a column
             end

              % Eliminate a column or a row
              if eliminaterow==0;% Eliminate a column
                  for i=1:m
                      c_dup(i,jmincol)=inf;
                  end
              elseif eliminaterow==1 % Eliminate a row
                  for j=1:n
                      c_dup(igreat,j)=inf;
                  end
              elseif eliminaterow==2
                  for i=1:m
                      c_dup(i,jmincol)=inf;
                  end
                   for j=1:n
                      c_dup(igreat,j)=inf;
                   end

              end
         else % Colline=0 row has the highest penalty
             i=iminrow;
             R2=inf;
             for j=1:n
                 if c_dup(iminrow,j)<R2
                     R2=c_dup(iminrow,j);
                     jgreat=j; % the lowest cost on the iminrow 
                 end
             end

             if s_dup(iminrow)>d_dup(jgreat)
                 x(iminrow,jgreat)=d_dup(jgreat);
                 s_dup(iminrow)=s_dup(iminrow)-d_dup(jgreat);
                 d_dup(jgreat)=0;
                 eliminaterow=0; % If current demand=0 (eliminaterow=0), eliminate a column. 
             elseif s_dup(iminrow)<d_dup(jgreat)
                 x(iminrow,jgreat)=s_dup(iminrow); 

                 d_dup(jgreat)=d_dup(jgreat)-s_dup(iminrow);
                 s_dup(iminrow)=0;
                 eliminaterow=1; % If current supply =0 (eliminaterow=1),eliminate a row
             elseif s_dup(iminrow)==d_dup(jgreat)
                 x(iminrow,jgreat)=s_dup(iminrow);
                 d_dup(jgreat)=0;
                 s_dup(iminrow)=0;
                 eliminaterow=2; % If current supply =demand (eliminaterow=2),eliminate both a row and a column
             end
                % Eliminate a column or a row
              if eliminaterow==0% Eliminate a column
                  for i=1:m
                      c_dup(i,jgreat)=inf;% jmincol
                  end
              elseif eliminaterow==1 % Eliminate a row
                  for j=1:n
                      c_dup(iminrow,j)=inf; % iminrow = the greatest diff. row
                  end
              elseif eliminaterow==2 %Eliminate both a row and a column
                  for i=1:m
                      c_dup(i,jgreat)=inf;% Eliminate a column
                  end
                  for j=1:n
                      c_dup(iminrow,j)=inf; % Eliminate a row
                  end
              end

         end
         
         fprintf(' --- Iteration %d ---\n',iteration_count)
         disp('ALLOCATION MATRIX')
         disp(x)
         disp('SUPPLY BALANCE')
         disp(s_dup)
         
         %checking zero allocation
         if sum(s_dup) == 0
             if flag == 0
                flag = 1;
             elseif  flag == 1
                x(i,j) = inf;
                degen_flag = 1;
             end
         end
         %% Calculate the objective function

         Z=0;
         for j=1:n
             for i=1:m
                 if x(i,j)>0
                    if x(i,j) == inf
                        x(i,j) = 0;
                    end
                    Z=Z+c(i,j)*x(i,j);
                    if x(i,j) == 0
                        x(i,j) = inf;
                    end
                 end
             end
         end
    end
end

