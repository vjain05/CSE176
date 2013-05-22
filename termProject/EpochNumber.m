err_train=load('nnData.mat','ERRtrain');
err_test=load('nnData.mat','ERRtest');
x=1:300;

plot(x,err_train.ERRtrain(:,1),'bx');
hold on;
plot(x,err_train.ERRtrain(:,2),'b+');
hold on;
plot(x,err_train.ERRtrain(:,3),'bs');
hold on;
plot(x,err_train.ERRtrain(:,4),'bv');
hold on;
plot(x,err_train.ERRtrain(:,5),'bd');
hold on;

plot(x,err_test.ERRtest(:,1),'rx');
hold on;
plot(x,err_test.ERRtest(:,2),'r+');
hold on;
plot(x,err_test.ERRtest(:,3),'rs');
hold on;
plot(x,err_test.ERRtest(:,4),'rv');
hold on;
plot(x,err_test.ERRtest(:,5),'rd');
legend('Training set 1', 'Training set 2', 'Training set 3', 'Training set 4','Training set 5','Testing set 1', 'Testing set 2', 'Testing set 3', 'Testing set 4','Testing set 5');
xlabel('# Training Epochs');
ylabel('Cumulative SSE');
title('# Training Epochs vs Cumulative SSE for d_{hid}=40, d_{out}=1');