function [X_bar] = sample_motion_model(v,omega,X, sigmaV, sigmaOmega)
%SAMPLE_MOTION_MODEL Predict particles according to the motion model.
%   Input:      v                   1x1 Velocity
%               omega               1x1 Rotational velocity
%               X                   4xM Particles
%               sigmaV              1x1 Standard deviation of V noise.
%               sigmaOmega          1x1 Standard deviation of omega noise.
%
%   Output:     X                   4xM Updated particles with motion model
    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validVelocity = @(x) isnumeric(x) && isscalar(x);
    validOmega = @(x) isnumeric(x) && isscalar(x);
    validParticles = @(x) isnumeric(x) && size(x,1) == 4;
    validSigma = @(x) isnumeric(x) && isscalar(x) && x >= 0;
    % Add the arguments to the input parser.
    addRequired(p,'v',validVelocity);
    addRequired(p,'omega',validOmega);
    addRequired(p,'X',validParticles);
    addRequired(p,'sigmaV', validSigma);
    addRequired(p,'sigmaOmega', validSigma);
    % Parse all arguments.
    parse(p, v, omega, X, sigmaV, sigmaOmega);
    v = p.Results.v;
    omega = p.Results.omega;
    X = p.Results.X;
    sigmaV = p.Results.sigmaV;
    sigmaOmega = p.Results.sigmaOmega;
    
    %% Motion model sample
    M = size(X,2);
    R = [sigmaV^2 0 0;0 sigmaV^2 0;0 0 sigmaOmega^2];   % Covariance matrix of motion model | shape 3X3
    delta_t = 0.1;                                      % delta_t is always 0.1 in the sim.
    
    X_bar = X;
    X_bar(1:2,:) = X(1:2,:) + delta_t*v*[cos(X(3,:));sin(X(3,:))];
    X_bar(3,:) = X(3,:) + delta_t*omega;
    X_bar(1:3,:) = X_bar(1:3,:) + mvnrnd([0;0;0],R,M)';
    X_bar(3,:) = mapAngle(X_bar(3,:));
end

