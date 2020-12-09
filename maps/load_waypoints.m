function [waypoints] = load_waypoints(varargin)
%LOAD_WAYPOINTS Summary of this function goes here
%   Detailed explanation goes here
waypoints = [10.5 6;11 3; 10.5 6; 11 8; 9 9; 6 8.5; 5.5 7; 5.5 4;
             5.7 2; 4 1; 2 1;4 1]';

t = linspace(0,1,200);

nSplines = size(waypoints,2)-3;
pose = zeros(3,nSplines*200);
vel = ones(3,nSplines*200);

for i = 1:nSplines
    p0 = waypoints(:,i);
    p1 = waypoints(:,i+1);
    p2 = waypoints(:,i+2);
    p3 = waypoints(:,i+3);
    [pose(:,i*200-199:i*200),vel(:,i*200-199:i*200)] = catmull_spline(p0, p1, p2, p3, t);
end

if nargin > 0
    plot(pose(1,:), pose(2,:));
end
end

