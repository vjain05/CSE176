%implement the ID3 algorithm as described in Tom Mitchell's "Machine 
%Learning" table 3.1

function [out_tree]=ID3_sample(d_tree,prnt_indx,exmpl_list,attr_list)

out_tree=d_tree;
targ_attr_list=exmpl_list(end,:);%the target classifications
if isempty(find(targ_attr_list==1))%all classifications are 0 (FALSE)
    out_tree(prnt_indx).type='LABEL';
    out_tree(prnt_indx).value=0;
elseif isempty(find(targ_attr_list==0))%all classifications are 1 (TRUE)
    out_tree(prnt_indx).type='LABEL';
    out_tree(prnt_indx).value=1;
elseif isempty(attr_list)%attribute list to browse from is empty
    out_tree(prnt_indx).type='LABEL';
    out_tree(prnt_indx).value=mode(targ_attr_list);
else %assume we are learning an attribute node instead of a label node
    out_tree(prnt_indx).type='ATTRIBUTE';
    
    %find the best fit attribute out of attr_list that maximizes 
    %information gain
    
    entropy_S=entropy_func(targ_attr_list);
    max=-1;
    max_subset_1=[];
    max_subset_0=[];
    max_attribute=-1;
    for i=1:length(attr_list)
        vector=exmpl_list(attr_list(i),:);%obtain attribute i label in all 
        %the training examples
        
        subset_1=find(vector==1);%find the indices of the examples where 
        %attribute i==TRUE
        
        subset_0=find(vector==0);%find the indices of the examples where 
        %attribute i==FALSE
        
        examples_1=exmpl_list(:,subset_1);%the subset of examples where
        %attribute i==TRUE
        
        entropy_subset_1=entropy_func(examples_1(end,:));
        
        examples_0=exmpl_list(:,subset_0);%the subset of examples where
        %attribute i==FALSE
        
        entropy_subset_0=entropy_func(examples_0(end,:));
        sum=numel(subset_1)+numel(subset_0);
        
        %calculate information gain for each attribute as given in Tom
        %Mitchell's "Machine Learning" equation (3.4)
        gain=entropy_S-(numel(subset_1)/sum)*entropy_subset_1-(numel(subset_0)/sum)*entropy_subset_0;
        if gain>max
            max=gain;
            
            %the subset examples associated with the best fit attribute
            max_subset_1=examples_1;
            max_subset_0=examples_0;
            
            %the best fit attribute
            max_attribute=attr_list(i);
        end
    end
    
    %find the new reduced attribute list
    new_attr_list=attr_list;
    new_attr_list(find(new_attr_list==max_attribute))=[];
    out_tree(prnt_indx).value=max_attribute;
    
    %form the FALSE branch and subtree of given attribute
    out_tree_len=length(out_tree);
    out_tree(prnt_indx).child(1)=out_tree_len+1;%first declare address 
    %where child node will exist, and then create that child node
    
    if isempty(max_subset_0)
        out_tree(out_tree_len+1).type='LABEL';
        out_tree(out_tree_len+1).value=mode(targ_attr_list);
    else
        out_tree=ID3_sample(out_tree,out_tree_len+1,max_subset_0,new_attr_list);
    end
    
    %form the TRUE branch and subtree of given attribute
    out_tree_len=length(out_tree);
    out_tree(prnt_indx).child(2)=out_tree_len+1;%first declare address 
    %where child node will exist, and then create that child node
    
    if isempty(max_subset_1)
        out_tree(out_tree_len+1).type='LABEL';
        out_tree(out_tree_len+1).value=mode(targ_attr_list);
    else
        out_tree=ID3_sample(out_tree,out_tree_len+1,max_subset_1,new_attr_list);
    end
end
end
    