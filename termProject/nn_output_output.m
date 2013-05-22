y_test=load('nnData2.mat','Ytest');
t_test=load('nnData2.mat','Ttest');

y=load('nnData2.mat','Y');
t=load('nnData2.mat','T');

y_test=y_test.Ytest;
t_test=t_test.Ttest;
y=y.Y;
t=t.T;

y_test(1:25,:,:)=round(y_test(1:25,:,:));
t_test(1:25,:,:)=round(t_test(1:25,:,:));
y(1:25,:,:)=round(y(1:25,:,:));
t(1:25,:,:)=round(t(1:25,:,:));

vec=0:4:100;
vec(end)=1;
ytest_sub=zeros(5,10000);
ttest_sub=zeros(5,10000);
y_sub=zeros(5,40000);
t_sub=zeros(5,40000);
for i=1:5
    ytest_sub(i,:)=vec*y_test(:,:,i);
    ttest_sub(i,:)=vec*t_test(:,:,i);
    y_sub(i,:)=vec*y(:,:,i);
    t_sub(i,:)=vec*t(:,:,i);
end
%y_test(1,1,1)
x=1:40000;
x_test=1:10000;

figure(1);
a=abs(ytest_sub(5,:)-ttest_sub(5,:));
scatter(x_test,a,1);
xlabel('Test Data Points');
ylabel('Difference between Target and Output vector');
title('Test Data abs(t-o) for 40 hidden units Training set 5');
fprintf('mean a %f\n',mean(a));
fprintf('median a %f\n',median(a));
fprintf('variance a %f\n',var(a));

figure(2);
b=abs(y_sub(5,:)-t_sub(5,:));
scatter(x,b,1);
xlabel('Train Data Points');
ylabel('Difference between Target and Output vector');
title('Train Data abs(t-o) for 40 hidden units Training set 5');
fprintf('mean b %f\n',mean(b));
fprintf('median b %f\n',median(b));
fprintf('variance b %f\n',var(b));

[f,z1]=ecdf(a);
[g,z2]=ecdf(b);

figure(3);
plot(z1,f);
xlabel('Distance between Target and Output');
ylabel('% of Data Points');
title('Empirical CDF for output on Testing Set 5');

figure(4);
plot(z2,g);
xlabel('Distance between Target and Output');
ylabel('% of Data Points');
title('Empirical CDF for output on Training Set 5');
