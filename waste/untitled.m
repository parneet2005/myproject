
set_param('myFinalProject_2/To Workspace',...
    'VariableName','simoutToWorkspace')

% set_param('myFinalProject_2/To File',...
%     'FileName','DOA.mat',...
%     'MatrixName','simoutToFileVariable')

out = sim('myFinalProject_2');

load('DOA1.mat')

subplot(2,1,1)
plot(out.simoutToWorkspace,'-o')
legend('Direction of Arrival')

% subplot(2,1,2)
% plot(simoutToFileVariable,'-o')
% legend('DOA')