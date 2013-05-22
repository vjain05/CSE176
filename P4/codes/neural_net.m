%This program constructs the neural network based on the appropriate
%weights and runs the neural network on the given data set to produce
%output vectors

%x has input vectors, y has output vectors, and z has hidden unit values
%This models diagram in lecture slides '14-bp.pdf'
function [y,z,x]=neural_net(x,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max)%make x column vec
    %no hidden nodess
    if isempty(w_hidden)
        
        %implement equations (1) and (2) over all nodes in report.pdf
        x_sz=size(x);
        temp=repmat(w_output_bias,1,x_sz(2));
        net_out_vec=w_output'*x+temp;
        
            y=g_func(a_min,a_max,net_out_vec);
        
        z=[];
    
    %there are hidden nodes    
    else
        
        %implement equations (1) and (2) over all nodes in report.pdf
        x_sz=size(x);
        temp=repmat(w_hidden_bias,1,x_sz(2));
        net_hidden_vec=w_hidden'*x+temp;
        
            z=g_func(a_min,a_max,net_hidden_vec);
        
        z_sz=size(z);
        temp=repmat(w_output_bias,1,z_sz(2));
        net_out_vec=w_output'*z+temp;
        
            y=g_func(a_min,a_max,net_out_vec);
        
    end
    
end