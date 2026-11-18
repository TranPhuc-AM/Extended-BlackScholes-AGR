%% Information
% Version: 1.2.5
% Date   : 2026-11-16

%% Function
function [fit, fc, CI] = forecast(slc_paths, slc_CEI, def)

T     = def.T;
H     = def.H;
alpha = def.alpha;
P     = def.P;
tau   = alpha * log(P) * (log(P) - log(alpha));

z = (slc_CEI - min(slc_CEI)) / (max(slc_CEI)-min(slc_CEI) + 1e-08);
weight  = exp(-tau*z);  
weights = weight/sum(weight);

final = sum(slc_paths.*weights, 2);
fit = final(1 : T);
fc  = final(T+1 : T+H);

CI.no = [1:H]';
CI.fc = round(fc, 4);
q  = prctile(slc_paths(T+1:T+H, :), [2.5 97.5], 2);
CI.lo =  round(q(:,1), 4);
CI.up =  round(q(:,2), 4);

fc_paths = slc_paths(T+1:T+H, :);
CI.wlo = zeros(H,1);
CI.wup = zeros(H,1);

for k=1:H
    [x_sorted, idx] = sort(fc_paths(k,:), 'ascend');
    w_sorted = weights(idx);
    cw = cumsum(w_sorted);
    
    idx_lo = find(cw >= 0.025, 1, 'first'); % Vi tri phan tu dau tien cua cw >= 0.025 
    idx_up = find(cw >= 0.975, 1, 'first'); % Vi tri phan tu dau tien cua cw >= 0.975 

    CI.wlo(k) = round(x_sorted(idx_lo), 4);
    CI.wup(k) = round(x_sorted(idx_up), 4);
end

end
