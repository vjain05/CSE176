%This script generates two graphs: for the cancer and lenses data set. It
%plots the SSE of the neural network against the # of hidden units that
%were used in the network.

%# of hidden units
d_hid=[0 1 2 3 4 5 6 7 8 9 10];

%SSE values (over all the examples) generated from the log files
err_lenses=[0.508469 0.494550 0.498175 0.499462 0.501476 0.501097 0.501761 0.501706 0.501805 0.501880 0.501799];
err_cancer=[2.130085 2.700912 3.397158 2.962848 2.577532 3.129060 3.841726 3.453414 3.687213 4.142510 3.600832];

%make the two graphs
figure(1);
plot(d_hid, err_lenses,'r');
xlabel('d_hid');
ylabel('Cumulative SSE');
title('d_hid vs SSE for lenses data');

figure(2);
plot(d_hid, err_cancer,'r');
xlabel('d_hid');
ylabel('Cumulative SSE');
title('d_hid vs SSE for cancer data');