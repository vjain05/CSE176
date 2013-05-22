k_EW=[3 4 5 7 10 11];
k_EU=[3 4 5 7 10 11 12];
k_AW=[3 4 5 7 10];
k_AU=[3 4 5 7 10];

err_EW=[3.385840 3.178494 2.719512 2.605445 2.499500 2.555181 ];
err_EU=[3.555555 3.375000 2.480000 2.571427 2.440000 2.512397 2.513890 ];
err_AW=[3.412395 3.159695 3.412395 2.602473 2.630929 ];
err_AU=[3.555555 3.000000 2.480000 2.571427 2.660000 ];

%plot(k_EW, err_EW, k_EU,err_EU, '-',k_AW, err_AW, '--',k_AU, err_AU,':');
plot(k_EW, err_EW,'r');
hold on;
plot(k_EU, err_EU,'g');
hold on;
plot(k_AW, err_AW,'b');
hold on;
plot(k_AU, err_AU,'c');
legend('EW','EU','AW','AU');
xlabel('k');
ylabel('Cumulative SSE');
title('k vs Cumulative SSE');