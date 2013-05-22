%For a given pattern set, the function computes the angular distance 
%between each vector and the target vector and outputs those values to a
%vector

%Note: targ_vec is a row vector, and patt_set.input_vecs(1:cols_len,i) is a
%column vector

%patt_set - the pattern set struct
%cols_len - length of the pattern set's input vectors
%nums_vec - the number of input vectors in the pattern set
%targ_vec - the target vector which is compared to all the input vectors in
%the pattern set

function [output]=computeAngularDist(patt_set,cols_len,nums_vec,targ_vec)

output=zeros(1,nums_vec);

for i=1:nums_vec
  %implement equation (2) from report.pdf of Programming Assignment 1
    output(i)=abs(acos(targ_vec*patt_set.input_vecs(1:cols_len,i)/(norm(targ_vec)*norm(patt_set.input_vecs(1:cols_len,i)))));
    
end

end