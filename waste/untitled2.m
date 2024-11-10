
set_param('myFinalProject_2/To Workspace',...
    'VariableName','simoutToWorkspace')

out = sim('myFinalProject_2');

load('predicated_coordinate.mat')

subplot(2,1,1)
plot(out.simoutToWorkspace,'-o')
legend('coordinate')