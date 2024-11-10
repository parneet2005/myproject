%This function is used to set the speed of the vehicles as well as possibly
%updating the vehicle positions as they are moving

function [final_A, final_B, Z, ZZ, cary]=speed_of_vehicles(A,B,Z,vr,vt,cary,t,elap_t2,scenario)


%total distance travelled within time period
timestep_speed_A = (vr/1e9)*t+vr*elap_t2;
timestep_speed_B = (vt/1e9)*t+vt*elap_t2;



%add the distance travelled within time period to initial positions
final_A = [A(1) A(2)+timestep_speed_A];
ZZ =  [Z(1) Z(2)];
Z = [Z(1) Z(2)+timestep_speed_A];
final_B = [B(1) B(2)+timestep_speed_B];

cary=[cary(1)+(vr/1e9)*t+vr*elap_t2,cary(2)+(vr/1e9)*t+vr*elap_t2,...
cary(3)+(vr/1e9)*t+vr*elap_t2,cary(4)+(vr/1e9)*t+vr*elap_t2,...
cary(5)+(vr/1e9)*t+vr*elap_t2,cary(6)+(vr/1e9)*t+vr*elap_t2,...
cary(7)+(vr/1e9)*t+vr*elap_t2,cary(8)+(vr/1e9)*t+vr*elap_t2];
   



end
