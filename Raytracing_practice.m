%Raytracing practice

function [receiver_times,t,I,R,Angle_of_arrival]=Raytracing_practice(A,B,A_receivers_x,A_receivers_y,step,tx,rx,pm)

tx.AntennaPosition = [B(1);B(2);0]; %set location of transmitter to center of transmitter vehicle

rx(1).AntennaPosition = [A_receivers_x(1);A_receivers_y(1);0];
rx(2).AntennaPosition = [A_receivers_x(2);A_receivers_y(2);0];
rx(3).AntennaPosition = [A_receivers_x(3);A_receivers_y(3);0];
rx(4).AntennaPosition = [A_receivers_x(4);A_receivers_y(4);0];

rx(5).AntennaPosition = [A(1); A(2); 0];

R= raytrace(tx,rx,pm);

if (step == 0.1)

    receiver_times_1 = [(R{1,1}.PropagationDelay);
        (R{1,2}.PropagationDelay);
        (R{1,3}.PropagationDelay);
        (R{1,4}.PropagationDelay)];
    receiver_times = [ceil(R{1,1}.PropagationDelay*1e10);
        ceil(R{1,2}.PropagationDelay*1e10);
        ceil(R{1,3}.PropagationDelay*1e10);
        ceil(R{1,4}.PropagationDelay*1e10)];
    receiver_times = receiver_times/10;

elseif (step ==1)

    receiver_times = [ceil(R{1,1}.PropagationDelay*1e9);
        ceil(R{1,2}.PropagationDelay*1e9);
        ceil(R{1,3}.PropagationDelay*1e9);
        ceil(R{1,4}.PropagationDelay*1e9)];

end

Angle_of_arrival = R{1,5}.AngleOfArrival;

[receiver_times,I] = sort(receiver_times, 'ascend');
[receiver_times_1,I] = sort(receiver_times_1, 'ascend');
t = receiver_times(4);

end






    








