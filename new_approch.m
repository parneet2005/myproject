clear
close all
clc

% VARIABLE SETUP
% ---------------------------------------------------------------------------
scenario = 0; % 0 for same side, 1 for opposite side
step = 0.1; % timestep of iteration (0.1 ns) or 1 ns
raytracing = 1; % 0 for no raytracing, 1 for raytracing
dopplershift = 1;
loop = 10; % Number of iterations
dataLines = [2, loop + 1];
same_data = 0; % 0 for different data each time, 1 for same data
trig_adjustment = 1; % Using cosine/sine for DOA adjustment
method = 0; % 0 for Trilateration method and 1 for Tri_tdoa method
weights = 1; % 0 for no weighting and 1 for weighting
ls = 1; % 0 for no least squares, 1 for least squares
plot_graph = 1; % 0 for don't plot graphs, 1 to plot graphs
Number_of_receivers = 3; % Number of receivers used within the simulation
TransmitterFrequency = 60;
TransmitterPower = 50;
c = 299792458; % Speed of light in m/s 3

time_interval = 500; % number of iterations in nanoseconds

% Toyota Prius dimensions in meters
toyota_length = 4.55;
toyota_width = 1.75;
rw = toyota_width / 2; % Receiver width
rh = toyota_length / 2; % Receiver length

% Define vehicles' positions on a multi-lane highway
% [Ax, Ay] is the position of Vehicle A (Transmitter)
% [Bx, By], [Cx, Cy], [Dx, Dy] are the positions of Vehicles B, C, and D (Receivers)
if (same_data == 0)
    [Ax, Ay, Bx, By, Cx, Cy, Dx, Dy] = initialize_vehicle_positions(); 
    % You will need to define this function to initialize the vehicle positions based on the scenario
end

A = [Ax Ay]; % Transmission vehicle (Vehicle A)
B = [Bx By]; % Receiver vehicle (Vehicle B)
C = [Cx Cy]; % Receiver vehicle (Vehicle C)
D = [Dx Dy]; % Receiver vehicle (Vehicle D)

% Kalman Filter Initialization for Vehicle A's State
% ---------------------------------------------------------------------------
% Initial state: [x_position, y_position, x_velocity, y_velocity]
X_k = [Ax; Ay; 0; 0]; % State vector (Vehicle A's estimated position and velocity)
P_k = eye(4); % Initial uncertainty covariance
Q_k = 0.01 * eye(4); % Process noise covariance
R_k = 1 * eye(2); % Measurement noise covariance (DOA measurement noise)
F_k = [1 0 step 0; 0 1 0 step; 0 0 1 0; 0 0 0 1]; % State transition matrix
H_k = [1 0 0 0; 0 1 0 0]; % Observation matrix

% Start simulation loop
for k = 1:loop
    % Predict step of Kalman Filter
    X_k = F_k * X_k; % Predicted state
    P_k = F_k * P_k * F_k' + Q_k; % Predicted covariance

    % DOA from each vehicle (B, C, D) relative to Vehicle A
    % For simplicity, use line of sight and geometry to calculate DOA
    DOA_B = calculate_DOA(B, A); % DOA from Vehicle B
    DOA_C = calculate_DOA(C, A); % DOA from Vehicle C
    DOA_D = calculate_DOA(D, A); % DOA from Vehicle D

    % Convert DOA to positions for each vehicle
    % Assume Vehicles B, C, D share their position and DOA estimates with Vehicle A
    Z_B = B + [cosd(DOA_B), sind(DOA_B)] * 50; % Estimate from Vehicle B
    Z_C = C + [cosd(DOA_C), sind(DOA_C)] * 50; % Estimate from Vehicle C
    Z_D = D + [cosd(DOA_D), sind(DOA_D)] * 50; % Estimate from Vehicle D

    % Average DOA-based position estimate from all vehicles
    Z_k = (Z_B + Z_C + Z_D) / 3; % Measurement update (DOA average)

    % Kalman Filter update step
    Y_k = Z_k' - H_k * X_k; % Measurement residual
    S_k = H_k * P_k * H_k' + R_k; % Residual covariance
    K_k = P_k * H_k' / S_k; % Kalman gain
    X_k = X_k + K_k * Y_k; % Updated state estimate
    P_k = (eye(4) - K_k * H_k) * P_k; % Updated covariance estimate

    % Extract updated position of Vehicle A
    A_estimated = X_k(1:2)'; % Updated position of Vehicle A

    % Plot updated positions for visualization
    if plot_graph
        hold on;
        axis equal;
        scatter(A_estimated(1), A_estimated(2), 'filled', 'r'); % Estimated Vehicle A
        scatter(B(1), B(2), 'filled', 'k'); % Vehicle B
        scatter(C(1), C(2), 'filled', 'g'); % Vehicle C
        scatter(D(1), D(2), 'filled', 'b'); % Vehicle D
        xlabel('X Position (m)');
        ylabel('Y Position (m)');
        legend('Vehicle A (Estimated)', 'Vehicle B', 'Vehicle C', 'Vehicle D');
        pause(0.1);
    end

end

disp('Final estimated position of Vehicle A:');
disp(A_estimated);

% Define function to calculate DOA from receiver to transmitter
function doa = calculate_DOA(receiver_pos, transmitter_pos)
    delta_y = transmitter_pos(2) - receiver_pos(2);
    delta_x = transmitter_pos(1) - receiver_pos(1);
    doa = atan2d(delta_y, delta_x); % Direction of arrival in degrees
end

% Function to initialize vehicle positions for simplicity
function [Ax, Ay, Bx, By, Cx, Cy, Dx, Dy] = initialize_vehicle_positions()
    % Random or predefined positions for Vehicle A, B, C, and D
    Ax = 10; Ay = 5; % Position of Vehicle A
    Bx = 20; By = 15; % Position of Vehicle B
    Cx = 25; Cy = 10; % Position of Vehicle C
    Dx = 30; Dy = 20; % Position of Vehicle D
end