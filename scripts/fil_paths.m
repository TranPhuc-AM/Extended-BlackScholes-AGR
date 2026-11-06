function [slc_paths, slc_CEI] = fil_paths(par, paths, def)
%FIL_SIM Summary of this function goes here
%   Detailed explanation goes here

train = par.train;  
vali = par.vali;
P = def.P;
alpha = def.alpha;

n = numel(train);
v = numel(vali);

E    = vali(:) - paths(n+1:n+v,:);
ME   = abs(mean(E,1));
MAE  = mean(abs(E),1);
RMSE = sqrt(mean(E.^2,1));
CEI  = 0.15*ME + 0.3*MAE + 0.55*RMSE;

K = max(1, round(P*alpha));

[~, idx] = sort(CEI, 'ascend');

slc_paths = paths(:, idx(1:K));
slc_CEI   = CEI(idx(1:K));
end

