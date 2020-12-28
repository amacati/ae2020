t0 = 0;
t1 = 0;
t2 = 0;
for i = 1:1000000
    tic;
    A = [1/4 1/2 1/3]; 
    B = repmat(reshape(A,1,1,[]),100,120);
    t0 = t0 + toc;
    tic
    A=cat( 3 , 1/3 , 1/2 , 1/4 ); 
    B = repmat(A,10,10);
    t1 = t1 + toc;
    tic
    A = [1/4 1/2 1/4].'; % your data
    B = repmat(A,1,10,10); % use repmat to create a 3x10x10 copy
    C=permute(B,[3 2 1]); % permute to the correct order
    t2 = t2 + toc;
end
disp(t0)
disp(t1)
disp(t2)
%disp(B)