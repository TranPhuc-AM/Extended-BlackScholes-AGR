%% Information
% Version: 1.1.0
% Date   : 2026-11-15

%% Ham chinh
function [paths] = createSimulation(train, def)
% Tham so co dinh
dt     = def.dt; 
P      = def.P; 
lambda = def.lambda;
N      = def.N;
H      = def.H;

% Tinh cac tham so can thiet
[a, mu, sigma, kappa] = fit_gbm(train, def);
e  = exp(-lambda*dt);

% Tao so gia doi ngau
Zh = randn(N-1, P/2);  
Z  = [Zh, -Zh];

% Mo phong cac quy dao
X = zeros(N, P);  
X(1,:) = log(train(1));
M = X(1);

for k = 1:N-1
    Y = X(k,:) - M;
    X(k+1,:) = X(k,:) + (a - kappa*Y)*dt + sigma*sqrt(dt)*Z(k,:);
    M = e*M + (1-e)*X(k+1,:);
end
paths = exp(X);
end

%% Ham phu
function [a, mu, sigma, kappa] = fit_gbm(train, def)
% Tham so co dinh
dt     = def.dt; 
lambda = def.lambda;

% Tinh ln S_t va M_t
x = log(train(:));
M = zeros(size(x)); 
M(1) = x(1);
e = exp(-lambda*dt);

for k = 2:numel(x)
     M(k) = e*M(k-1) + (1-e)*x(k);
end

% Uoc luong a, mu, sigma va kappa
Y = x - M;
r = diff(x)/dt;
p = polyfit(Y(1:end-1), r, 1);          % r = a - kappa*Y

kappa = -p(1);
sigma = std(diff(x))/sqrt(dt);
mu    = p(2) + 0.5*sigma^2;
a     = p(2);
end
