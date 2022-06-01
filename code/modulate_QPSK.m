function [ output ] = modulate_QPSK( aa )
%MODULATE_QPSK 此处显示有关此函数的摘要
%   此处显示详细说明
output = [0;0];
if aa == [1;0]
   output = [1;0];
else if aa == [0;0]
   output = [0;1];
   else if aa == [0;1]
   output = [-1;0];
       else
   output = [0;-1];           
       end
   end
end

end

