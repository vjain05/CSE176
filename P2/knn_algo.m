%This program implements the average and weighted average of the output
%vectors from the training set in the k-nearest-neighbor algorithm.

%sortedTrainingOutputVecs - the training pattern set's output vectors
%sorted by the appropriate distance metric between the training set input
%vectors and the appropriate test set input vector. This is a matrix of
%column vectors
%
%weights - calculated distance measurements between each training set input
%vector and the given test set input vector. This is a column vector
%
%the_k - k parameter
%
%outpt_meth - the output method (weighted or unweighted average)

function [output]=knn_algo(sortedTrainingOutputVecs, weights, the_k, outpt_meth)
    output=[];

    % take the k nearest training output vectors
    sortedTrainingOutputVecs=sortedTrainingOutputVecs(:,1:the_k);
    
    %make weights=distance(x,y)^2
    weights=weights(1:the_k,:).^2;
    
    %check if any weights are zero, return a vector of their indices if
    %they exist
    check=find(weights==0);
    
    
    if(numel(check))==0
        %make weights=1/(distance(x,y)^2)
        
        weights=1./weights;
        
        %implement weighted average formula:
        if outpt_meth(1)=='W'
            output=sortedTrainingOutputVecs*(weights)/sum(weights);
        %implement un-weighted average formula:
        elseif outpt_meth(1)=='U'||outpt_meth(1)=='M'
            output=sum(sortedTrainingOutputVecs,2)/the_k;
        end
    else
        output=[0;0];
        %implement un-weighted average of zero distance vectors.
        for i=1:numel(check)
            output=output+sortedTrainingOutputVecs(:,check(i));
        end
        output=output/numel(check);
    end
end