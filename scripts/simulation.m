function P_out = simulation(train, n, def)
dt = def.dt; 
P = def.P; 
lambda = def.lambda;
coef = fit_gbm(train, def);
sigma = coef.sigma;
kappa = coef.kappa;
a = coef.a;

Zh = randn(n.N-1, P/2);  
Z = [Zh, -Zh];

X = zeros(n.N, P);  
X(1,:) = log(train(1));
M = X(1,:);
for k = 1:n.N-1
    Y = X(k,:) - M;
    X(k+1,:) = X(k,:) + (a - kappa*Y)*dt + sigma*sqrt(dt)*Z(k,:);
    M = exp(-lambda*dt)*M + lambda*X(k+1,:)*dt;
end
P_out = exp(X);
end