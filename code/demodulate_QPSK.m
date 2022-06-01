function [ out ] = demodulate_QPSK( aa, no )
%DEMDULATE_QPSK 此处显示有关此函数的摘要
%   此处显示详细说明
%   aa 序列
%   sigma 噪声标准差
out = aa + no;
for ii = 1:length(out)
    if out(ii) >= 0.5
        out(ii) = 1;
    else if out(ii) <= -0.5
            out(ii) = -1;
        else
            out(ii) = 0;
        end
    end
end

if out == [1;0]
   out = [1;0];
else if out == [0;1]
   out = [0;0];
   else if out == [-1;0]
   out = [0;1];
       else
   out = [1;1];           
       end
   end
end


end

