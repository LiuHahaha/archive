% USAGE: plot_trajectory(real_trajectory,your_trajectory,title_str)
% real_trajectory: the t by 2 matrix of real arm velocities.
% your_trajectory: the t by 2 matrix of velocity predictions.
% title_str: the title of your plot.

function plot_trajectory(real_trajectory,your_trajectory,title_str)

figure;
plot(real_trajectory(:,1),'b','LineWidth',2);
hold on;
plot(real_trajectory(:,2),'r','LineWidth',2);

plot(your_trajectory(:,1),'b:','LineWidth',2);
plot(your_trajectory(:,2),'r:','LineWidth',2);

xlabel('Time-step');
ylabel('Velocity');

title(title_str);

return