p = load_waypoints();
map = load_map();

nSplines = size(p,2)-3;

%% Simulation of the robot moving. Delta t = 0.1s.
figure()
hold on
for idx = 1:size(map,1)
    wall = map(idx,:);
    x = wall(1:2);
    y = wall(3:4);
    plot(x,[y(1), y(1)],'k', 'LineWidth', 2);
    plot(x,[y(2), y(2)],'k', 'LineWidth', 2);
    plot([x(1), x(1)],y,'k', 'LineWidth', 2);
    plot([x(2), x(2)],y,'k', 'LineWidth', 2);
    xlim([-1,13])
    ylim([-1,11])
end

for i = 1:nSplines
    p0 = p(:,i);
    p1 = p(:,i+1);
    p2 = p(:,i+2);
    p3 = p(:,i+3);
    for t = 0.05:0.1:0.95
        [pose,vel] = catmull_spline(p0, p1, p2, p3, t);
        v = vecnorm(vel(1:2));  % TODO: Insert noise
        omega = vel(3);  % TODO: Insert noise
        % Plotting
        scatter(pose(1),pose(2),'Marker', 'x', 'MarkerEdgeColor', 'k');
        z = scan_sim(pose,map);
        z = z(:,~any(isnan(z) | isinf(z),1));  % Filter out invalid measurements.
        z(2,:) = mod(z(2,:) + pose(3) + pi,2*pi) - pi;
        scan_pos = [pose(1) + cos(z(2,:)).*z(1,:);pose(2) + sin(z(2,:)).*z(1,:)];
        scan_plt = scatter(scan_pos(1,:),scan_pos(2,:), 'filled', 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[1 .0 .0],'LineWidth',0.01);
        pause(0.1);
        delete(scan_plt)
    end
end
