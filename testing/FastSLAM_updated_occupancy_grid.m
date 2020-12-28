map = load_map();
pose = [3; 3; 2];
X = [pose(:);0.5];
pos = pose(1:2);
% Settings
nBeams = 20;
maxRange = 3;
theta = mod(linspace(-pi,pi,nBeams+1)+pose(3)+pi,2*pi)-pi;  
theta = theta(1:end-1);
beamVec = [cos(theta);sin(theta)];

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
z = scan_sim(pose, map);
%% Plot results
doPlot = true;
if doPlot
    for measurement = z
        if measurement(1) ~= Inf
            thetaZ = mod(measurement(2) + pose(3) + pi, 2*pi) - pi;
            hitPos = [cos(thetaZ);sin(thetaZ)]*measurement(1) + pos;
            hold on
            plot(hitPos(1), hitPos(2), 'Marker', 's', 'MarkerSize',5,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);
        end
    end
    hold off
end

M = zeros(1,100,120);
[~, idx] = max(X(4,:));  % Most likely map.
figure;
colormap(gray(201));
% Previous map version
subplot(1,2,1);
priorMap = image([0,12], [10,0], mat2gray(squeeze(M(idx,:,:)),[-127,127])*255, 'AlphaData', 1, 'CDataMapping', 'direct');

% Process scan
M = updated_occupancy_grid(X,z,M);
hitZ = z(:,z(1,:) ~= inf);
thetaZ = mod(hitZ(2,:) + pose(3) + pi, 2*pi) - pi;
hitPos = [cos(thetaZ);sin(thetaZ)].*hitZ(1,:) + pos;
hitPos = int8(hitPos*10)+1;
M(sub2ind(size(M),ones(1,size(hitPos,2)),hitPos(2,:),hitPos(1,:))) = -100;

% Posterior map
subplot(1,2,2);
posteriorMap = image([0,12], [10,0], mat2gray(squeeze(M(idx,:,:)),[-127,127])*255, 'AlphaData', 1, 'CDataMapping', 'direct');
