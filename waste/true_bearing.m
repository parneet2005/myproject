function [theta]=true_bearing(final_A,final_B)

%distance between receiver and transmit vehicle on each plane
bearing_x = final_B(1)-final_A(1);
bearing_y = final_B(2)-final_A(2);

%top right quadrant
if bearing_x>=0 && bearing_y>=0
    theta = 90-atand(bearing_y/bearing_x);
    
elseif bearing_x==0 && bearing_y>=0
    theta = 0;
    
elseif bearing_x>=0 && bearing_y==0
    theta = 90;
    
    
%bottom right quadrant    
elseif bearing_x>=0 && bearing_y<=0
    theta = 90+abs(atand(bearing_y/bearing_x));
    
elseif bearing_x==0 && bearing_y<=0
    theta = 180;
    
elseif bearing_x>0 && bearing_y==0
    theta = 90+abs(atand(bearing_y/bearing_x));
    
    
%bottom left quadrant    
elseif bearing_x<=0 && bearing_y<=0
    theta = (90-abs(atand(bearing_y/bearing_x)))+180;
    
    
%top left quadrant    
elseif bearing_x<=0 && bearing_y>=0
    theta = abs(atand(bearing_y/bearing_x))+270;
    
elseif bearing_x<=0 && bearing_y==0
    theta = 270;

end   
end