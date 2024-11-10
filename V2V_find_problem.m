
function [receiver_times,t]=V2V_find_problem(B,radius,time_interval,...
    delta_d,A_receivers_x,A_receivers_y,step)

%starting circle construction
%viscircles(B,radius, 'color', dark_red);

for t = 0:step:time_interval %iterations
    
    
    %Top left receiver time stamp
    if (((B(1)-A_receivers_x(1))^2) + ((B(2)-A_receivers_y(1))^2) > radius^2)
        recet1 = t;
        a=0;
    elseif (((B(1)-A_receivers_x(1))^2) + ((B(2)-A_receivers_y(1))^2) <= radius^2)
        a=1;
    else
        a=1;
    end
    
    
    %Top right receiver time stamp
    if (((B(1)-A_receivers_x(2))^2) + ((B(2)-A_receivers_y(2))^2) > radius^2)
        recet2 = t;
        b=0;
    elseif (((B(1)-A_receivers_x(2))^2) + ((B(2)-A_receivers_y(2))^2) <= radius^2)
        b=1;
    else 
        b=1;
    end
    
    
    %Bottom left receiver timevstamp
    if (((B(1)-A_receivers_x(3))^2) + ((B(2)-A_receivers_y(3))^2) > radius^2)
        recet3 = t;     
        c=0;
    elseif (((B(1)-A_receivers_x(3))^2) + ((B(2)-A_receivers_y(3))^2) <= radius^2)
        c=1;
    else
        c=1;
    end
    
    
    %Bottom right receiver timevstamp
    if (((B(1)-A_receivers_x(4))^2) + ((B(2)-A_receivers_y(4))^2) > radius^2)
        recet4 = t;    
        d=0;
    elseif (((B(1)-A_receivers_x(4))^2) + ((B(2)-A_receivers_y(4))^2) <= radius^2)
        d=1;
    else
        d=1;
    end
    
    %New radius value updated
    radius = radius + delta_d;
    
    %Plot new circle with new radius
    %viscircles(B,radius, 'color',dark_red);
    
    
    if a+b+c+d == 0
        
        %e= 1;
    elseif a+b+c+d == 4
        break
    else
        %e = 1;
    end

end

times = [recet1 recet2 recet3 recet4];

receiver_times = times;

%disp(receiver_times)

end