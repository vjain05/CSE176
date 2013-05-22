%This implements the backpropogation algorithm along with adding momentum
function [w_output,delta_w_output,w_hidden,delta_w_hidden,w_output_bias,delta_w_output_bias,w_hidden_bias,delta_w_hidden_bias]=backpropogation(a_min,a_max,w_output,delta_w_output,w_hidden,delta_w_hidden,w_output_bias,delta_w_output_bias,w_hidden_bias,delta_w_hidden_bias,x,y,z,t,gamma,alpha,eta)

    %no hidden units
    if isempty(w_hidden)
        
        if size(w_output,2)==1
        %implement equation (22) in report.pdf for all weights
        t_minus_kp_y=t-y;
        siz_x=size(x);
        nets_kp=[w_output' w_output_bias]*[x;ones(1,siz_x(2))];
        g_p_nets_kp=g_func_linear_prime(nets_kp);
        temp=t_minus_kp_y.*g_p_nets_kp*[x' ones(siz_x(2),1)];
        neg_delE_del_wki=temp-gamma*[w_output' w_output_bias];
        
        else
            %implement equation (22) in report.pdf for all weights
        t_minus_kp_y=t-y;
        siz_x=size(x);
        nets_kp=[w_output' w_output_bias]*[x;ones(1,siz_x(2))];
        g_p_nets_kp=[g_func_prime(0,1,nets_kp(1:end-1,:));g_func_linear_prime(nets_kp(end,:))];
        temp=t_minus_kp_y.*g_p_nets_kp*[x' ones(siz_x(2),1)];
        neg_delE_del_wki=temp-gamma*[w_output' w_output_bias];
        
        end
        w_hidden=[];
        w_hidden_bias=[];
        delta_w_hidden=[];
        delta_w_hidden_bias=[];
        
        %implement momentum
        delta_w_output=eta*neg_delE_del_wki(:,1:end-1)+alpha*delta_w_output;
        delta_w_output_bias=eta*neg_delE_del_wki(:,end)+alpha*delta_w_output_bias;
        
        %update weights
        w_output=w_output+delta_w_output';
        w_output_bias=w_output_bias+delta_w_output_bias;
    %there are hidden units    
    else
        if size(w_output,2)==1
        %implements equation (14) in report.pdf for all output weights
        t_minus_kp_y=t-y;
        siz_z=size(z);
        nets_kp=[w_output' w_output_bias]*[z;ones(1,siz_z(2))];
        g_p_nets_kp=g_func_linear_prime(nets_kp);%edit here plz
        temp=t_minus_kp_y.*g_p_nets_kp*[z' ones(siz_z(2),1)];
        neg_delE_del_wkj=temp-gamma*[w_output' w_output_bias];
        
        %implements equation (19) in report.pdf for all hidden weights
        temp=t_minus_kp_y.*g_p_nets_kp;
        siz_x=size(x);
        nets_jp=[w_hidden' w_hidden_bias]*[x; ones(1,siz_x(2))];
        g_p_nets_jp=g_func_prime(a_min,a_max,nets_jp);
        temp=(temp'*w_output')'.*g_p_nets_jp*[x' ones(siz_x(2),1)];
        neg_delE_del_wji=temp-gamma*[w_hidden' w_hidden_bias];
        else
            %implements equation (14) in report.pdf for all output weights
        t_minus_kp_y=t-y;
        siz_z=size(z);
        nets_kp=[w_output' w_output_bias]*[z;ones(1,siz_z(2))];

        g_p_nets_kp=[g_func_prime(0,1,nets_kp(1:end-1,:));g_func_linear_prime(nets_kp(end,:))];
        temp=t_minus_kp_y.*g_p_nets_kp*[z' ones(siz_z(2),1)];
        neg_delE_del_wkj=temp-gamma*[w_output' w_output_bias];
        
        %implements equation (19) in report.pdf for all hidden weights
        temp=t_minus_kp_y.*g_p_nets_kp;
        siz_x=size(x);
        nets_jp=[w_hidden' w_hidden_bias]*[x; ones(1,siz_x(2))];
        g_p_nets_jp=g_func_prime(a_min,a_max,nets_jp);
        temp=(temp'*w_output')'.*g_p_nets_jp*[x' ones(siz_x(2),1)];
        neg_delE_del_wji=temp-gamma*[w_hidden' w_hidden_bias];
        end
        %implement momentum
        delta_w_output=eta*neg_delE_del_wkj(:,1:end-1)+alpha*delta_w_output;
        delta_w_output_bias=eta*neg_delE_del_wkj(:,end)+alpha*delta_w_output_bias;
        
        delta_w_hidden=eta*neg_delE_del_wji(:,1:end-1)+alpha*delta_w_hidden;
        delta_w_hidden_bias=eta*neg_delE_del_wji(:,end)+alpha*delta_w_hidden_bias;
        
        %update weights
        w_output=w_output+delta_w_output';
        w_output_bias=w_output_bias+delta_w_output_bias;
        
        w_hidden=w_hidden+delta_w_hidden';
        w_hidden_bias=w_hidden_bias+delta_w_hidden_bias; 
    end   
end