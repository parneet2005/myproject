
function [Z]=standard_rotation(Z, final_A, yfit,initial_e_theta,scenario)

%point to rotate
v = [Z(1); Z(2)];

%center of rotation
x_center = final_A(1);
y_center = final_A(2);

%matrix for this
center = [x_center; y_center];

if (Z(1)>=final_A(1)) && (Z(2)>=final_A(2))

    if (initial_e_theta<66)

        theta = yfit;

    elseif (initial_e_theta>=66 && initial_e_theta<80)

        theta = -yfit;

    elseif (initial_e_theta>=80)

        theta = yfit;

    end

elseif (Z(1)<=final_A(1)) && (Z(2)>=final_A(2))

    if (scenario==0)

        if (initial_e_theta>292)
    
            theta = -yfit;
    
        elseif (initial_e_theta<=292)
    
            theta = yfit;

        end

    elseif (scenario == 1)

        if (initial_e_theta>292)
    
            theta = -yfit;
    
        elseif (initial_e_theta<=292)
    
            theta = yfit;

        end
    
    end

elseif (Z(1)>=final_A(1)) && (Z(2)<=final_A(2))

    if (initial_e_theta>=112)

        theta = -yfit;

    elseif (initial_e_theta<112)

        theta = yfit;

    end

elseif (Z(1)<=final_A(1)) && (Z(2)<=final_A(2))

    if (scenario==0)

        if (initial_e_theta<214)
    
            theta = yfit;

        elseif (initial_e_theta>214 && initial_e_theta<215)

            theta = -yfit;

        elseif (initial_e_theta>=215 && initial_e_theta<248)

            theta = yfit;
    
        elseif (initial_e_theta>=248)
    
            theta = -yfit;
    
        end

    elseif (scenario==1)

        if (initial_e_theta<247.8)
    
            theta = yfit;
    
        elseif (initial_e_theta>=247.8)
    
            theta = -yfit;
    
        end

    end

elseif (initial_e_theta==0)

    theta = -yfit;

end

if (scenario==0)

    if (initial_e_theta>=2e-11 && initial_e_theta<3e-11)
    
        theta = -yfit;
    
    elseif (initial_e_theta>=4.4e-11 && initial_e_theta<4.5e-11)
    
        theta = -yfit;
    
    elseif (initial_e_theta>=5.8e-11 && initial_e_theta<5.9e-11)
    
        theta = -yfit;

    elseif (yfit>1.4 && yfit<1.45)

        theta = -yfit;

    elseif (yfit>1.45 && yfit<1.5)

        theta = yfit;

    elseif (yfit>1.65 && yfit<1.66)

        theta = -yfit;

    elseif (yfit>1.71 && yfit<1.73)

        theta = yfit;

    elseif (yfit>1.88 && yfit<1.89)

        theta = -yfit;

    elseif (yfit>1.974 && yfit<1.98)

        theta = -yfit;

    elseif (yfit>2.054 && yfit<2.06)

        theta = yfit;

    elseif (yfit>2.1 && yfit<2.12)

        theta = -yfit;

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

Z(1) = vo(1);
Z(2) = vo(2);

Z = [Z(1) Z(2)];

end





