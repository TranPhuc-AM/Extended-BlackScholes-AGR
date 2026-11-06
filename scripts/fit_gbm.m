function coef = fit_gbm(train, def)
dt     = def.dt; 
lambda = def.lambda;

x = log(train(:));
M = zeros(size(x)); 
M(1) = x(1);

for k = 2:numel(x)
    M(k) = exp(-lambda*dt)*M(k-1) + lambda*x(k)*dt;
end
Y = x - M;

r = diff(x)/dt;
p = polyfit(Y(1:end-1), r, 1);          % r = a - kappa*Y

coef.kappa = -p(1);
coef.sigma = std(diff(x))/sqrt(dt);
coef.mu    = p(2) + 0.5*coef.sigma^2;
coef.a     = p(2);
end