function covariance_matrix= calculate_covariancematrix(orderx,ordery,receiver_times_1,c,ls,tx)

%shift=0;
d21=c*(receiver_times_1(2)-receiver_times_1(1))/1e9;
d31=c*(receiver_times_1(3)-receiver_times_1(1))/1e9;
d41=c*(receiver_times_1(4)-receiver_times_1(1))/1e9;
d=[d21 d31 d41];

phase_differences21 = (180 / pi) *2 * pi * tx.TransmitterFrequency * d21;
phase_differences31 =(180 / pi) * 2 * pi * tx.TransmitterFrequency* d31;
phase_differences41 =(180 / pi) * 2 * pi * tx.TransmitterFrequency* d41;
 
pd = [phase_differences21 phase_differences31 phase_differences41];
% Calculate the mean of the phase difference values
mean_pd = (phase_differences21+phase_differences31+phase_differences31)/3;

covariance_12 = (phase_differences21-mean_pd)*(phase_differences31-mean_pd);
covariance_13 = (phase_differences21-mean_pd)*(phase_differences41-mean_pd);
covariance_23 = (phase_differences41-mean_pd)*(phase_differences31-mean_pd);


% For each pair of phase difference values, subtract the mean from each value
mean_subtracted_phase_difference_values = pd - mean_pd;

% Calculate the outer product of the mean-subtracted phase difference values
outer_products = mean_subtracted_phase_difference_values' * mean_subtracted_phase_difference_values;

% Average the outer products of all pairs of phase difference values
covariance_matrix = outer_products / (length(pd)*1000);

end
