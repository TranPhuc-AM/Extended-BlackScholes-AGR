function Eval()

clc; 
close;
rng(123);
%% Tham so mac dinh
def.valiratio = 0.2;
def.testratio = 0.2;
def.P = 50000;
def.dt = 1/245;
def.lambda = 10;
def.alpha = 0.01;

%% Du lieu
S = readmatrix(fullfile('..', 'data', 'agr.csv'));

%% Huan luyen
[par, n] = split(S, def);
train = par.train;
test = par.test;
vali = par.vali;


[paths] = simulation(train, n, def);
[slc_paths, slc_CEI] = fil_paths(par, paths, def);

%% Du bao
[fit_tr, fit_va, fc] = forecats(slc_paths, slc_CEI, n);

%% Do chinh xac

mae = mean(abs(vali-fit_va))*1000;
rmse = sqrt(mean((vali-fit_va).^2))*1000;
mape = mean(abs(vali-fit_va)./vali)*100;

fprintf('Validation\n')
fprintf('MAE  = %.4f\n',mae);
fprintf('RMSE = %.4f\n', rmse);
fprintf('MAPE = %.4f%%\n',mape);

fprintf('Test\n')
mae = mean(abs(test-fc))*1000;
rmse = sqrt(mean((test-fc).^2))*1000;
mape = mean(abs(test-fc)./test)*100;

fprintf('MAE  = %.4f\n',mae);
fprintf('RMSE = %.4f\n', rmse);
fprintf('MAPE = %.4f%%\n',mape);

% Ve do thi
T=n.T;V=n.V;H=n.H;
plot([1:T+V+H], S, '-b', 'LineWidth',1)
hold on
plot([1:T], fit_tr, 'r', 'LineWidth', 1)
plot([T+1:T+V], fit_va, '-k', 'LineWidth', 1)
plot([T+V+1:n.N], fc, '--g', 'LineWidth', 1)


x_fc = T+V+1:n.N;
q  = prctile(slc_paths(x_fc, :), [2.5 97.5], 2);        % H x 2
lo = q(:,1);
up = q(:,2);

fill([T+V+1:T+V+H fliplr(T+V+1:T+V+H)], ...
     [up' fliplr(lo')], ...
     [0.85 0.90 1], ...
     'EdgeColor', 'none', ...
     'FaceAlpha', 0.4);

hold off
legend('Actual', 'Fitted', 'Validation', 'Forecast', ...
    '95% CI', ...
    'Location', 'best');
xlabel('Thoi gian');
ylabel('Gia co phieu');
title('Ket qua du bao gia co phieu dua tren mo phong');
grid on;
figure(1)
end

