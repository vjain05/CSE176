sizes=[0 5 10 15 17 20 25 30 35 40];

err_train=[173550 431190 222300 147720 133660 102140 90545 86201 88144 87850];
err_test=[523890 262550 191830 166390 162660 153900 149400 142700 142410 138570];

figure(1)
plot(sizes, err_train,'r');
hold on;
plot(sizes, err_test,'b');
hold on;

legend('Train SSE','Test SSE');
xlabel('# Hidden Units');
ylabel('Cumulative SSE');
title('# Hidden Units vs Cumulative SSE');

sizes2=[3 5 6 11 21 26];
err_train=[249950 199650 177140 110540 51115 39084];
err_test=[222450 118230 87639 38056 13070 9906];

figure(2)
plot(sizes2, err_train,'r');
hold on;
plot(sizes2, err_test,'b');
hold on;

legend('Train SSE','Test SSE');
xlabel('# Output Units');
ylabel('Cumulative SSE');
title('# Output Units vs Cumulative SSE');