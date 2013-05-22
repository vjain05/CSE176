%This function outputs the training pattern (trainPatternSet) set whose 
%order is based on the distance from a given vector (sample test vector). 
%The distance metric used is either Angular or Euclidean (determined by 
%metr).

%metr - the distance metric (Euclidean or Angular)
%trainPatternSet - the training pattern set struct
%dIn - dimensionality of the input vectors 
%iter_test_pattern_set_input_vec - input vectors from the test pattern set

function [output]=sortMethod(metr,trainPatternSet,dIn,nTrain,iter_test_pattrn_set_input_vec)
    output=[];
    if metr(1)=='E'
        output=computeEuclidDist(trainPatternSet,dIn,nTrain,iter_test_pattrn_set_input_vec);
    elseif metr(1)=='A'
        output=computeAngularDist(trainPatternSet,dIn,nTrain,iter_test_pattrn_set_input_vec');
    end
end