function [ outputa ] = demodulate2( r )
%DEMODULATE2 此处显示有关此函数的摘要
%   此处显示详细说明
t1 = double(r >= 0.5);
t2 = double(r <= -0.5);
t3 = double(r < 0.5) - t2;
t4 = double(r > -0.5) - t1;
outputa = abs((t3 + t4) / 2 - 1) - 2*t2;
end

