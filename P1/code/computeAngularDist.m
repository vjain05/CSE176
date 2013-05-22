%For a given pattern set, the function computes the angular distance 
%between each vector and the target vector and outputs those values to a
%vector

function [output]=computeAngularDist(patt_set,cols_len,nums_vec,targ_vec)

output=zeros(1,nums_vec);

for i=1:nums_vec
  %implement equation (2) from report.pdf
    output(i)=abs(acos(targ_vec*patt_set.input_vecs(1:cols_len,i)/(norm(targ_vec)*norm(patt_set.input_vecs(1:cols_len,i)))));
    
end

end