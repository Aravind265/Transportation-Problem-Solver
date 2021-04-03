function [ZVAM, x] = VAM( m,n,c,c1,d1,s1,x )
    disp('Starting  Vogel''s Approximation Method ... ')
    iteration=0;
    flag = 0;
    for k=1:m+n-1
        iteration=iteration+1;
        
    %% Row Difference
    minrow1=zeros(m,1);
    minrow2=zeros(m,1);
    jmin=zeros(1,m);
    for i=1:m
        min1=inf;
        for j=1:n
           if c1(i,j)<min1
               min1=c1(i,j);
               jmin(i)=j;
           end
        end
        minrow1(i)=min1;
    end
    for i=1:m
        min2=inf;
        for j=1:n
           if j~=jmin(i)
              if c1(i,j)<=min2
                  min2=c1(i,j);
              end
           end       
        end
        minrow2(i)=min2;
    end
    %% Column Difference
     mincol1=zeros(1,n);
    mincol2=zeros(1,n);
    imin=zeros(n,1);
    for j=1:n
        minR1=inf;
        for i=1:m
            if c1(i,j)<minR1
                minR1=c1(i,j);
                imin(j)=i;% position of minR1 each column
            end
        end
        mincol1(j)=minR1;
    end
    for j=1:n
        minR2=inf;
        for i=1:m
           if i~=imin(j)
              if c1(i,j)<=minR2
                  minR2=c1(i,j);
              end
           end      
        end
        mincol2(j)=minR2;
    end
    %% Penalty
     diffrow=zeros(m,1);
     diffcol=zeros(1,n);
     for i=1:m
         diffrow(i)=minrow2(i)-minrow1(i);
     end
     for j=1:n
         diffcol(j)=mincol2(j)-mincol1(j);
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

        %% Search the entry cell
       % x=zeros(m,n); If you want to collect data from each iteration into the
       % matrix, you must assign  matrix dimension out of loop.
         if Colline==1% Colline=1,0 is the greatest diff on column line,row line.
             j=jmincol;
             R1=inf;
             for i=1:m
                 if c1(i,jmincol)<=R1
                     R1=c1(i,jmincol);
                     igreat=i; % the lowest cost on the jmincol
                 end
             end

             if s1(igreat)>d1(jmincol)
                 x(igreat,jmincol)=d1(jmincol);
                 s1(igreat)=s1(igreat)-d1(jmincol);
                 d1(jmincol)=0;
                 eliminaterow=0; % If current demand =0 (eliminaterow=0), eliminate a column.
             elseif s1(igreat)<d1(jmincol)
                 x(igreat,jmincol)=s1(igreat); 
                 d1(jmincol)=d1(jmincol)-s1(igreat);
                 s1(igreat)=0;

                 eliminaterow=1; % If supply =0 (eliminaterow=1), eliminate a row.
             elseif s1(igreat)==d1(jmincol)
                  x(igreat,jmincol)=s1(igreat); 
                 d1(jmincol)=0;
                 s1(igreat)=0;
                 eliminaterow=2;% If supply=demnad (eliminaterow=2),eliminate both a row and a column
             end

              % Eliminate a column or a row
              if eliminaterow==0;% Eliminate a column
                  for i=1:m
                      c1(i,jmincol)=inf;
                  end
              elseif eliminaterow==1 % Eliminate a row
                  for j=1:n
                      c1(igreat,j)=inf;
                  end
              elseif eliminaterow==2
                  for i=1:m
                      c1(i,jmincol)=inf;
                  end
                   for j=1:n
                      c1(igreat,j)=inf;
                   end

              end
         else % Colline=0;
             i=iminrow;
             R2=inf;
             for j=1:n
                 if c1(iminrow,j)<R2
                     R2=c1(iminrow,j);
                     jgreat=j; % the lowest cost on the iminrow 
                 end
             end

             if s1(iminrow)>d1(jgreat)
                 x(iminrow,jgreat)=d1(jgreat);
                 s1(iminrow)=s1(iminrow)-d1(jgreat);
                 d1(jgreat)=0;
                 eliminaterow=0; % If current demand=0 (eliminaterow=0), eliminate a column. 
             elseif s1(iminrow)<d1(jgreat)
                 x(iminrow,jgreat)=s1(iminrow); 

                 d1(jgreat)=d1(jgreat)-s1(iminrow);
                 s1(iminrow)=0;
                 eliminaterow=1; % If current supply =0 (eliminaterow=1),eliminate a row
             elseif s1(iminrow)==d1(jgreat)
                 x(iminrow,jgreat)=s1(iminrow);
                 d1(jgreat)=0;
                 s1(iminrow)=0;
                 eliminaterow=2; % If current supply =demand (eliminaterow=2),eliminate both a row and a column
             end
                % Eliminate a column or a row
              if eliminaterow==0% Eliminate a column
                  for i=1:m
                      c1(i,jgreat)=inf;% jmincol
                  end
              elseif eliminaterow==1 % Eliminate a row
                  for j=1:n
                      c1(iminrow,j)=inf; % iminrow = the greatest diff. row
                  end
              elseif eliminaterow==2 %Eliminate both a row and a column
                  for i=1:m
                      c1(i,jgreat)=inf;% Eliminate a column
                  end
                  for j=1:n
                      c1(iminrow,j)=inf; % Eliminate a row
                  end
              end

         end
         
         fprintf('Iteration %d \n',iteration)
         disp(x)
         disp(s1)
         
         %checking zero allocation
         if sum(s1) == 0
             if flag == 0
                flag = 1;
             elseif  flag == 1
                x(i,j) = inf;
             end
         end
         %% Calculate the objective function

         ZVAM=0;
         for j=1:n
             for i=1:m
                 if x(i,j)>0
                    if x(i,j) == inf
                        x(i,j) = 0;
                    end
                    ZVAM=ZVAM+c(i,j)*x(i,j);
                    if x(i,j) == 0
                        x(i,j) = inf;
                    end
                 end
             end
         end
    end
end

