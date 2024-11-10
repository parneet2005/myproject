function [r_rw,r_rh,r_h, t_rh, t_rw, t_h]=vehicle_dimensions()

rec= randi([1,5],1);
tran= randi([1,5],1);

if (rec==1)

    r_rh = 4.5/2;
    r_rw = 1.8/2;
    r_h = 1.6;

elseif (rec==2)

    r_rh = 4.55/2;
    r_rw = 1.75/2;
    r_h = 1.5;

elseif (rec==3)

    r_rh = 5/2;
    r_rw = 2/2;
    r_h = 1.8;

elseif (rec==4)

    r_rh = 5.3/2;
    r_rw = 1.92/2;
    r_h = 1.5;

elseif (rec==5)

    r_rh = 3.4/2;
    r_rw = 1.48/2;
    r_h = 2;


end

if (tran==1)

    t_rh = 4.5/2;
    t_rw = 1.8/2;
    t_h = 1.6;

elseif (tran==2)

    t_rh = 4.55/2;
    t_rw = 1.75/2;
    t_h = 1.5;

elseif (tran==3)

    t_rh = 5/2;
    t_rw = 2/2;
    t_h = 1.8;

elseif (tran==4)

    t_rh = 5.3/2;
    t_rw = 1.92/2;
    t_h = 1.5;

elseif (tran==5)

    t_rh = 3.4/2;
    t_rw = 1.48/2;
    t_h = 2;


end

end