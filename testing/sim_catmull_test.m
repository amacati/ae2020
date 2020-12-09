p = [1 1;0 0; 1 1; 2 0; 3 1; 4 0; 5 1; 4 0]';  % ; 2 1; 3 3

t = linspace(0,1,200);

nSplines = size(p,2)-3;
pose = zeros(3,nSplines*200);
vel = ones(3,nSplines*200);

for i = 1:nSplines
    p0 = p(:,i);
    p1 = p(:,i+1);
    p2 = p(:,i+2);
    p3 = p(:,i+3);
    [pose(:,i*200-199:i*200),vel(:,i*200-199:i*200)] = catmull_spline(p0, p1, p2, p3, t);
end

tiledlayout(2,2)
% Top left plot
nexttile
plot(pose(1,:),pose(2,:))
xlim([-1 3])
ylim([-1 3])
title('Pose')

% Top right plot
nexttile
plot(pose(3,:))
title('Orientation')

% Bottom left plot
nexttile
plot(vecnorm(vel(1:2,:),1))
title('Speed')

% Bottom right plot
nexttile
plot(vel(3,:))
title('Omega')