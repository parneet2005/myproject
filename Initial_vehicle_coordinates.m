function [Ax,Ay,Bx,By] = Initial_vehicle_coordinates(Aupper_bound_x,Bupper_bound_x,...
    upper_bound_y,Alower_bound_x,Blower_bound_x,lower_bound_y,scenario)

if (scenario==0)
    %random integer to decide x value for circle A
    Ax = randi([Alower_bound_x,Aupper_bound_x],1); 
    %random integer to decide y value for circle A
    Ay = randi([lower_bound_y,upper_bound_y],1); 
    %Initial x value for B
    Bx = randi([Alower_bound_x,Aupper_bound_x],1); 
    %Initial y value for B
    By = randi([lower_bound_y,upper_bound_y],1); 
    Ax=3*Ax;
    Bx=3*Bx;

elseif (scenario==1)
    %random integer to decide x value for circle A
    Ax = randi([Alower_bound_x,Aupper_bound_x],1);
    %random integer to decide y value for circle A
    Ay = randi([lower_bound_y,upper_bound_y],1); 
    %Initial x value for B
    Bx = randi([Blower_bound_x,Bupper_bound_x],1); 
    %Initial y value for B
    By = randi([lower_bound_y,upper_bound_y],1);
    Ax=3*Ax;
    Bx=3*Bx;

end
%random integer to decide x value for circle A
% Ax = randi([lower_bound_x,upper_bound_x],1); 
%random integer to decide y value for circle A
% Ay = randi([lower_bound_y,upper_bound_y],1); 
%Initial x value for B
% Bx = randi([lower_bound_x,upper_bound_x],1); 
%Initial y value for B
% By = randi([lower_bound_y,upper_bound_y],1); 


if ((Ax == Bx) && (Ay == By))
    Bx = randi([Alower_bound_x,Aupper_bound_x],1); %Initial x value for B
    By = randi([lower_bound_y,upper_bound_y],1); %Initial y value for B
    
end
return
    
    