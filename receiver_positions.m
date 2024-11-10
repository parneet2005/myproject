function [A_receivers_x,A_receivers_y,carx,cary]=receiver_positions(A,B,rw,rh,receiver_orient)


if (receiver_orient==0)
    %Coordinates for all 4 quadrant receivers on vehicles A
    tlrAx=A(1) - rw; 
    tlrAy=A(2) + rh;
    trrAx=A(1) + rw;
    trrAy=A(2) + rh;
    blrAx=A(1) - rw;
    blrAy=A(2) - rh;
    brrAx=A(1) + rw;
    brrAy=A(2) - rh;


    %Coordinates for all 4 quadrant receivers on vehicle B
    tlrBx=B(1) - rw; 
    tlrBy=B(2) + rh;
    trrBx=B(1) + rw;
    trrBy=B(2) + rh;
    blrBx=B(1) - rw;
    blrBy=B(2) - rh;
    brrBx=B(1) + rw;
    brrBy=B(2) - rh;
    
else
    %Coordinates for all 4 quadrant receivers on vehicles A
    tlrAx=A(1); 
    tlrAy=A(2) + rh;
    trrAx=A(1) + rw;
    trrAy=A(2);
    blrAx=A(1) - rw;
    blrAy=A(2);
    brrAx=A(1);
    brrAy=A(2) - rh;


    %Coordinates for all 4 quadrant receivers on vehicle B
    tlrBx=B(1); 
    tlrBy=B(2) + rh;
    trrBx=B(1) + rw;
    trrBy=B(2);
    blrBx=B(1) - rw;
    blrBy=B(2);
    brrBx=B(1);
    brrBy=B(2) - rh;
    
end


%car coordinates
% x axis of both cars A and B
carx = [tlrAx, trrAx, blrAx, brrAx, tlrBx, trrBx, blrBx, brrBx]; 
% y axis of both cars A and B
cary = [tlrAy, trrAy, blrAy, brrAy, tlrBy, trrBy, blrBy, brrBy];

%Receiver vehicle A receiver coordinates
%Atlr = [tlrAx tlrAy]; %B top left receiver coordinates
%Atrr = [trrAx trrAy]; %B top right receiver coordinates
%Ablr = [blrAx blrAy]; %B bottom left receiver coordinates
%Abrr = [brrAx brrAy]; %B bottom right receiver coordinates
A_receivers_x = [tlrAx trrAx blrAx brrAx];
A_receivers_y = [tlrAy trrAy blrAy brrAy];

%Transmitter vehicle B receiver coordinates
Btlr = [tlrBx tlrBy]; %B top left receiver coordinates
Btrr = [trrBx trrBy]; %B top right receiver coordinates
Bblr = [blrBx blrBy]; %B bottom left receiver coordinates
Bbrr = [brrBx brrBy]; %B bottom right receiver coordinates


end