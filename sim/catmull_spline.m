function [pose, vel] = catmull_spline(p0, p1, p2, p3, t)
%CATMULL_SPLINE Calculates the robot's simulated pose and odometry.
%   Pose and velocities are calculated according to Catmull-Rom splines.

    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validPoint = @(x) isnumeric(x) && all(size(x) == [2,1]);
    validTime = @(x) isnumeric(x) && size(x,1) == 1;
    % Add the arguments to the input parser.
    addRequired(p,'p0',validPoint);
    addRequired(p,'p1',validPoint);
    addRequired(p,'p2',validPoint);
    addRequired(p,'p3',validPoint);
    addRequired(p,'t',validTime);
    % Parse all arguments.
    parse(p, p0, p1, p2, p3, t);
    p0 = p.Results.p0;
    p1 = p.Results.p1;
    p2 = p.Results.p2;
    p3 = p.Results.p3;
    t = p.Results.t;

%% Define spline polynomial factors
    a = p1;
    b = -p0 + p2;
    c = p0*2 - p1*5 + p2*4.0 - p3;
    d = -p0 + p1*3 - p2*3 + p3;
    
    %% Calculate positions and derivatives
    position = 0.5*(2*a + b*t + c*t.^2 + d*t.^3);
    vLin = 0.5*(b + 2*c*t + 3*d*t.^2);
    acc = (c + 3*d*t);
    angle = atan2(vLin(2,:),vLin(1,:));
    omega = (vLin(1,:).*acc(2,:) - vLin(2,:).*acc(1,:))./sum(vLin.^2,1);
    omega(isnan(omega)) = 0;
    
    pose = [position;angle];
    vel = [vLin;omega];
end

