y_test=load('nnData.mat','Ytest');
t_test=load('nnData.mat','Ttest');

y=load('nnData.mat','Y');
t=load('nnData.mat','T');
x=1:40000;
x_test=1:10000;

figure(1);
a=abs(y_test.Ytest(5,:)-t_test.Ttest(5,:));
scatter(x_test,a,1);
xlabel('Test Data Points');
ylabel('Difference between Target and Output vector');
title('Test Data abs(t-o) for 40 hidden units Training set 5');
fprintf('mean a %f\n',mean(a));
fprintf('median a %f\n',median(a));
fprintf('variance a %f\n',var(a));

figure(2);
b=abs(y.Y(5,:)-t.T(5,:));
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
