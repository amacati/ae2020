function [waypoints] = load_waypoints(varargin)
%LOAD_WAYPOINTS Summary of this function goes here
%   Detailed explanation goes here
waypoints = [12.5 8;13 5; 12.5 8; 13 10; 11 11; 8 10.5; 7.5 9; 7.5 6;
             7.7 4; 6 3; 4 3; 3 5; 4 8; 8 8; 9.5 7.5; 8 8]';

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

