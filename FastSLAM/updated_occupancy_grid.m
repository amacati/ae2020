function [M] = updated_occupancy_grid(X,z,M)
%UPDATED_OCCUPANCY_GRID Summary of this function goes here
%   Input:      X                   4xM Particles
%               z                   2xNScans Measurements
%               M                   Mx100x120 Particle Maps
%
%   Output:     M                   Mx100x120 Updated particle maps
%
%   Optimization: Make sure to call updated_occupancy_grid only if
%   particle gets resampled, compute only once for each particle!
    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validParticles = @(x) isnumeric(x) && size(x,1) == 4;
    validScan = @(x) isnumeric(x) && size(x,1) == 2;
    validMaps = @(x) isnumeric(x);
    % Add the arguments to the input parser.
    addRequired(p,'X',validParticles);
    addRequired(p,'z',validScan);
    addRequired(p,'M',validMaps);
    % Parse all arguments.
    parse(p, X, z, M);
    X = p.Results.X;
    z = p.Results.z;
    M = p.Results.M;

    %% Constants
    mapScaling = 10;
    maxRange = 3;
    rayCastingThreshold = 0.1;
    %% Tunable parameters
    maxDeviation = 0.1;     
    lZero = log(0.2);       
    lOcc = log(0.000000001);
    lFree = log(2000000000);
    %% Inverse sensor model
    % Loop over all particle maps and update values.
    for particleIdx = 1:size(X,2)
        pPosX = X(1,particleIdx);
        pPosY = X(2,particleIdx);
        omega = X(3,particleIdx);
        % Cut map window for position
        xMinIdx = round(max(0,(pPosX-maxRange))*mapScaling);
        xMaxIdx = round(min(119,(pPosX+maxRange)*mapScaling));
        yMinIdx = round(max(0,(pPosY-maxRange))*mapScaling);
        yMaxIdx = round(min(99,(pPosY+maxRange)*mapScaling));
        x = (repmat(xMinIdx:xMaxIdx,size(yMinIdx:yMaxIdx,2),1)+0.5)/mapScaling;
        y = (repmat((yMaxIdx:-1:yMinIdx)',1,size(xMinIdx:xMaxIdx,2))+0.5)/mapScaling;
        r = sqrt((x-pPosX).^2 + (y-pPosY).^2);
        phi = atan2(y-pPosY,x-pPosX) - omega;
        % Stack angles in third dimension to compute minimum angle values
        % for all pixels simultaneously.
        zCell = num2cell(z(2,:));
        ZAngle = cat(3, zCell{:});        
        [~, k] = min(abs(mapAngle(repmat(phi,1,1,size(z,2)) - repmat(ZAngle,[size(phi),1]))),[],3);
        z1 = z(1,:);
        z2 = z(2,:);
        % Compute masks for map update.
        angleMask = abs(mapAngle(phi - z2(k))).*r > rayCastingThreshold;
        radMask = min(maxRange, z1(k)+1/(4*mapScaling)) < r;
        lZeroMask = angleMask | radMask;
        lOccMask = z1(k) < maxRange & abs(r-z1(k)) < 1/(2*mapScaling);
        % Order matters, later updates overwrite previous ones.
        lFreeMask = z1(k) >= r;
        mapUpdate = lFreeMask * lFree;
        mapUpdate(lOccMask) = lOcc;
        mapUpdate(lZeroMask) = lZero;
        % Update the selected map section. Y and X are inverted in M.
        cutIdxX = int16(xMinIdx:xMaxIdx) + 1;
        cutIdxY = int16(yMinIdx:yMaxIdx) + 1;
        M(particleIdx,cutIdxY,cutIdxX) = M(particleIdx,cutIdxY,cutIdxX) + reshape(flip(mapUpdate,1),[1,size(flip(mapUpdate,1))]) - lZero;
    end
    
end

