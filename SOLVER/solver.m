m = input('Enter the number of rows : ');
n = input('Enter the number of columns : ');
c = zeros(m,n);
    for i=1:m
        for j=1:n
            c(i,j)=input('Enter the element : ');
        end
    end
c = reshape(c,m,n); 
disp('Enter the supply : ')
s=zeros(m,1);
    for i=1:m
        s(i,1)=input('Enter the element : ');
    end
disp('Enter the demand : ')
d=zeros(1,n);
    for i=1:n
        d(1,i)=input('Enter the element : ');
    end
ZVAM = 0;
degen = 0;
countx = 0;

% sum demand and supply
sumd = sum(d);
sums = sum(s);
% Checking balance of demand and supply
if sumd==sums
    disp('It is a balanced transportation problem')
else
    disp('It is not a balanced transportation problem');
    [m,n,s,d,c] = balancing(m,n,s,d,c,sums,sumd);
end

numbasic=m+n-1;
x1 = zeros(m,n);
c1=zeros(m,n);
s1=zeros(m,1);
d1=zeros(1,n);
x=zeros(m,n);
    
%Duplication
for j=1:n
    for i=1:m
        c1(i,j)=c(i,j);
    end
end
for i=1:m
    s1(i)=s(i);
end
for j=1:n
    d1(j)=d(j);
end

% VAM function call
[ZVAM,x] = VAM( m,n,c,c1,d1,s1,x );
disp('VAM value')
disp(x)
disp(ZVAM)
% degeneracy check function call
[x, x1] = degeneracy_check(m,n,x,ZVAM,c);
%disp(x);
%disp(x);
[x, ZVAM] = MODI( m,n,x,c,sums );
fprintf('The optimum solution value : %d \n', ZVAM)
disp('The allocation matrix :')
disp(x)