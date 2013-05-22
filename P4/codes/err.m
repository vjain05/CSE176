%This implements the error equation (4) in report.pdf
function [out]=err(y,t,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma)
    out=.5*norm(t-y,'fro')^2+.5*gamma*norm(w_output,'fro')^2+.5*gamma*norm(w_output_bias,'fro')^2+.5*gamma*norm(w_hidden,'fro')^2+.5*gamma*norm(w_hidden_bias,'fro')^2;
end