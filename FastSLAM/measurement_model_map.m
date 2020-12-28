function [X] = measurement_model_map(X,M)
%MEASUREMENT_MODEL_MAP Summary of this function goes here
%   Input:      X                   4xM Particles
%               M                   Mx100x120 Particle Maps
%
%   Output:     X                   4xM Updated particles weights with measurement
    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validParticles = @(x) isnumeric(x) && size(x,1) == 4;
    validMaps = @(x) isnumeric(x);
    % Add the arguments to the input parser.
    addRequired(p,'X',validParticles);
    addRequired(p,'M',validMaps);
    % Parse all arguments.
    parse(p, X, M);
    X = p.Results.X;
    M = p.Results.M;

    
end

