% Clear previous variables
clear;
close all;
clc;

% VARIABLE SETUP
%---------------------------------------------------------------------------
loop = 10;
scenario = 0;
step = 0.1;
raytracing = 1;
dopplershift = 1;
same_data = 0;
trig_adjustment = 1;
method = 1;
weights = 1;
ls = 1;
plot_graph = 1;
Number_of_receivers = 4;
receiver_orient = 0;

% V2V transmission radius values
c = 299792458;
radius = 0;
delta_d = c / (1000000000 * (1 / step));
interval = 0;
time_interval = 500;

% Vehicle dimensions in meters
toyota_length = 4.55;
toyota_width = 1.75;
rw = toyota_width / 2;
rh = toyota_length / 2;

% Doppler Shift values
vr = 50 * 5 / 18;
vt = 30 * 5 / 18;
f0 = 5.9e7;
lamda = c / f0;

% Dimensions of road environment
Alower_bound_x = 4;
Blower_bound_x = 1;
lower_bound_y = 1;
Aupper_bound_x = 6;
Bupper_bound_x = 3;
upper_bound_y = 100;

% Colors for the plots
dark_red = [0.6350 0.0780 0.1840];
dark_blue = [0 0.4470 0.7410];
dark_yellow = [0.9290 0.6940 0.1250];

% Setup for ray tracing
if raytracing == 1
    tx = txsite('Name', 'Transmitter', 'CoordinateSystem', 'cartesian', ...
                'Antenna', 'isotropic', 'TransmitterFrequency', 5.9e9, ...
                'TransmitterPower', 30);
    
    rx = repmat(rxsite, 1, 5);
    for i = 1:5
        rx(i) = rxsite('Name', sprintf('Receiver %d', i), 'CoordinateSystem', 'cartesian', 'Antenna', 'isotropic');
    end

    pm = propagationModel("raytracing", "CoordinateSystem", "cartesian", ...
                          "Method", "sbr", "AngularSeparation", "high", ...
                          "MaxNumReflections", 0, "SurfaceMaterial", "concrete");
end

% Kalman filter parameters
A_kf = 1;  % State transition matrix
H_kf = 1;  % Observation matrix
Q_kf = 0.01;  % Process noise covariance
R_kf = 0.1;  % Measurement noise covariance
P_kf = 1;  % Initial estimate error covariance
x_kf = 0;  % Initial state estimate

