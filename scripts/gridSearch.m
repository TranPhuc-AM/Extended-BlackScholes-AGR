%% Information
% Version: 1.1.0
% Date   : 2026-11-16


%% Function
function grid = gridSearch()
rng(123)

% Phan tuy chinh
alpha_list = [0.01, 0.05, 0.1, 0.2];
P_list = [10000, 20000, 35000, 50000];
lambda_list = [10, 20, 35];

S = readmatrix(fullfile('..', 'data', 'agr.csv'));
def.H       = 50;

% Phan co dinh
def.N       = numel(S);
def.dt      = 1/def.N;
def.T       = def.N - def.H;

train = S(1 : def.T); 
test  = S(def.T+1 : def.N);

tbl = struct();
i = 1;
for p = P_list
    for  a = alpha_list
        for l = lambda_list
            tbl.P(i,1)      = p;
            tbl.ALPHA(i,1)  = a;
            tbl.LAMBDA(i,1) = l;
            
            def.P      = p;
            def.alpha  = a;
            def.lambda = l;
            
            [paths] = createSimulation(train, def);
            [slc_paths, slc_CEI] = selectPaths(train, paths, def);
            [fit, fc, ~] = forecast(slc_paths, slc_CEI, def);
            [~, accTest] = accurary(train, fit, test, fc);
            
            
            tbl.MAPE(i,1) = accTest.mape;
            tbl.RMSE(i,1) = accTest.rmse;
            tbl.MAE(i,1)  = accTest.mae;
            
            i = i+1;
        end
    end
end

result = struct2table(tbl);

grid = sortrows(result, {'MAPE', 'RMSE', 'MAE'}, ...
                   {'ascend', 'ascend', 'ascend'});
writetable(grid, fullfile('..', 'output', 'gridSearch.csv'));
end
