%% Load map and gridmap
fprintf('\nWARNING: Measurement model test is more insightful with nScans set to ~5!\n\n');
map = load_map();
filepath = fileparts(mfilename('fullpath'));
file = matfile(fullfile(filepath, 'M_test.mat'));
M = file.M;
M = repmat(M,1,1,9);
% Create pose and particles
pose = [12;5;0];
X = zeros(4,9);
i = 1;
for dx = [-0.3 0 0.3]
    for dy = [-0.3 0 0.3]
        X(1:3,i) = pose - [dx; dy; 0];
        i = i + 1;
    end
end
X(4,:) = 1/size(X,2);
z = scan_sim(pose,map);

%% Plot the map with scans, calculate probabilities
X = measurement_model_likelyhood_fields(X,z,M);
figure;
hold on;
colormap('gray');
[row, col] = find(squeeze(M(:,:,1))>0);
scatter((col-0.5)/10,(row-0.5)/10, 'filled', 'MarkerEdgeColor',[0 0 0],...
      'MarkerFaceColor',[0 0 0],'LineWidth',0.01);
for particle = X
    hold on
    fprintf('probability of particle [%.2f %.2f]: %.2f\n\n',particle(1),particle(2),particle(4));
    ptTemp = measurement_model_likelyhood_fields(particle,z,M);
    zViz = z(:,~any(isnan(z) | isinf(z),1));  % Filter out invalid measurements.
    zViz(2,:) = mod(zViz(2,:) + particle(3) + pi,2*pi) - pi;
    scan_pos = [particle(1) + cos(zViz(2,:)).*zViz(1,:);particle(2) + sin(zViz(2,:)).*zViz(1,:)];
    scan_plt = scatter(scan_pos(1,:),scan_pos(2,:), 'filled', 'MarkerEdgeColor',[0 0 0],...
          'MarkerFaceColor',[1 .0 .0],'LineWidth',0.01);
    scatter(particle(1),particle(2), 'filled', 'MarkerEdgeColor',[0 0 0],...
          'MarkerFaceColor',[.0 1.0 .0],'LineWidth',0.01);
    hold off;    
    pause
end
disp('Finished measurement model test.');