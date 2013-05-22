%For a given pattern set, the function computes the euclidean distance 
%between each vector and the target vector and outputs those values to a
%vector

%patt_set - the pattern set struct
%cols_len - length of the pattern set's input vectors
%nums_vec - the number of input vectors in the pattern set
%targ_vec - the target vector which is compared to all the input vectors in
%the pattern set
function [output]=computeEuclidDist(patt_set,cols_len,nums_vec,targ_vec)

output=zeros(1,nums_vec);
for i=1:nums_vec
 %implement equation (1) from report.pdf of Programming Assignment 1
    for j=1:cols_len
        output(i)=output(i)+(patt_set.input_vecs(j,i)-targ_vec(j))^2;
    end
    output(i)=sqrt(output(i));
end

end