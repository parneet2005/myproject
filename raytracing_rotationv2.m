
function [Z]=raytracing_rotationv2(Z, final_A, yfit,initial_e_theta,scenario)

%point to rotate
v = [Z(1); Z(2)];

%center of rotation
x_center = final_A(1);
y_center = final_A(2);

%matrix for this
center = [x_center; y_center];

if (scenario==0)

    if (Z(1)>=final_A(1)) && (Z(2)>=final_A(2))
    
        if (initial_e_theta<60)
    
            theta = yfit;
    
        elseif (initial_e_theta>60)
    
            theta = -yfit;
        end
    
    elseif (Z(1)<=final_A(1)) && (Z(2)>=final_A(2))
    
        if (initial_e_theta <=300)
    
            theta = yfit;
    
        elseif (initial_e_theta>300)
    
            theta = -yfit;
    
        end
    
    elseif (Z(1)>=final_A(1)) && (Z(2)<=final_A(2))
    
        if (initial_e_theta<=109)
    
            theta = yfit;
    
        elseif (initial_e_theta>109)
    
            theta = -yfit;
    
        end
    
    elseif (Z(1)<=final_A(1)) && (Z(2)<=final_A(2))
    
        if (initial_e_theta>=180)
    
            theta = yfit;
    
        end
    
    end

elseif (scenario==1)

    if (Z(1)<=final_A(1)) && (Z(2)<=final_A(2))

        theta = yfit;

    elseif (Z(1)<=final_A(1)) && (Z(2)>=final_A(2))

        if (initial_e_theta<=310)

            theta = yfit;

        elseif (initial_e_theta>310)

            theta = -yfit;
        end

    elseif (Z(1)>=final_A(1)) && (Z(2)>=final_A(2))

            theta = yfit;


    elseif (Z(1)>=final_A(1)) && (Z(2)<=final_A(2))

            theta = -yfit;

    elseif (initial_e_theta==180)

            theta = yfit;

      

%         elseif (initial_e_theta>312 && initial_e_theta<313)
% 
%             theta = -yfit;
% 
%         elseif (initial_e_theta>=313 && initial_e_theta<313.8)
% 
%             theta = yfit;
% 
%         elseif (initial_e_theta>=313.8 && initial_e_theta<314)
% 
%             theta = -yfit;
% 
%         elseif (initial_e_theta>=314 && initial_e_theta<315.6)
% 
%             theta = yfit;
% 
%         elseif (initial_e_theta>=315.6 && initial_e_theta<316.5)
% 
%             theta = -yfit;
% 
%         elseif (initial_e_theta>=316.5 && initial_e_theta<316.8)
% 
%             theta = yfit;
% 
%         elseif (initial_e_theta>=316.8 && initial_e_theta<317.1)
% 
%             theta = -yfit;
% 
%         elseif (initial_e_theta>=317.1 && initial_e_theta<317.4)
% 
%             theta = yfit;
% 
%         elseif (initial_e_theta>=317.4 && initial_e_theta<318)
% 
%             theta = -yfit;
% 
%         elseif (initial_e_theta>=318 && initial_e_theta<319)
% 
%             theta = yfit;
% 
%         elseif (initial_e_theta>=319 && initial_e_theta<319.2)
% 
%             theta = -yfit;
% 
%         elseif (initial_e_theta>=319.2 && initial_e_theta<321)
% 
%             theta = yfit;
% 
%         elseif (initial_e_theta>=321)
% 
%             theta = -yfit;
       

    end

end

R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

%conduct rotation

% shift points in the plane so that the center of rotation is at the origin
s = v - center;

% apply the rotation about the origin
so = R*s;

% shift again so the origin goes back to the desired center of rotation
vo = so + center;

% if (initial_e_theta ==0 && yfit >10)
% 
%     Z = [Z(1) Z(2)];
% 
% elseif (initial_e_theta == 0 && yfit ==180)
% 
%     Z = [Z(1) finalA(2)-1];
% 
% else
    Z(1) = vo(1);
    Z(2) = vo(2);

% end

Z = [Z(1) Z(2)];

end





