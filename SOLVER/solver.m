% m = input('Enter the number of rows : ');
% n = input('Enter the number of columns : ');
% disp('COST MATRIX')
% c = zeros(m,n);
%     for i=1:m
%         for j=1:n
%             c(i,j)=input('Enter the cost : ');
%         end
%     end
% disp('SUPPLY MATRIX')
% s=zeros(m,1);
%     for i=1:m
%         s(i,1)=input('Enter the suply value : ');
%     end
% disp('DEMAND MATRIX')
% d=zeros(1,n);
%     for i=1:n
%         d(1,i)=input('Enter the demand value : ');
%     end

c=[4 6 8 8;
   6 8 6 7;
   5 7 6 8];
[m,n]=size(c);
s=[40;60;50];
d=[20 30 50 50];

Z = 0;
degen_flag = 0;
basic_var = 0;

% sum demand and supply
sum_d = sum(d);
sum_s = sum(s);
% Checking balance of demand and supply
if sum_d==sum_s
    disp('It is a balanced transportation problem')
else
    disp('It is not a balanced transportation problem');
    [m,n,s,d,c] = balancing(m,n,s,d,c,sum_s,sum_d);
end

numbasic=m+n-1;
x_dup = zeros(m,n);
c_dup=zeros(m,n);
s_dup=zeros(m,1);
d_dup=zeros(1,n);
x=zeros(m,n);
    
%Duplication
for j=1:n
    for i=1:m
        c_dup(i,j)=c(i,j);
    end
end
for i=1:m
    s_dup(i)=s(i);
end
for j=1:n
    d_dup(j)=d(j);
end

% VAM function call
[Z,x,degen_flag] = VAM( m,n,c,c_dup,d_dup,s_dup,x );

%disp('VAM value')
%disp(x)
%disp(Z)

% degeneracy check function call

degeneracy_check(m,n,x,Z,degen_flag);

%disp(x);
%disp(x);

[x, Z, alt_x,alt_z,alternate_opt_flag] = MODI( m,n,x,c,sum_s );

disp(' ')
disp('--- SOLUTIONS ---')
disp(' ')
fprintf('The optimum solution value : %d \n', Z)
disp('--- The allocation matrix : ---')
disp(x)

if degen_flag == 1
    disp('--- NOTE : inf here refers to Epsilon -> a negligable amount of allocation ---')
end

if alternate_opt_flag == 1
    disp('--- The alternate allocation matrix ---')
    disp(alt_x)
    disp('The optimum value of the alternate allocation matrix :')
    disp(alt_z)
end