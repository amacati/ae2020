function [X] = measurement_model_likelyhood_fields(X,z,M)
%MEASUREMENT_MODEL_MAP Summary of this function goes here
%   Input:      X                   4xM Particles
%               z                   2xNScans Measurements
%               M                   140x160xM Particle Maps
%
%   Output:     X                   4xM Updated particles weights with measurement
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
    %% Function config
    sigma = 0.15;  % Might need tuning!
    mapScaling = 10;
    pZHit = 0.5;
    pZUnknown = 0.3;
    pZOutlier = 0.01;

    %% Likelyhood fields
    for particleIdx = 1:size(X,2)
        pPosX = X(1,particleIdx);
        pPosY = X(2,particleIdx);
        pTheta = X(3,particleIdx);
        % Calculate indices of occupied cells.
        currMap = squeeze(M(:,:,particleIdx));

        [row,col] = find(currMap>0);
        xOcc = (col-0.5)/mapScaling;
        yOcc = (row-0.5)/mapScaling;
        
        % Calculate hit positions in the map.
        zHit = z(:,z(1,:) ~= inf);
        zHit(2,:) = mapAngle(zHit(2,:) + pTheta);
        scanPos = [pPosX + cos(zHit(2,:)).*zHit(1,:);pPosY + sin(zHit(2,:)).*zHit(1,:)];
        scanIdx = int16(scanPos*10+0.5);
        
        % Filter out out of range subscripts, assign invalid probability.
        nInvalid = sum(scanIdx(1,:)>160 | scanIdx(2,:)>140 | scanIdx(1,:)<1 | scanIdx(2,:)<1);
        scanIdx = scanIdx(:,scanIdx(1,:)<=160 & scanIdx(2,:)<=140 & scanIdx(1,:)>0 & scanIdx(2,:)>0);
        
        % Save scan values to recognize unknown regions of the map later
        % on for special treatment.
        scanVal = currMap(sub2ind(size(currMap),scanIdx(2,:),scanIdx(1,:)));

        % Calculate minimum distance of all measurements to an occupied
        % grid cell.
        dMin = min(sqrt((xOcc-scanPos(1,:)).^2 + (yOcc-scanPos(2,:)).^2));
        % In case the map was empty, assume infinite distances.
        if isempty(row)
            dMin = inf(1,size(scanPos,2));
        end
        % Sum of probabilities at measurements. If unexplored cells have
        % higher probability with dMin calculation, take the highest
        % probability.
        probVec = normpdf(dMin,0,sigma);
        nUnknownScans = sum(~((pZHit*probVec > pZUnknown) & scanVal == 0 | scanVal ~= 0));
        probVec = probVec((pZHit*probVec > pZUnknown) & scanVal == 0 | scanVal ~= 0);
        X(4,particleIdx) = pZHit^(size(probVec,2))*prod(probVec)*pZUnknown^nUnknownScans*pZOutlier^nInvalid;
    end
    X(4,:) = X(4,:) / sum(X(4,:));
end

