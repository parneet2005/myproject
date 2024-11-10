function [receiver_distances] = Receiver_radius2(receiver_times, c)

% c is the speed of light
c = 299792458; % m/s
receiver_distances = receiver_times*c/1000000000;

return