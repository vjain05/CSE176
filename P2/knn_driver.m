%The program implements the k-nearest-neighbor algorithm using weighted and
%un-weighted averages (with Euclidean and angular distances). It takes in 
%training and a testing pattern set and makes output data of the testing 
%pattern set (based on the training pattern set). This output data is the 
%program’s predictions of the test pattern set’s output vectors, which is 
%compared to the set’s actual output vectors. 

cfg_file=input('Enter configuration file name (in this directory) \n','s');
fid = fopen(cfg_file,'r');

%take in the parameters from the configuration file
k=fscanf(fid,'%d', (1));
d_in=fscanf(fid,'%d', (1));
d_out=fscanf(fid,'%d',(1));
metric=fscanf(fid,'%s',(1));
output_method=fscanf(fid,'%s',(1));
n_train=fscanf(fid,'%d',(1));
train_set_filename=fscanf(fid,'%s',(1));
n_test=fscanf(fid,'%d',(1));
test_set_filename=fscanf(fid,'%s',(1));
output_filename=fscanf(fid,'%s',(1));


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

algorithm_output=zeros(d_out,n_test);

    for i=1:n_test
        %for each test pattern set input vector, compare to all training
        %pattern set input vectors, calculate appropriate distance between
        %them, sort the training pattern set's output vectors by the 
        %corresponding distance values of the input vectors, and implement
        %the k-nearest-neighbor algorithm
        
        train_pattern_set.ordering_seq=sortMethod(metric,train_pattern_set,d_in,n_train,test_pattern_set.input_vecs(:,i));

        sortedData=quickSort([train_pattern_set.output_vecs; train_pattern_set.ordering_seq]);

        algorithm_output(:,i)=knn_algo(sortedData(1:end-1,:),sortedData(end,:)',k,output_method);

    end
    
    %compute the sum squared error between the algorithm's output vectors
    %and the test pattern set's output vectors.
    sse=(algorithm_output-test_pattern_set.output_vecs).^2;
    sse=sum(sse,1);
    
    %concatenate the test pattern set input vectors, the algorithm's output
    %vectors, the test pattern set's output vectors, and the corresponding
    %SSE values.
    
    result=[test_pattern_set.input_vecs; algorithm_output; test_pattern_set.output_vecs;  sse]';
    save(output_filename, 'result', '-ASCII');
    
    %write result to filename specified by configuration file
    fid = fopen(output_filename', 'wt'); % Open for writing
    for i=1:size(result,1)
        fprintf(fid, '%f\t ', result(i,:));
        fprintf(fid, '\n');
    end
    fclose(fid);



