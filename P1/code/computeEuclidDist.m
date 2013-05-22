%For a given pattern set, the function computes the euclidean distance 
%between each vector and the target vector and outputs those values to a
%vector
function [output]=computeEuclidDist(patt_set,cols_len,nums_vec,targ_vec)

output=zeros(1,nums_vec);
for i=1:nums_vec
 %implement equation (1) from report.pdf
    for j=1:cols_len
        output(i)=output(i)+(patt_set.input_vecs(j,i)-targ_vec(j))^2;
    end
    output(i)=sqrt(output(i));
end

end