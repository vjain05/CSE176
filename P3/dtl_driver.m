%This program makes a decision tree on a given dataset by executing the ID3
%algorithm, which is called in ‘ID3_sample.m.’ In order to successfully 
%execute the ID3 algorithm, the algorithm calculates the entropy and 
%information gain of a given subset of the dataset (as seen in 
%‘entropy_func.m’). In the end, the program displays the learned decision 
%tree through the function ‘print_dtree.m.’ 

%The main program takes in a configuration file, a training set data file, 
%and a test set data file and outputs the results of the algorithm in a 
%results text file. Before running the program, the user must make sure 
%that ‘dtl_driver.m’, ‘entropy_func.m’, ‘ID3_sample.m’, ‘print_dtree.m’, the 
%configuration file, the training data file, and the test data file are in 
%the same directory. 

%Take in the parameters from the configuration file
cfg_file=input('Enter configuration file name (in this directory) \n','s');
fid = fopen(cfg_file,'r');
d_in=fscanf(fid,'%d', (1));%dimensionality of input vectors
n_train=fscanf(fid,'%d',(1));%number of training examples
train_set_filename=fscanf(fid,'%s',(1));
n_test=fscanf(fid,'%d',(1));%number of test examples
test_set_filename=fscanf(fid,'%s',(1));
output_filename=fscanf(fid,'%s',(1));%file to output results to
fclose(fid); 

%make the structs for the training and test pattern sets, just like in
%programming assignment 1
train_pattern_set=struct('input_vecs',zeros(d_in,n_train),'output_vecs',zeros(1,n_train),'ordering_seq',zeros(1,n_train),'dimen_outpt',1,'dimen_inpt',d_in,'num_pattrns',n_train);
test_pattern_set=struct('input_vecs',zeros(d_in,n_test),'output_vecs',zeros(1,n_test),'ordering_seq',zeros(1,n_test),'dimen_outpt',1,'dimen_inpt',d_in,'num_pattrns',n_test);

fid = fopen(train_set_filename,'r');

%load the training pattern set's input and output vectors from the file
%into arr.
arr=fscanf(fid,'%f',[d_in+1 n_train]);%each example is a column vector

fclose(fid);

%load the training pattern set's input vectors
train_pattern_set.input_vecs=arr(1:d_in, :);

%load the training pattern set's output's vectors
train_pattern_set.output_vecs=arr(d_in+1:d_in+1, :);

fid = fopen(test_set_filename,'r');

%load the test pattern set's input and output vectors into arr2
arr2=fscanf(fid,'%f',[d_in+1 n_test]);%each example is a column vector

fclose(fid);

%load the test pattern set's input vectors
test_pattern_set.input_vecs=arr2(1:d_in, :);

%load the test pattern set's output vectors
test_pattern_set.output_vecs=arr2(d_in+1:d_in+1, :);

attribute_list=1:d_in;%keep track of the list of attributes
example_list=arr;
parent_index=1;%start off at root index of decision tree
decision_tree=struct('child',[],'type',[],'value',[]);%define structure for 
%decision tree, and assume there are 2 children for each ATTRIBUTE node and
%no children for a LABEL node
%Type can be ATTRIBUTE or LABEL, child gives the integer address of the
%child node, and value can give label value or the attribute number being
%analyzed

%The tree structure is expressed as an array of structs. We use the
%integers in 'child' of a given node to reference to the appropriate child
%node.

%run ID3 algorithm to build decision tree
decision_tree=ID3_sample(decision_tree,parent_index,example_list,attribute_list);

test_list=arr2;%use test examples with its input and output vectors
d_tree_addr=1;%start off at root index of decision tree
attr_to_test=-1;%attribute to examine as instructed by decision tree
decisions=zeros(1,n_test);%list of algorithm's decisions on test input 
%vectors

%use learned decision tree to make decisions
for j=1:n_test
example2compare=test_list(:,j);
    d_tree_addr=1;
    while strcmp(decision_tree(d_tree_addr).type,'LABEL')~=1
        attr_to_test=decision_tree(d_tree_addr).value;
        if example2compare(attr_to_test)==0
            d_tree_addr=decision_tree(d_tree_addr).child(1);
        elseif example2compare(attr_to_test)==1
            d_tree_addr=decision_tree(d_tree_addr).child(2);
        end
    end
decisions(j)=decision_tree(d_tree_addr).value;
end

%output learned decision tree
fid = fopen(output_filename', 'wt'); % Open for writing
fprintf(fid,'THE FOLLOWING DECISION TREE WAS LEARNED FROM EXAMPLES:\n\n');
[something]=print_dtree(decision_tree,1,'',fid);
fprintf(fid,'\n\n');

%output performance on test examples from learned decision tree
fprintf(fid,'TESTING SET PERFORMANCE:\n\n');
sse=(decisions-test_list(end,:)).^2;%sum squared error between algorithm's 
%outputs and actual test outputs, given as a vector of error values

results=[test_pattern_set.input_vecs' decisions' test_pattern_set.output_vecs' sse'];

for i=1:size(results,1)
        fprintf(fid, '%f\t ', results(i,:));
        fprintf(fid, '\n');
end
fclose(fid);