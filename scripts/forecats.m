function [fit_tr, fit_va, fc] = forecats(slc_paths, slc_CEI, n)
%WEIGHT Summary of this function goes here
%   Detailed explanation goes here

T = n.T;
V = n.V;
H = n.H;

z = (slc_CEI - min(slc_CEI)) / (max(slc_CEI)-min(slc_CEI) + 1e-08);
weights = exp(-z);  
weights = weights/sum(weights);

final = sum(slc_paths.*weights, 2);
fit_tr = final(1 : T);
fit_va = final(T+1 : T+V);
fc     = final(T+V+1 : T+V+H);
end