%% Information
% Version: 1.0.0
% Date   : 2026-11-16

function [accTrain, accTest] = accurary(train, fit, test, fc)
accTrain = [];
accTest  = [];

if nargin == 2
    E_tr = train - fit;
    accTrain.mae = mean(abs(E_tr));
    accTrain.rmse = sqrt(mean(E_tr.^2));
    accTrain.mape = mean(abs(E_tr)./train);
    
elseif nargin == 4
    E_tr = train - fit;
    accTrain.mae  = round(mean(abs(E_tr)), 4);
    accTrain.rmse = round(sqrt(mean(E_tr.^2)), 4);
    accTrain.mape = round(mean(abs(E_tr)./train)*100, 2);
    
    E_ts = test - fc;
    accTest.mae  = round(mean(abs(E_ts)), 4);
    accTest.rmse = round(sqrt(mean(E_ts.^2)), 4);
    accTest.mape = round(mean(abs(E_ts)./test)*100, 2);
else
    error('The number of inputs can only be 2 or 4');
end

end

