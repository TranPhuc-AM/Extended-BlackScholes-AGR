function [par, n] = split(S, def)
%SLIPT Summary of this function goes here
%   Detailed explanation goes here

N = numel(S);
n_test = floor(N*def.testratio);
n_vali = floor(N*def.valiratio);
n_train = N - n_vali - n_test;

par.org   = S;
par.train = S(1:n_train);
par.vali  = S(n_train+1: n_train+n_vali);
par.test  = S(n_train+n_vali+1:end);

n.N = N;
n.T = numel(par.train);
n.V = numel(par.vali);
n.H = numel(par.test);
end