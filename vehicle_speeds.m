function [vr,vt]=vehicle_speeds(scenario)

vr= randi([60,80],1);

if (scenario==0)
    
    vt=randi([60,80],1);
    
elseif (scenario==1)
    
    vt=randi([60,80],1);    

end