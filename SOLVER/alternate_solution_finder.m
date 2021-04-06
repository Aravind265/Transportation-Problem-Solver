function [ xpath, Z ] = alternate_solution_finder( imax,jmax,x,c,m,n )
    %% Entering a new basic variable add into the basic variable matrix
   
   alt_x = zeros(m,n);
   alt_z = 0;
   
   x1=zeros(m+1,n+1);
   x2=zeros(m+1,n+1);
     % duplicating values
     for j=1:n
         for i=1:m
             if x(i,j)>0
                x1(i,j)=x(i,j);
                x2(i,j)=x(i,j);
             end
         end
     end
     % Entering the new variable 
     x1(imax,jmax)=inf;
     x2(imax,jmax)=inf;
  for j=1:n
       countcol=0;
      for i=1:m
          if x1(i,j)>0 || x1(i,j)==inf
            
           
             countcol=countcol+1;
          end
         
      end
      x1(m+1,j)=countcol;
      x2(m+1,j)=countcol;
  end
 for i=1:m
     countrow=0;
     for j=1:n
         if x1(i,j)>0
             countrow=countrow+1;
         end
     end
     x1(i,n+1)=countrow;
     x2(i,n+1)=countrow;
 end
 %% Construct loop
  % Eliminate the basic variables that has only one on each row 
  iterationloop=0;
  for k=1:m
      iterationloop=iterationloop+1;
    for i=1:m
      if x2(i,n+1)==1 
          ieliminate=i;
         for j=1:n
             if x2(ieliminate,j)<inf &&   x2(ieliminate,j)>0
                 jeliminate=j;
                x2(ieliminate,jeliminate)=0;% Eliminate the basic variable on row
                x2(ieliminate,n+1)=x2(ieliminate,n+1)-1; % decrease the number of the basic variable on row by one 
                x2(m+1,jeliminate)=x2(m+1,jeliminate)-1; % decrease the number of the basic variable on column by one                       
             end
         end
      end
    end
    
    
    
  % Eliminate the basic variables that has only one on each column
  for j=1:n
      if x2(m+1,j)==1
          jeliminate1=j;
          for i=1:m
              if x2(i,jeliminate1)<inf && x2(i,jeliminate1)>0;
                  ieliminate1=i;
                  x2(ieliminate1,jeliminate1)=0;% Eliminate the basic variable on row
                  x2(m+1,jeliminate1)=x2(m+1,jeliminate1)-1; % decrease the number of the basic variable on column one unit
                  x2(ieliminate1,n+1)=x2(ieliminate1,n+1)-1;% decrease the number of the basic variable on row one unit
              end
          end
      end
  end
  
  
  
   % Control the constructing loop path
  for j=1:n
    for i=1:m
        if (x2(i,n+1)==0 || x2(i,n+1)==2) && (x2(m+1,j)==0 || x2(m+1,j)==2) 
           break;
        else
                
      
        end
    end
  end                   
  end 
  %% Make +/-sign on basic variables in the loop path (x2)
     %1. Add - sign on basic variable on row(imax) and on basic variable on
     %column (jmax)
     for j=1:n
               
             if  (x2(imax,j)~=0 && x2(imax,j)<inf && x2(imax,n+1)==2)
              
                 jneg=j;
                 x2(imax,jneg)=(-1)*x2(imax,jneg);
                 x2(m+1,jneg)=1;
                 x2(imax,n+1)=1;
                   for i=1:m
                       if (x2(i,jneg)>0 && x2(m+1,jneg)==1)
                           ineg=i;
                          
                       end
                   end
               
             end
     end
  for p=1:n
     
      for j=1:n
         if (j~=jneg && x2(ineg,j)>0 )&& (x2(ineg,n+1)==2) 
            
                 jneg1=j;
                 x2(ineg,jneg1)=(-1)*x2(ineg,jneg1);
                 x2(ineg,n+1)=1;
                  x2(m+1,jneg1)=1;
       
                 for i=1:m
                   if (x2(i,jneg1)>0 && x2(m+1,jneg1)==1)
                     ineg1=i;
                     ineg=ineg1;
                     jneg=jneg1;
                   end
                 end
         end
           
     
      end
    
    
  
     % Control loop
     if  jneg1==jmax
       
         break
     end   
     
  end                  
  
        
   %% Search the net smallest negative basic variable in the loop path
     small=inf;
     for j=1:n
         for i=1:m
             
                 if x2(i,j)<0
                     if abs(x2(i,j))<small
                         small=abs(x2(i,j));
                     end
                 end
           
         end
     end
     
   
   
   % Construct the loop path
        x3=zeros(m,n);
       
           for j=1:n
               for i=1:m
                   x3(i,j)=x2(i,j);
                  
               end
           end
     %% Add the smallest value to the positive basis variable and subtract to the negative basic variable  
       for i=1:m
            for j=1:n
                x3(imax,jmax)=small;             % element entering the basis
               
               if x3(i,j)~=0                      % -theta
                  if x3(i,j)<0
                    x3(i,j)=(x3(i,j))+small;
                      
                      if x3(i,j)==0               % element leaving the basis
                          x3(i,j)=inf;
                         
                            
                      end
                      
                  else
                    if i~=imax && j~=jmax
                        x3(i,j)=x3(i,j)+small;     % +theta
                       
                    end
                  end
               end
            end
       end
       
       
       
         %% Combine the new absolute loop path to the x matrix
        xpath=zeros(m,n);
           for j=1:n
               for i=1:m
                   xpath(i,j)=x(i,j);
               end
           end
            for j=1:n
               for i=1:m
                  if x3(i,j)~=0
                   if x3(i,j)==inf                   % the element that left the basis
                       xpath(i,j)=0;
                   else
                       xpath(i,j)=abs(x3(i,j));      % the elements in the loop making them positive
                      
                   end
                  end
               end
            end 
            
            
            
            %% The objective function
   Z=0;
     for j=1:n
        for i=1:m
          if xpath(i,j)>0
             if xpath(i,j) == inf
                xpath(i,j) = 0;
             end
             Z=Z+c(i,j)*xpath(i,j);
          end
        end
     end
     
     %disp(xpath)
     %disp(Zopt)
end

