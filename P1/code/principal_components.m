%Finds the principal components of a pattern set and projects that pattern
%set onto those principal components. The strategy for this is given in
%report.pdf

function [princ_comp]=principal_components(patt_set,nums_vec)
%find the principle components
mean_vec=mean(patt_set.input_vecs');%calculate the mean vectors


%shift the data vectors by the mean vectors
for i=1:length(mean_vec)
    data_mean_shifted(i,:)=patt_set.input_vecs(i,:)-mean_vec(i);
end


%calculate the covariance matrix AA^T
cov=data_mean_shifted*data_mean_shifted';

%do eigendecomposition to find orthogonal eigenvectors and eigenvalues
[e_vect, e_vals]=eig(cov);
[col_len,row_len]=size(e_vect);
princ_comp=zeros(row_len,nums_vec);
for i=1:nums_vec
   for j=1:row_len
       %based on equation (7) from report.pdf
       princ_comp(j,i)=data_mean_shifted(:,i)'*e_vect(:,j)/(e_vect(:,j)'*e_vect(:,j));
   end
end

end