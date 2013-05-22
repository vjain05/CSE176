%calculates the entropy of a given vector of values as given by equation 
%(3.4) in Tom Mitchell's "Machine Learning"
%This is mainly meant for a vector of 1's and 0's, but can also be applied
%to a vector that contains values besides 1's and 0's

function [out]=entropy_func(target_attr_list)
unqA=unique(target_attr_list);%list out all the types of values in 
%target_attr_list

countElA=histc(target_attr_list,unqA);%produce the histogram of the input 
%vector

relFreq=countElA/numel(target_attr_list);%normalize the histogram
out=0;

%calculate the entropy, as shown in Tom Mitchell's "Machine Learning"
for i=1:length(relFreq)
    out=out-relFreq(i)*log2(relFreq(i));
end

end