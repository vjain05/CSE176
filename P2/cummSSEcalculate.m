cfg_file=input('Enter data file to compute cumulative SSE (in this directory) \n','s');
fid = fopen(cfg_file,'r');
arr=fscanf(fid,'%f',[14 14]);

fclose(fid);

arr=sum(arr,2);

arr=arr(end);
fprintf('%f \n',arr);