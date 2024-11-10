function [Z,d] = Tri_tdoa(orderx,ordery,receiver_times,c,ls,tx)
%Find the location of the transmitter vehicle


%shift=0;
d21=c*(receiver_times(2)-receiver_times(1))/1e9;
d31=c*(receiver_times(3)-receiver_times(1))/1e9;
d41=c*(receiver_times(4)-receiver_times(1))/1e9;
d=[d21 d31 d41];

 % phase_differences21 = 2 * pi * tx.TransmitterFrequency * d21;
 % phase_differences31 = 2 * pi * tx.TransmitterFrequency* d31;
 % phase_differences41 = 2 * pi * tx.TransmitterFrequency* d41;
 % 
 % pd = [phase_differences21 phase_differences31 phase_differences41];

%A matrix
A2 = [1 -2*orderx(2) -2*ordery(2)];
A3 = [1 -2*orderx(3) -2*ordery(3)];
A4 = [1 -2*orderx(4) -2*ordery(4)];

% w2=1/d21;
% w3=1/d31;
% w4=1/d41;
% w=[w2;w3;w4];

%Condition for equal receiver times to make estimate in the direction
%which is the midpoint of the receivers.
if (receiver_times(1)==receiver_times(2))

    Z1=(orderx(1)+orderx(2))/2;
    Z2=(ordery(1)+ordery(2))/2;

    Z=[Z1 Z2];

elseif (receiver_times(1)~=receiver_times(2))


%Using 4 receivers
Am = [A2;A3;A4];

b = [d21^2-orderx(2)^2-ordery(2)^2;...
     d31^2-orderx(3)^2-ordery(3)^2;...
     d41^2-orderx(4)^2-ordery(4)^2];
B=Am.';

    if (ls==1)

        Z = (B*Am)\B*b;
        Z=[Z(2) Z(3)];

    elseif (ls==0)
        Z =  Am\b;

        Z=[Z(2) Z(3)];

    end
end

end



 
 
 
 
 