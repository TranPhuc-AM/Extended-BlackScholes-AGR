%% Information
% Version: 1.0.2
% Date   : 2026-11-15

%% Function
function [slc_paths, slc_CEI] = selectPaths(train, paths, def)
P     = def.P; 
alpha = def.alpha;
T     = def.T;

E    = train(:) - paths(1:T,:);
ME   = abs(mean(E,1));
MAE  = mean(abs(E),1);
RMSE = sqrt(mean(E.^2,1));
CEI  = 0.15*ME + 0.3*MAE + 0.55*RMSE;

K = max(1, round(P*alpha));

[~, idx] = sort(CEI, 'ascend');

slc_paths = paths(:, idx(1:K));
slc_CEI   = CEI(idx(1:K));
end
