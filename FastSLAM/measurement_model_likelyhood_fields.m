function [X] = measurement_model_likelyhood_fields(X,z,M)
%MEASUREMENT_MODEL_MAP Summary of this function goes here
%   Input:      X                   4xM Particles
%               z                   2xNScans Measurements
%               M                   Mx140x160 Particle Maps
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
    sigma = 0.4;  % Might need tuning!
    mapScaling = 10;
    pZHit = 0.4;
    pZUnknown = 0.1;
    pZOutlier = 0.01;

    tTot = 0;
    tFind = 0;
    %% Likelyhood fields
    for particleIdx = 1:size(X,2)
        tic
        pPosX = X(1,particleIdx);
        pPosY = X(2,particleIdx);
        pTheta = X(2,particleIdx);
        % Calculate indices of occupied cells.
        tic
        currMap = squeeze(M(particleIdx,:,:));
        tTot = tTot + toc;
        tic
        [row,col] = find(currMap>0);
        tFind = tFind + toc;
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
        
        % Filter out scans in unknown regions of the map. These
        % measurements get a constant probability.
        scanVal = currMap(sub2ind(size(currMap),scanIdx(2,:),scanIdx(1,:)));
        nUnknownScans = sum(scanVal == 0);
        
        % Reduce number of distance calculations by omitting scans within
        % unknown regions. 
        scanPos = scanPos(:,scanVal ~= 0);
        dMin = min(sqrt((xOcc-scanPos(1,:)).^2 + (yOcc-scanPos(2,:)).^2));
        % Sum of probabilities at measurements
        X(4,particleIdx) = pZHit^(size(dMin,2))*prod(normpdf(dMin, 0,sigma))*pZUnknown^nUnknownScans*pZOutlier^nInvalid;
    end
    fprintf("Reshaping time: %f, Find time: %f\n\n",tTot, tFind);
    X(4,:) = X(4,:) / sum(X(4,:));
end

