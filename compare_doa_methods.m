function compare_doa_methods()
    % Simulation parameters
    M = 4;  % Number of antennas at 4 corners
    N = 100;  % Number of time snapshots
    lambda = 5.1;  % Wavelength of the signal
    num_vehicles = 4;  % Number of vehicles
    num_sources = 3;  % Number of incoming signal sources

    % Define corner positions for the antennas (assuming a rectangular vehicle)
    % Coordinates of the corners (e.g., in meters)
    antenna_positions = [0, 0;  % Front-left
                         0, 2;  % Rear-left
                         2, 0;  % Front-right
                         2, 2]; % Rear-right
                         
    % Generate simulated signals and noise
    signals = generate_signals(M, N, num_sources, num_vehicles);
    noise = 0.1 * (randn(M, N, num_vehicles) + 1i * randn(M, N, num_vehicles));

    % Space-Time Matrix DOA Estimation
    st_results = space_time_doa_2d(M, N, antenna_positions, lambda, signals, noise, num_vehicles);

    % Display results
    fprintf('Space-Time Matrix DOA Results (Azimuth and Elevation):\n');
    disp(st_results);
end

function [azimuth_est, elevation_est] = space_time_doa_2d(M, N, antenna_positions, lambda, signals, noise, num_vehicles)
    % Constants
    k = 2 * pi / lambda;  % Wavenumber

    azimuth_est = zeros(1, num_vehicles);
    elevation_est = zeros(1, num_vehicles);

    for vehicle = 1:num_vehicles
        % Signals for the current vehicle
        vehicle_signals = signals(:, :, vehicle);

        % Compute covariance matrices for signals and noise
        Rxx = vehicle_signals * vehicle_signals' + noise(:, :, vehicle) * noise(:, :, vehicle)';  % Covariance matrix
        Ryx = vehicle_signals * vehicle_signals';  % Cross covariance between antenna pairs

        % Compute Space-Time Matrix
        R_st = Ryx * pinv(Rxx + eye(M));  % Regularized to prevent singularities

        % Eigenvalue decomposition of the Space-Time Matrix
        [eig_vecs, eig_vals] = eig(R_st);

        % Estimating DOA from the Eigenvalue decomposition
        azimuth_est(vehicle) = atan2(real(eig_vecs(2, 1)), real(eig_vecs(1, 1)));
        elevation_est(vehicle) = asin(real(eig_vals(1, 1)) / (2 * pi / lambda));
    end
end
function signals = generate_signals(M, N, num_sources, num_vehicles)
    % Function to generate simulated signals for each vehicle's sensor array
    signals = zeros(M, N, num_vehicles);
    
    for vehicle = 1:num_vehicles
        signals(:, :, vehicle) = (randn(M, N) + 1i * randn(M, N)) * num_sources;  % Simulated signals for each vehicle
    end
end