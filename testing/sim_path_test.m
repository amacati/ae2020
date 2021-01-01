map = load_map();
p = load_waypoints(2);
disp(p)
t = linspace(0,1,200);
nSplines = size(p,2)-3;

for idx = 1:size(map,1)
    wall = map(idx,:);
    x = wall(1:2);
    y = wall(3:4);
    hold on
    plot(x,[y(1), y(1)],'k', 'LineWidth', 2);
    plot(x,[y(2), y(2)],'k', 'LineWidth', 2);
    plot([x(1), x(1)],y,'k', 'LineWidth', 2);
    plot([x(2), x(2)],y,'k', 'LineWidth', 2);
    xlim([-5,5])
    ylim([-5,5])
end

pose = zeros(3,nSplines*200);
vel = ones(3,nSplines*200);
for i = 1:nSplines
    p0 = p(:,i);
    p1 = p(:,i+1);
    p2 = p(:,i+2);
    p3 = p(:,i+3);
    [pose(:,i*200-199:i*200),vel(:,i*200-199:i*200)] = catmull_spline(p0, p1, p2, p3, t);
end

hold on
plot(pose(1,:), pose(2,:));
hold off
