function [X_bar] = sample_motion_model(v,omega,X)
%SAMPLE_MOTION_MODEL Predict particles according to the motion model.
%   Input:      v                   1x1 Velocity
%               omega               1x1 Rotational velocity
%               X                   4xM Particles
%
%   Output:     X                   4xM Updated particles with motion model
    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validVelocity = @(x) isnumeric(x) && isscalar(x);
    validOmega = @(x) isnumeric(x) && isscalar(x);
    validParticles = @(x) isnumeric(x) && size(x,1) == 4;
    % Add the arguments to the input parser.
    addRequired(p,'v',validVelocity);
    addRequired(p,'omega',validOmega);
    addRequired(p,'X',validParticles);
    % Parse all arguments.
    parse(p, v, omega, X);
    v = p.Results.v;
    omega = p.Results.omega;
    X = p.Results.X;
    
    %% Motion model sample
    M = size(X,2);
    R = [1 0 0;0 1 0;0 0 0.1]*1e-8;     % covariance matrix of motion model | shape 3X3
    delta_t = 0.1;                     % delta_t is always 0.1 in the sim.
    
    X_bar = X;
    X_bar(1:2,:) = X(1:2,:) + delta_t*v*[cos(X(3,:));sin(X(3,:))];
    X_bar(3,:) = X(3,:) + delta_t*omega;
    X_bar(1:3,:) = X_bar(1:3,:) + mvnrnd([0;0;0],R,M)';
    X_bar(3,:) = mod(X_bar(3,:)+pi,2*pi) - pi;
end

