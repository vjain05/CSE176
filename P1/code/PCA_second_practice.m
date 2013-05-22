%The program uses a list of vectors from a textfile as an input (based on 
%parameters taken in the MATLAB console window). Based on this input, the 
%program creates a random reordering of the input vectors, a reordering of 
%the vectors based on euclidean distance from a target vector, a reordering
%of the vectors based on angular distance from the target vector, and a 
%list of the original vectors projected onto its principal components.\\

%The program was implemented in MATLAB. The main program to be run is 
%'PCA\_second\_practice.m', and this makes function calls to 
%'principal\_components.m', 'computeEuclidDist.m', 
%'computeAngularDist.m', and 'quickSort.m'. To compile and run the program,
%you type 'PCA\_second\_practice' on the MATLAB console window (making sure
%all the listed programs are in the same directory).\\

dimen=input('Enter the input vector dimensionality:\n');
num_vecs=input('Enter the number of patterns:\n');
str=input('Enter pattern file pathname:\n','s');

%create pattern set data structure
pattern_set=struct('input_vecs',zeros(dimen,num_vecs),'output_vecs',[],'ordering_seq',zeros(1,num_vecs),'dimen_outpt',0,'dimen_inpt',dimen,'num_pattrns',num_vecs);%also include dimensionality parameters

fid = fopen(str,'r');
%fid = fopen('C:\Users\Vibhor\Desktop\example\example-input.txt','r');

pattern_set.input_vecs=fscanf(fid,'%f %f',[dimen num_vecs]);

fclose(fid);    

target_vec=input('Enter the target vector, with elements separated by whitespace:\n','s');

%input target vector
target_vec=str2num(target_vec);

%find the principle components
pca_comp=principal_components(pattern_set,num_vecs);

%sort pattern set based on euclidean distance from target vector
pattern_set.ordering_seq=computeEuclidDist(pattern_set,dimen,num_vecs,target_vec);
euclid=quickSort([pattern_set.input_vecs; pattern_set.ordering_seq]);

%sort pattern set based on angular distance from target vector
pattern_set.ordering_seq=computeAngularDist(pattern_set,dimen,num_vecs,target_vec);
angular=quickSort([pattern_set.input_vecs; pattern_set.ordering_seq]);

%randomly permute the pattern set vectors
pattern_set.ordering_seq=randperm(num_vecs);
rand_order=quickSort([pattern_set.input_vecs; pattern_set.ordering_seq]);
rand_order=rand_order(1:end-1,:)';

strin='';
for i=1:dimen
    strin=strcat(strin,'\t %5.8f ');
end
strin=strcat(strin,'\n');

fprintf('\n');
fprintf('Randomly permuted patterns:\n');
fprintf(strin,rand_order);

fprintf('\n');
fprintf('Patterns in their original order:\n');
fprintf(strin,pattern_set.input_vecs);

fprintf('\n');
fprintf('Patterns in order of growing Euclidean distance from target vector:\n');
fprintf(strin,euclid);

fprintf('\n');
fprintf('Patterns in order of growing angular distance from target vector:\n');
fprintf(strin,angular);

fprintf('\n');
fprintf('PCA projected patterns in their original order:\n');%dimensionality of this may differ
fprintf(strin,pca_comp);

fprintf('\n');
fprintf('Done. \n');