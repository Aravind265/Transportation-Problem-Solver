function [ x,ZVAM ] = MODI(m,n,x,c,sums)
    disp('Starting Modified distribution method ...')
    iterationOpt=0;
 for q=1:n*m
     iterationOpt=iterationOpt+1;
% The Modified distribution method
  %% Construct the u-v variables
    udual=zeros(m,1);
    vdual=zeros(1,n);
    for i=1:m
        udual(i)=inf;
    end
    for j=1:n
        vdual(j)=inf;
    end
    udual(1)=0;
   for i=1:1
       for j=1:n
           if x(i,j)>0 && udual(i)<inf
               
               vdual(j)=c(i,j)-udual(i);
           end
       end
   end
   for j=1:1
       for i=1:m
           if x(i,j)>0
               iu=i;
              if udual(iu)~=inf
               vdual(j)=c(i,j)-udual(iu);
              else
                  if vdual(j)~=inf
                      udual(iu)=c(i,j)-vdual(j);
                  end
              end
           end
       end
   end
 for k=1:m*n
  for i=1:m
       if udual(i)~=inf
          iu=i;
          for j=1:n
            if x(iu,j)>0 && udual(iu)<inf
             
             vdual(j)=c(iu,j)-udual(iu);
            end
          end
       end
  end
 for j=1:n
     if vdual(j)~=inf
         jv=j;
         for i=1:m
             if x(i,jv)>0 && vdual(jv)<inf
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
 if (countu==m) && (countv==n)
     break
 end
 end
 %disp(m)
 %disp(n)
 %disp(countu)
 %disp(countv)
 %disp(udual)
 %disp(vdual)
 %% Find the non-basic cells
  unx=zeros(m,n);
  for j=1:n
      for i=1:m
          if x(i,j)==0 
              unx(i,j)=udual(i)+vdual(j)-c(i,j);
              if unx(i,j) == 0
                  disp('Alternate optimum solution exists')
              end
          end
      end
  end
  %% Search maximum positive of udual+vdual-c(i,j) to reach a new basic variable
  maxunx=0;
  for j=1:n
      for i=1:m
          if unx(i,j)>=maxunx
              maxunx=unx(i,j);
              imax=i;
              jmax=j;
          end
      end
  end
    %% The objective function value
     Z=0;
       for j=1:n
           for i=1:m
               if x(i,j)>0
                   Z=Z+x(i,j)*c(i,j);
               end
           end
       end
  iterationOpt=iterationOpt+1;
  %% Control loop
        if maxunx==0
           
            break;
        else
           
        end
  %% Entering a new basic variable add into the basic variable matrix
   x1=zeros(m+1,n+1);
   x2=zeros(m+1,n+1);
     % Construct the equivalent basic variable matrix
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
  for i=1:m
      iterationloop=iterationloop+1;
    for i=1:m
      if x2(i,n+1)==1 
          ieliminate=i;
         for j=1:n
             if x2(ieliminate,j)<inf &&   x2(ieliminate,j)>0
                 jeliminate=j;
                x2(ieliminate,jeliminate)=0;% Eliminate the basic variable on row
                x2(ieliminate,n+1)=x2(ieliminate,n+1)-1; % decrease the number of the basic variable on row one unit
                x2(m+1,jeliminate)=x2(m+1,jeliminate)-1; % decrease the number of the basic variable on column one unit
                      
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
                x3(imax,jmax)=small;
               
               if x3(i,j)~=0
                  if x3(i,j)<0
                    x3(i,j)=(x3(i,j))+small;
                      
                      if x3(i,j)==0
                          x3(i,j)=inf;
                         
                            
                      end
                      
                else
                    if i~=imax && j~=jmax
                        x3(i,j)=x3(i,j)+small;
                       
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
                   if x3(i,j)==inf
                       xpath(i,j)=0;
                   else
                       xpath(i,j)=abs(x3(i,j));
                      
                   end
                  end
               end
            end 
            %% The objective function
   Zopt=0;
     for j=1:n
         for i=1:m
             if round(xpath(i,j))>0
              Zopt=Zopt+round(xpath(i,j))*c(i,j);
             end
         end
     end
     
     %% Check balance 
         sumbal=0;
         for j=1:n
             for i=1:m
                 if xpath(i,j)>0
                   
                    sumbal=sumbal+xpath(i,j);
                 end
             end
         end
             if sums==sumbal
                 %disp('Balance');
             else 
              
                 break;
             end
              %% Transfer x to xpath
               for j=1:n
                   for i=1:m
                       x(i,j)=xpath(i,j);
                   end
               end
               

 end
 ZVAM=0;
 for j=1:n
    for i=1:m
      if x(i,j)>0
         if x(i,j) == inf
            x(i,j) = 0;
         end
         ZVAM=ZVAM+c(i,j)*x(i,j);
      end
    end
 end
end

