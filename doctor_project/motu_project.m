
%clear previous variables
clear
close all
clc

%VARIABLE SETUP
%---------------------------------------------------------------------------


loop = 1;

%Change the method here depending on preference
scenario = 0;%0 for on same side, 1 for opposite side
step = 0.1; %timestep of iteration (0.1 ns) or 1ns
raytracing = 1; %0 for no raytracing, 1 for raytracing
dopplershift = 1;
dataLines = [2,loop+1];
same_data = 0; %0 for different data each time, 1 for same data
trig_adjustment = 1; %Using cosine sine for DOA adjustment
method = 1; % 0 for Trilateration method and 1 for Tri_tdoa method

weights=0; %0 for no weighting and 1 for weighting
ls=1;%0 for no least squares, 1 for least squares 
plot_graph = 1; % 0 for don't plot graphs and 1 to plot graphs
Number_of_receivers=4; %Number of receivers used within the simulation
receiver_orient=0; %0 for square, 1 for diamond orientation

%V2V transmission radius values
c = 299792458; %speed of light in m/s 
radius = 0; %initial radius value
delta_d =c/(1000000000*(1/step)); %radius update value for each iteration
interval = 0; %how often plotting stops to visualize
time_interval = 500; %number of iterations in nanoseconds

%Toyota Prius dimensions in metres
toyota_length= 4.55;
toyota_width= 1.75;
%width and length of each receiver from center (based of toyota prius)

[r_rw,r_rh,r_h, t_rh, t_rw, t_h]=vehicle_dimensions();

rw = toyota_width/2; %width
rh = toyota_length/2; %length



%Doppler Shift values
%if speed test is wantaed, the velocity should be random
vr=50; %km/hr
vt=30; %km/hr
vr = vr*5/18; %speed of receiver vehicle in m/s
vt = vt*5/18; %speed of transmitting vehicle in m/s
% f0= 5; %observer frequency of sound
f0 = 5.9e7; %frequency
lamda = c/f0; %wavelength

%Doppler values for same or opposing lane
D1=0.5;%Doppler shift arbitrary value to decide whether the shift is too big
D2=0.05; %Doppler shift arbitrary value to decide whether the shift is too small

%dimensions of road environment
Alower_bound_x = 4;
Blower_bound_x = 1;
lower_bound_y = 1;
Aupper_bound_x = 6;
Bupper_bound_x = 3; %width of this road is 30 metres
upper_bound_y = 100; %length of this road is 300 metres
% x = lower_bound_x : upper_bound_x;
% y = lower_bound_y : upper_bound_y;

%Colours for the plots and circles
dark_red = [0.6350 0.0780 0.1840]; %Positions of vehicles
dark_blue = [0 0.4470 0.7410]; %Trilateration interesection point
dark_yellow = [0.9290 0.6940 0.1250]; %Receiver radii

