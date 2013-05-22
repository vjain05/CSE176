%Recursively print the logical statements produced from the learned
%decision tree

function [out]=print_dtree(d_tree_print,index, spacing, fileID)
out=0;
if strcmp(d_tree_print(index).type,'ATTRIBUTE')==1
    fprintf(fileID,spacing);
    fprintf(fileID,'TEST FEATURE NUMBER %d:\n',d_tree_print(index).value);
    fprintf(fileID,spacing);
    fprintf(fileID,'   IF FEATURE IS FALSE, THEN ...\n');
    
    out=print_dtree(d_tree_print,d_tree_print(index).child(1), [spacing '      '],fileID);
    fprintf(fileID,spacing);
    fprintf(fileID,'   IF FEATURE IS TRUE, THEN ...\n');
    out=print_dtree(d_tree_print,d_tree_print(index).child(2), [spacing '      '],fileID);
elseif strcmp(d_tree_print(index).type,'LABEL')==1
    if d_tree_print(index).value==0
        fprintf(fileID,spacing);
        fprintf(fileID,'ITEM IS NON-TARGET\n');
    else
        fprintf(fileID,spacing);
        fprintf(fileID,'ITEM IS TARGET\n');
    end
end
end