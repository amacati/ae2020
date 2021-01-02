map = load_map();
poses = [3; 3; 1];

%% Parameters of scan_sim function
nBeams = 50;
maxRange = 3;

for pose = poses
    pos = pose(1:2);
    theta = mod(linspace(-pi,pi,nBeams+1)+pose(3)+pi,2*pi)-pi;  
    theta = theta(1:end-1);
    beamVec = [cos(theta);sin(theta)];

    %% Plot map and beams
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
    for i = 1:nBeams
        hold on
        plot([pose(1),pose(1) + beamVec(1,i)*maxRange],[pose(2),pose(2) + beamVec(2,i)*maxRange],'k', 'LineWidth', 1);    
    end
    %% Perform measurement
    tic
    z = scan_sim(pose, map);
    toc
    %% Plot results
    for measurement = z
        if measurement(1) ~= Inf
            thetaZ = mod(measurement(2) + pose(3) + pi, 2*pi) - pi;
            hitPos = [cos(thetaZ);sin(thetaZ)]*measurement(1) + pos';
            hold on
            plot(hitPos(1), hitPos(2), 'Marker', 's', 'MarkerSize',5,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);
        end
    end
    hold off
end
