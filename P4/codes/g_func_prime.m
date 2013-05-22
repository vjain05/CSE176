%This implements the derivative of g_func, applying to many inputs at once
%(see equation (3) from report.pdf)
function [out]=g_func_prime(a_min,a_max,net)
    siz=size(net);

    out=(g_func(a_min,a_max,net)-a_min*ones(siz(1),siz(2))).*(ones(siz(1),siz(2))-(1/(a_max-a_min))*(g_func(a_min,a_max,net)-a_min*ones(siz(1),siz(2))));

end