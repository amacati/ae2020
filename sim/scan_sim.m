function [z] = scan_sim(pose, map)
%SCAN_SIM Summary of this function goes here
%   Detailed explanation goes here
%   Input:      pose                1x3
%               map                 4xnWalls
%
%   Output:     z                   2xN
    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validPose = @(x) isnumeric(x) && all(size(x) == [3,1]);
    validMap = @(x) isnumeric(x) && size(x,2) == 4;
    % Add the arguments to the input parser.
    addRequired(p,'pose',validPose);
    addRequired(p,'map',validMap);
    % Parse all arguments.
    parse(p, pose, map);
    pose = p.Results.pose;
    map = p.Results.map;
    
    %% Laser scanner parameters
    pos = pose(1:2);
    nBeams = 20;
    maxRange = 3;
    sigmaPos = 0.005;
    sigmaTheta = 0.001;    
    
    % Last value is the same as first -> increase nBeams and remove last theta.
    theta = mod(linspace(-pi,pi,nBeams+1)+pose(3)+pi,2*pi)-pi;  
    theta = theta(1:end-1);
    beamVec = [cos(theta);sin(theta)];
    
    %% Calculate the closest wall hit by the sensor
    z = Inf(2,nBeams);
    distMap = map - repelem(pos',2);
    for i = 1:nBeams
        beam = beamVec(:,i);
        scaledDistMap = distMap ./ repelem(beam,2)';
        scaledDistMap(scaledDistMap > maxRange | scaledDistMap <= 0) = Inf;
        % Check if coordinates of intersection are within limits, overwrite with Inf otherwise.
        limitMatrix = scaledDistMap .* flip(repelem(beam,2)');
        limitMatrix(limitMatrix > maxRange) = Inf;
        limitMatrix = limitMatrix + flip(repelem(pos',2));
        limitMask = false(size(distMap));    
        limitMask(:,1:2) = (limitMatrix(:,1:2) > map(:,3)) & (limitMatrix(:,1:2) < map(:,4));
        limitMask(:,3:4) = (limitMatrix(:,3:4) > map(:,1)) & (limitMatrix(:,3:4) < map(:,2));
        scaledDistMap(~limitMask) = Inf;
        % Take the closest wall as measurement if possible.
        minDist = min(min(scaledDistMap));
        if minDist < z(1,i)
            z(1,i) = minDist;
            z(2,i) = theta(i);
        end
    end
    %% Add noise to the measurements if specified and correct angles.
    Sigma = diag([sigmaPos,sigmaTheta]);
    z = z + mvnrnd([0;0],Sigma,nBeams)';
    z(2,:) = mod(z(2,:) - pose(3) + pi, 2*pi) - pi;
    end
