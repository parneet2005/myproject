function [Z] = Trilateration_further(Ad,orderx,ordery,Number_of_receivers,ls,weights)
%Find the location of the transmitter vehicle

    %A matrix
    A1 = [1 -2*orderx(1) -2*ordery(1)];
    A2 = [1 -2*orderx(2) -2*ordery(2)];
    A3 = [1 -2*orderx(3) -2*ordery(3)];
    A4 = [1 -2*orderx(4) -2*ordery(4)];

    %weights
    w1=1/sqrt(Ad(1)^2+(orderx(1)+ordery(1)^2));
    w2=1/sqrt(Ad(1)^2+(orderx(2)+ordery(2)^2));
    w3=1/sqrt(Ad(1)^2+(orderx(3)+ordery(3)^2));
    w4=1/sqrt(Ad(1)^2+(orderx(4)+ordery(4)^2));
    w=[w1;w2;w3;w4];



    if (Number_of_receivers==4) && (weights==0)
        A = [A1;A2;A3;A4];

        b = [Ad(1)^2-orderx(1)^2-ordery(1)^2;...
            Ad(2)^2-orderx(2)^2-ordery(2)^2;...
            Ad(3)^2-orderx(3)^2-ordery(3)^2;...
            Ad(4)^2-orderx(4)^2-ordery(4)^2];

    elseif (Number_of_receivers==4) && (weights==1)

        A = [A1*w(1);A2*w(2);A3*w(3);A4*w(4)];

        b = [(Ad(1)^2-orderx(1)^2-ordery(1)^2)*w(1);...
            (Ad(2)^2-orderx(2)^2-ordery(2)^2)*w(2);...
            (Ad(3)^2-orderx(3)^2-ordery(3)^2)*w(3);...
            (Ad(4)^2-orderx(4)^2-ordery(4)^2)*w(4)];


    elseif (Number_of_receivers==3) && (weights==0)
        A = [A1;A2;A3];

        b = [Ad(1)^2-orderx(1)^2-ordery(1)^2;...
             Ad(2)^2-orderx(2)^2-ordery(2)^2;...
             Ad(3)^2-orderx(3)^2-ordery(3)^2];


    else
        A = [A1*w(1);A2*w(2);A3*w(3)];

        b = [(Ad(1)^2-orderx(1)^2-ordery(1)^2)*w(1);...
             (Ad(2)^2-orderx(2)^2-ordery(2)^2)*w(2);...
             (Ad(3)^2-orderx(3)^2-ordery(3)^2)*w(3)];

    end

    B=A.';

    if (ls==0)

        X = (B*A)\B*b;


    else
        X =  A\b;

    end
    
    Z = [X(2) X(3)];


end

 
 
 
 
 
 
 