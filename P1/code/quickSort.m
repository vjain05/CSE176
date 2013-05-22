%This function sorts a set of vectors based on a given metric (euclidean 
%distance from a vector, etc.).
%These metric values for each vector are concatenated to the vector of
%vectors and passed into 'array'

%code based on this link:
%http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#MATLAB

function sortedArray = quickSort(array)
 
    if numel(array(end,:)) <= 1 %If the array has 1 element then it can't be sorted       
        sortedArray = array;
        return
    end
 
    pivot = array(:,end);
    array=array(:,1:end-1);
 
    sortedArray = [quickSort( array(:,array(end,:) <= pivot(end)) ) pivot quickSort( array(:,array(end,:) > pivot(end)) )];
 
end