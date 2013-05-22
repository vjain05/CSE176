clear all;

partition=1;
discretize=100/partition;%discretize is integer
dimen=385;

d_in=dimen-1;
if partition==1
    d_out=1;
else
    d_out=partition+1;
end
d_hid=40;
a_min=-.5;%a_min offset for g function
a_max=.5;%a_max offset for g function
w_range=.5;%range of the network weights
eta=.000012;%learning rate
alpha=0.0000001;%momentum term as seen in equation 4.18 of Tom Mitchell's Machine Learning
gamma=0.0000000001;%added penalty term to SSE function
T_total=100;%# total epochs to learn over
T_report=2;%report error every partition of iterations
n_train=40000;
n_test=10000;
num_vecs=53500;

train_pattern_set=struct('input_vecs',zeros(d_in,n_train),'output_vecs',zeros(d_out,n_train),'ordering_seq',zeros(1,n_train),'dimen_outpt',d_out,'dimen_inpt',d_in,'num_pattrns',n_train);
test_pattern_set=struct('input_vecs',zeros(d_in,n_test),'output_vecs',zeros(d_out,n_test),'ordering_seq',zeros(1,n_test),'dimen_outpt',d_out,'dimen_inpt',d_in,'num_pattrns',n_test);

arr=csvread('slice_localization_data_use.csv');

arr=arr(1:n_train+n_test,2:end);

b=mod(arr(:,end),discretize);
a=(arr(:,end)-b)/discretize;
if partition>1
    c=zeros(size(arr,1),partition+1);
    for i=1:size(arr,1)
        c(i,a(i)+1)=1;
    end
else
    c=zeros(size(arr,1),partition);
end
c(:,end)=b;
arr=[arr(:,1:end-1) c];

for i=1:1
    test_pattern_set.input_vecs=arr((n_test*(i-1)+1):n_test*i,1:d_in)';
    test_pattern_set.output_vecs=arr((n_test*(i-1)+1):n_test*i,d_in+1:d_in+d_out)';
    train_pattern_set.input_vecs=[arr(1:(n_test*(i-1)),1:d_in); arr((n_test*(i)+1):end,1:d_in)]';
    train_pattern_set.output_vecs=[arr(1:(n_test*(i-1)),d_in+1:d_in+d_out); arr((n_test*(i)+1):end,d_in+1:d_in+d_out)]';
    %no hidden units

    if d_hid>0
        w_hidden= -w_range/2+ w_range*rand(d_in,d_hid);%generate d_in by d_out matrix of random values
        w_output= -w_range/2+ w_range*rand(d_hid,d_out);

        w_hidden_bias=-w_range/2+ w_range*rand(d_hid,1);
        w_output_bias=-w_range/2+ w_range*rand(d_out,1);
    
        delta_w_hidden=zeros(d_in,d_hid)';
        delta_w_output=zeros(d_hid,d_out)';
        delta_w_hidden_bias=zeros(d_hid,1);
        delta_w_output_bias=zeros(d_out,1);
    %hidden units exist
    else
        w_hidden=[];
        w_output=-w_range/2+ w_range*rand(d_in,d_out);

        w_hidden_bias=[];
        w_output_bias=-w_range/2+ w_range*rand(d_out,1);
    
        delta_w_hidden=[];
        delta_w_output=zeros(d_in,d_out)';
        delta_w_hidden_bias=[];
        delta_w_output_bias=zeros(d_out,1);
    end

    t=train_pattern_set.output_vecs;
    t_test=test_pattern_set.output_vecs;

    s=train_pattern_set.input_vecs;
    s_test=test_pattern_set.input_vecs;
    siz_s=size(s);
    alpha=0.000001;
    fprintf('Train iteration %d\n',i);
    for j=1:T_total
        
        %run neural network over training and test data
        [y,z,x]=neural_net(s,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);
        [y_test,z_test,x_test]=neural_net(s_test,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);
        
        %produce error values
        err_train=err(y,t,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
        err_test=err(y_test,t_test,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);   
       

        %use network to determine delta w,
        %delta_w(t)=delta_w(t)+eta*network_partial_derivative

        %update w with delta w, wkj=wkj+delta_w
        %update w with delta w, wji=wji+delta_w
        [w_output,delta_w_output,w_hidden,delta_w_hidden,w_output_bias,delta_w_output_bias,w_hidden_bias,delta_w_hidden_bias]=backpropogation(a_min,a_max,w_output,delta_w_output,w_hidden,delta_w_hidden,w_output_bias,delta_w_output_bias,w_hidden_bias,delta_w_hidden_bias,x,y,z,t,gamma,alpha,eta);
        
        if mod(j,T_report)==0
            fprintf('EPOCH \t%d:\tTRAIN SSE=\t%f;\tTEST SSE=\t%f\n',j,err_train,err_test);
        end
        alpha=alpha*1.05;
    end
    fprintf('\n');
    err_avg_train(i)=err_train;
    err_avg_test(i)=err_test;
end