% Number of iterations
for k = 1:loop
    tic;
    
    % Initial vehicle coordinates
    [Ax, Ay, Bx, By] = Initial_vehicle_coordinates(Aupper_bound_x, Bupper_bound_x, ...
                                                   upper_bound_y, Alower_bound_x, ...
                                                   Blower_bound_x, lower_bound_y, scenario);
    % Randomize vehicle speeds
    [vr, vt] = vehicle_speeds(scenario);

    A = [Ax, Ay];
    B = [Bx, By];

    % Receiver positions
    [A_receivers_x, A_receivers_y, carx, cary] = receiver_positions(A, B, rw, rh, receiver_orient);

    % V2V transmission
    if raytracing == 1
        [receiver_times, t, I, R] = Raytracing_practice(A, B, A_receivers_x, A_receivers_y, step, tx, rx, pm);
    else
        [receiver_times, t] = V2V_find_problem(B, radius, time_interval, delta_d, A_receivers_x, A_receivers_y, step);
    end

    % Receiver distances
    [receiver_distances] = Receiver_radius2(receiver_times, c);

    if raytracing == 0
        [receiver_times, I] = sort(receiver_times, 'ascend');
    end

    % Ordered coordinates
    orderx = A_receivers_x(I);
    ordery = A_receivers_y(I);
    Ad = receiver_distances(I);

    % Calculate RSSI without interference
    rssiWithoutInterference = sigstrength(rx, tx);

    % Model interference (for simplicity, using the same txsite configuration)
    interference = txsite('Name', 'Interference', 'CoordinateSystem', 'cartesian', ...
                          'Antenna', 'isotropic', 'TransmitterFrequency', 5.9e9, ...
                          'TransmitterPower', 10);
    interferenceRSSI = sigstrength(rx, interference);

    % Calculate RSSI with interference
    totalRSSI_dBm = 10 * log10(10.^((rssiWithoutInterference) / 10) + 10.^((interferenceRSSI) / 10));

    % Add noise to the system
    noiseFigure_dB = 10;
    bandwidth = 20e6;
    totalRSSIWithNoise_dBm = addNoise(totalRSSI_dBm, noiseFigure_dB, bandwidth);

    % Apply Kalman filter to denoise the RSSI
    [denoisedRSSI, x_kf, P_kf] = kalmanFilter(totalRSSIWithNoise_dBm, x_kf, P_kf, A_kf, H_kf, Q_kf, R_kf);

    % Tri-TDOA method
    [Z, d] = Tri_tdoa(orderx, ordery, receiver_times, c, ls, tx);

    % New vehicle positions
    elap_t2 = toc;
    [final_A, final_B, Z, ZZ, cary] = speed_of_vehicles(A, B, Z, vr, vt, cary, t, elap_t2, scenario);

    % Calculate DOA
    v1 = [Z(1), Z(2), 0] - [final_A(1), final_A(2), 0];
    v2 = [final_B(1), final_B(2), 0] - [final_A(1), final_A(2), 0];
    % Calculate DOA using updated positions
    
    v1 = [Z(1), Z(2), 0] - [final_A(1), final_A(2), 0];
    DOA_estimate = atan2d(v1(2), v1(1));

    v2 = [final_B(1), final_B(2), 0] - [final_A(1), final_A(2), 0];
    correct_DOA = atan2d(v2(2), v2(1));
    
    % Calculate DOA error
    DOA_error = abs(correct_DOA - DOA_estimate);

    % Plot graphs
    if plot_graph == 1
        figure;
        hold on;
        axis equal;
        scatter(final_A(1), final_A(2), 'filled', 'r');
        scatter(final_B(1), final_B(2), 'filled', 'r');
        scatter(carx, cary, 'filled', 'c');
        viscircles([orderx(2), ordery(2)], d(1), 'color', dark_yellow);
        viscircles([orderx(3), ordery(3)], d(2), 'color', dark_yellow);
        viscircles([orderx(4), ordery(4)], d(3), 'color', dark_yellow);
        scatter(Z(1), Z(2), 'filled', 'b');

        coef1 = (Z(2) - final_A(2)) / (Z(1) - final_A(1));
        coef2 = final_A(2) - coef1 * final_A(1);

        if scenario == 0
            x = 10.5:20;
        else
            x = 0:20;
        end

        y = coef1 * x + coef2;
        plot(x, y);

        xlabel('Road width (m)');
        ylabel('Road length (m)');
        xline(10.5);
        xline([1.5 4.5 7.5 13.5 16.5 19.5], '--');

        f = sprintf('time = %.f ns', t);
        title(f);

        pause(interval);
    end
end

toc;

% Print final values
fprintf('DOA estimate: %.2f degrees\n', DOA_estimate);
fprintf('Correct DOA: %.2f degrees\n', correct_DOA);
fprintf('DOA error: %.2f degrees\n', DOA_error);
fprintf('RSSI without interference: %.2f dBm\n', rssiWithoutInterference);
fprintf('Interference RSSI: %.2f dBm\n', interferenceRSSI);
fprintf('Total RSSI with interference: %.2f dBm\n', totalRSSI_dBm);
fprintf('Total RSSI with interference and noise: %.2f dBm\n', totalRSSIWithNoise_dBm);

function totalRSSIWithNoise_dBm = addNoise(totalRSSI_dBm, noiseFigure_dB, bandwidth)
    % Calculate the thermal noise power in dBm
    noisePower_dBm = -174 + 10 * log10(bandwidth);
    
    % Convert the noise power from dBm to linear scale and add the noise figure
    noisePower_linear = 10^((noisePower_dBm + noiseFigure_dB) / 10);

    % Convert the total RSSI from dBm to linear scale
    totalPower_linear = 10.^(totalRSSI_dBm / 10) + noisePower_linear;

    % Convert the total power back to dBm
    totalRSSIWithNoise_dBm = 10 * log10(totalPower_linear);
end


function [denoisedRSSI, x_kf, P_kf] = kalmanFilter(z, x_kf, P_kf, A_kf, H_kf, Q_kf, R_kf)
    % Prediction
    x_kf = A_kf * x_kf;  % Predicted state estimate
    P_kf = A_kf * P_kf * A_kf' + Q_kf;  % Predicted estimate covariance
    
    % Update
    K_kf = P_kf * H_kf' / (H_kf * P_kf * H_kf' + R_kf);  % Kalman gain
    x_kf = x_kf + K_kf * (z - H_kf * x_kf);  % Updated state estimate
    P_kf = (eye(size(K_kf,1)) - K_kf * H_kf) * P_kf;  % Updated estimate covariance
    
    % Output the denoised RSSI
    denoisedRSSI = x_kf;
end