if (raytracing==1)

    tx = txsite;

    %Specifications of transmitter
    tx.Name = 'Transmitter of vehicle'; %Name of the transmitter
    tx.CoordinateSystem= 'cartesian'; %set to cartesian so can use position of vehicle
    tx.Antenna = 'isotropic'; %Set for omnidirectional transmitter properties
    tx.TransmitterFrequency = 5.9e9; %frequency of V2V transmission
    tx.TransmitterPower = 30; %Transmitter power

    rx1 = rxsite;
    rx2 = rxsite;
    rx3 = rxsite;
    rx4 = rxsite;
    rx5 = rxsite;

    rx1.Name = 'Top left receiver';
    rx1.CoordinateSystem= 'cartesian';
    rx1.Antenna = 'isotropic';

    rx2.Name = 'Top right receiver';
    rx2.CoordinateSystem= 'cartesian';
    rx2.Antenna = 'isotropic';

    rx3.Name = 'Bottom left receiver';
    rx3.CoordinateSystem= 'cartesian';
    rx3.Antenna = 'isotropic';

    rx4.Name = 'Bottom right receiver';
    rx4.CoordinateSystem= 'cartesian';
    rx4.Antenna = 'isotropic';

    rx5.Name = 'Center of Receiver vehicle';
    rx5.CoordinateSystem ='cartesian';
    rx5.Antenna = 'isotropic';

    rx=[rx1,rx2,rx3,rx4,rx5];

    pm = propagationModel("raytracing", ...
        "CoordinateSystem", "cartesian", ...
        "Method","sbr", ...
        "AngularSeparation", "high", ...
        "MaxNumReflections", 0,...`
        "SurfaceMaterial", "concrete");

elseif (raytracing==0)

end

%Number of iterations
for k=1:loop
    
%record run time
tic

%COMMANDS FOR THE SIMULATION
%---------------------------------------------------------------------------

%START WITH POSITION OF VEHICLES
%---------------------------------------------------------------------------

[Ax,Ay,Bx,By] = Initial_vehicle_coordinates(Aupper_bound_x,Bupper_bound_x,...
upper_bound_y,Alower_bound_x,Blower_bound_x,lower_bound_y,scenario);

%randomize the initial vehicle speeds
[vr,vt]=vehicle_speeds(scenario);

A = [Ax Ay]; %Transmission vehicle coordinates
B = [Bx By]; %Receiver vehicle coordinates

%POINTS OF RECEIVERS ON THE VEHICLES
%---------------------------------------------------------------------------

%matrix of vehicle receivers
[A_receivers_x,A_receivers_y,carx,cary]=receiver_positions(A,B,rw,rh,receiver_orient);

%CONDUCT THE V2V TRANSMISSION
%---------------------------------------------------------------------------

if (raytracing == 1)

    [receiver_times,t,I,R]=Raytracing_practice(A,B,A_receivers_x,A_receivers_y,step,tx,rx,pm);

elseif (raytracing == 0)

    [receiver_times,t]=V2V_find_problem(B,radius,time_interval,...
        delta_d,A_receivers_x,A_receivers_y,step);

end 

% [Dshift] = Doppler_shift(f0, vr, vt, c, scenario);

%OBTAIN DISTANCE MEASUREMENTS OF RECEIVER RADII
%---------------------------------------------------------------------------

%Calculate the receiver times and distances around each receiver
[receiver_distances] = Receiver_radius2(receiver_times, c);

if (raytracing == 0)
%Ordering the x and y receiver coordinates based on the ascending receiver %times
[receiver_times,I] = sort(receiver_times, 'ascend');

end 

%ordered x coordinates
orderx = A_receivers_x(I);
%ordered y coordinates
ordery = A_receivers_y(I);
%ordered distance
Ad = receiver_distances(I);




%Tri_TDOA method
[Z,d] = Tri_tdoa(orderx,ordery,receiver_times,c,ls,tx);
 
% [covariance_matrix] = calculate_covariancematrix(orderx,ordery,receiver_times_1,c,ls,tx);


%NEW VEHICLE POSITIONS
%---------------------------------------------------------------------------

%Incorporate the distance travelled throughout simulation to add to final
%position
elap_t2=toc;
[final_A, final_B, Z, ZZ, cary]=speed_of_vehicles(A,B,Z,vr,vt,cary,t,elap_t2,scenario);


%ESTIMATE DOA OF SOURCE SIGNAL
%---------------------------------------------------------------------------
% disp(covariance_matrix);
% %Perform eigenvalue decomposition on the covariance matrix
%  [eigenvalues, eigenvectors] = eig(covariance_matrix);
% 
% 
%  disp(eigenvalues);
%  disp(eigenvectors);
%  % zero_eigenvalues=find(eigenvalues==0);
%  % dao_estimation=eigenvectors(:, zero_eigenvalues);
% % disp(dao_estimation);
% %The DOA of the source signal is the angle corresponding to the eigenvector with the largest eigenvalue
%  doa_1 = atan2d(eigenvectors(1,2), eigenvectors(1,1));
% 
% %Display the estimated DOA
%  fprintf('Estimated DOA: %f degrees\n', doa_1);
%  figure
% plot(doa_1);

%PLOTS GRAPHS FOR VISUAL
%---------------------------------------------------------------------------

if (plot_graph ==1)
    
    %car A and B point
    axis square
    
    hold on;
    axis equal;
    


    p1=scatter(final_A(1), final_A(2), 'filled', 'r');
    p=scatter(final_B(1), final_B(2), 'filled', 'r');
    % receiver points
    p2=scatter(carx, cary, 'filled','c');

    % Radii of all receivers on vehicles A and B
    % viscircles(orderx,ordery,Ad, 'color', dark_yellow);
    p3=viscircles([orderx(2),ordery(2)],d(1), 'color', dark_yellow);
    viscircles([orderx(3),ordery(3)],d(2), 'color', dark_yellow);
    viscircles([orderx(4),ordery(4)],d(3), 'color', dark_yellow);
    
    p4=scatter(Z(1),Z(2), 'filled', 'b');
    coef1= (Z(2)-final_A(2))/(Z(1)-final_A(1));
    coef2=final_A(2)-coef1*final_A(1);

    if (scenario==0)

        x=10.5:20;

    elseif (scenario==1)

        x=0:20;

    end

    y=coef1*x+coef2;
    p5=plot(x,y);

xlabel('road width (m)') 
ylabel('road length (m)') 
xline(10.5)
dashed = [1.5 4.5 7.5 13.5 16.5,19.5];
xline(dashed,'--')

%title
f = sprintf('time = %.f ns', t);
title(f);

%Plot every 'interval' seconds
pause(interval);
    
end
    


% %Difference between the true bearing and estimated bearing
% v_1 = [Z(1),Z(2),0] - [final_A(1),final_A(2),0];
% v_2 = [final_B(1),final_B(2),0] - [final_A(1),final_A(2),0];
% DOA_estimate = atan2d(norm(cross(v_1, v_2)), dot(v_1, v_2));
% 
% [theta]=true_bearing(final_A,final_B);
% 
% if (DOA_estimate>=300)
% 
%     DOA_estimate = abs(360-DOA_estimate);
% 
% elseif (DOA_estimate<350)
% 
% end
% DOA_overview = ['DOA error: ',num2str(DOA_estimate), ' degrees'];
% 
% fprintf(DOA_overview);
% toc
end


toc