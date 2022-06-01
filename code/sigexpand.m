function [ out ] = sigexpand( d, M )
%SIGEXPAND 此处显示有关此函数的摘要
%   此处显示详细说明
N = length(d);
out = zeros(M, N);
out(1,:) = d;
out = reshape(out, 1, M*N);
end

