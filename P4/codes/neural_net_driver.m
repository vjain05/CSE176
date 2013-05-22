%The program was run in MATLAB. The user runs the main program 
%'neural\_net\_driver.m' by typing 'neural\_net\_driver' in the MATLAB 
%console window. The program constructs, learns, and runs a neural network 
%on a given dataset. The neural network is constructed and run in 
%'neural\_net.m.' The program 'neural\_net.m' makes a call to 'g\_func.m,' 
%which computes the function representing the output function of a given 
%perceptron in the network. The neural network is 'learned' through the 
%backpropogation algorithm, which is called in 'backpropogation.m.' The 
%program 'backpropogation.m' makes a call to 'g\_func\_prime.m,' which 
%computes the function representing the derivative of 'g\_func.m.' \\

%The program takes in a configuration file, a training set data file, and a
%testing set datafile, and the program outputs the sum-squared errors with 
%respect to the training data and testing data over the learning 
%iterations. In the end the program also outputs the learned output vectors
%over the training data set and the testing data set. In the neural 
%network, the input vectors are fed into a network of perceptrons, which 
%produce the output vectors.

clear all;

%Take in the parameters from the configuration file
cfg_file=input('Enter configuration file name (in this directory) \n','s');
fid = fopen(cfg_file,'r');
d_in=fscanf(fid,'%d', (1));%dimensionality of input vectors
d_out=fscanf(fid,'%d',(1));%dimensionality of output vectors
d_hid=fscanf(fid,'%d',(1));%dimensionality of hidden units
a_min=fscanf(fid,'%f',(1));%a_min offset for g function
a_max=fscanf(fid,'%f',(1));%a_max offset for g function
w_range=fscanf(fid,'%f',(1));%range of the network weights
eta=fscanf(fid,'%f',(1));%learning rate
alpha=fscanf(fid,'%f',(1));%momentum term as seen in equation 4.18 of Tom Mitchell's Machine Learning
gamma=fscanf(fid,'%f',(1));%added penalty term to SSE function
wt_update_method=fscanf(fid,'%s',(1));%Batch vs Online learning
T_total=fscanf(fid,'%d',(1));%# total epochs to learn over
T_report=fscanf(fid,'%d',(1));% report SSE values at these epochs

n_train=fscanf(fid,'%d',(1));%number of training examples
train_set_filename=fscanf(fid,'%s',(1));
n_test=fscanf(fid,'%d',(1));%number of test examples
test_set_filename=fscanf(fid,'%s',(1));
output_filename=fscanf(fid,'%s',(1));%file to output results to
fclose(fid); 

%make the structs for the training and test pattern sets, just like in
%programming assignment 1
train_pattern_set=struct('input_vecs',zeros(d_in,n_train),'output_vecs',zeros(d_out,n_train),'ordering_seq',zeros(1,n_train),'dimen_outpt',d_out,'dimen_inpt',d_in,'num_pattrns',n_train);
test_pattern_set=struct('input_vecs',zeros(d_in,n_test),'output_vecs',zeros(d_out,n_test),'ordering_seq',zeros(1,n_test),'dimen_outpt',d_out,'dimen_inpt',d_in,'num_pattrns',n_test);

fid = fopen(train_set_filename,'r');

%load the training pattern set's input and output vectors from the file
%into arr.
arr=fscanf(fid,'%f',[d_in+d_out n_train]);

fclose(fid);

%load the training pattern set's input vectors
train_pattern_set.input_vecs=arr(1:d_in, :);

%load the training pattern set's output's vectors
train_pattern_set.output_vecs=arr(d_in+1:d_in+d_out, :);

fid = fopen(test_set_filename,'r');

%load the test pattern set's input and output vectors into arr2
arr2=fscanf(fid,'%f',[d_in+d_out n_test]);

fclose(fid);

%load the test pattern set's input vectors
test_pattern_set.input_vecs=arr2(1:d_in, :);

%load the test pattern set's output vectors
test_pattern_set.output_vecs=arr2(d_in+1:d_in+d_out, :);

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


fid = fopen(output_filename', 'wt'); % Open for writing
fprintf(fid,'TRAINING ARTIFICIAL NEURAL NETWORK ...\n');

%Batch learning
if wt_update_method(1)=='B'    
    for i=1:T_total
        
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
        
        if mod(i,T_report)==0
            fprintf(fid,'EPOCH \t%d:\tTRAIN SSE=\t%f;\tTEST SSE=\t%f\n',i,err_train,err_test);
        end
    end
%Online learning
else
    for i=1:T_total
    
        %run neural network over training and test data
        [y,z,x]=neural_net(s,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);
        [y_test,z_test,x_test]=neural_net(s_test,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);
        
        %produce error values
        err_train=err(y,t,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
        err_test=err(y_test,t_test,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
        
        %use network to determine delta w,
        %delta_w(t)=delta_w(t)+eta*network_partial_derivative

        %update w with delta w, wki=wki+delta_w
        
        %Do online learning over all training examples to complete one
        %epoch
        clear x;clear y;clear z;
        for indx=1:siz_s(2)
            [y,z,x]=neural_net(s(:,indx),w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);
            [w_output,delta_w_output,w_hidden,delta_w_hidden,w_output_bias,delta_w_output_bias,w_hidden_bias,delta_w_hidden_bias]=backpropogation(a_min,a_max,w_output,delta_w_output,w_hidden,delta_w_hidden,w_output_bias,delta_w_output_bias,w_hidden_bias,delta_w_hidden_bias,x,y,z,t(:,indx),gamma,alpha,eta);
        end
        
        
        if mod(i,T_report)==0
            fprintf(fid,'EPOCH \t%d:\tTRAIN SSE=\t%f;\tTEST SSE=\t%f\n',i,err_train,err_test);
        end
    end
end
fprintf(fid,'TRAINING IS COMPLETE.\n\n');

%results over the training and test data set based on final weigh values
[y,z,x]=neural_net(s,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);
[y_test,z_test,x_test]=neural_net(s_test,w_hidden,w_output,w_hidden_bias,w_output_bias,a_min,a_max);

err_train=err(y,t,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
err_test=err(y_test,t_test,w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
err_train_vec=zeros(1,n_train);
err_test_vec=zeros(1,n_test);

for i=1:n_train
    error_train_vec(i)=err(y(:,i),t(:,i),w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
end
for i=1:n_test
    error_test_vec(i)=err(y_test(:,i),t_test(:,i),w_output,w_output_bias,w_hidden,w_hidden_bias,gamma);
end

fprintf(fid,'FINAL NETWORK PERFORMANCE ON TRAINING EXAMPLES:\n\n');
results=[s' y' t' error_train_vec'];
for i=1:size(results,1)
        fprintf(fid,'%f\t ', results(i,:));
        fprintf(fid,'\n');
end

fprintf(fid,'\nFINAL TRAINING SET TOTAL SSE=\t%f\n\n',err_train);

fprintf(fid,'FINAL NETWORK PERFORMANCE ON TESTING EXAMPLES:\n\n');
results_test=[s_test' y_test' t_test' error_test_vec'];
for i=1:size(results_test,1)
        fprintf(fid,'%f\t ', results(i,:));
        fprintf(fid,'\n');
end

fprintf(fid,'\nFINAL TESTING SET TOTAL SSE=\t%f\n\n',err_test);

fclose(fid);


