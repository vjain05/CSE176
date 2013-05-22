%This implements equation (3) from report.pdf and applies to many inputs
function [out]=g_func(a_min,a_max,net)
    siz=size(net);
    out=a_min*ones(siz(1),siz(2))+(a_max-a_min)*(1./(ones(siz(1),siz(2))+exp(-net)));
end