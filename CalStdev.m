function ans = CalStdev(result)

rows = size(result,1);

for i = 1:rows,
   % ans(i) = BinomialStdev(result(i,1),result(i,2));
   ans(i) = BinomialSD(result(i,1),result(i,2));

end

function ans = BinomialSD(x,n)

ans = sqrt((x*(n-x))/(n*n*(n-1)));

function ans = BinomialStdev(x,n)

for i = 1:11
	p = (i-1)/10;
	dist(i) = Factorial(n)/(Factorial(x) * Factorial(n-x)) * p^x * (1-p)^(n-x);
end
ans = std(dist);

function ans = Factorial(n)

ans = 1;

for i = 1:n,
	ans = ans * i;
end

