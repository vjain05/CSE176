y_test=load('y_test_size_40.mat','y_test');
t_test=load('t_test_size_40.mat','t_test');

y=load('y_size_40.mat','y');
t=load('t_size_40.mat','t');
x=1:40000;
x_test=1:10000;

figure(1);
a=abs(y_test.y_test-t_test.t_test);
scatter(x_test,a,1);
xlabel('Test Data Points');
ylabel('Difference between Target and Output vector');
title('Test Data abs(t-o) for 40 hidden units');
fprintf('mean a %f\n',mean(a));
fprintf('median a %f\n',median(a));
fprintf('variance a %f\n',var(a));

figure(2);
b=abs(y.y-t.t);
scatter(x,b,1);
xlabel('Train Data Points');
ylabel('Difference between Target and Output vector');
title('Train Data abs(t-o) for 40 hidden units');
fprintf('mean b %f\n',mean(b));
fprintf('median b %f\n',median(b));
fprintf('variance b %f\n',var(b));

[f,z1]=ecdf(a);
[g,z2]=ecdf(b);

figure(3);
plot(z1,f);
xlabel('Distance between Target and Output');
ylabel('% of Data Points');
title('Empirical CDF for output on Test Set');

figure(4);
plot(z2,g);
xlabel('Distance between Target and Output');
ylabel('% of Data Points');
title('Empirical CDF for output on Train Set');
