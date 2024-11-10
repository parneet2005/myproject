
%Doppler Shift formula for non-constant speed scenario
function [Dshift] = Doppler_shift(f0, vr, vt, c,scenario)

c=c*3.6;

if (scenario==0)
    f = ((c+vr)/(c+vt))*f0;
    Dshift = f0-f;
    
elseif (scenario==1)
    f = ((c+vr)/(c+vt*(-1)))*f0;
    Dshift = f0-f;
    
end

vt= ((c+vr)/f0)*f-c;
%values for D1 and D2 will be changed once the other functions are properly defined 

% if shift > D1
%     disp("The transmitting vehicle is within the opposing direction, therefore will not process for DOA since it is an invalid solution")
% 
% elseif shift < D2
%     disp("The transmitting vehicle is within the same direction, therefore will process for DOA since it is a valid solution")
% end

return
