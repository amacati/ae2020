function [pose,u] = robot_sim(splines, splineID, t)
%ROBOT_SIM Summary of this function goes here
%   Detailed explanation goes here


    [pose, vel] = catmull_spline(p0, p1, p2, p3, t);

    
end

