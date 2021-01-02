function [waypoints] = load_waypoints(path)
%LOAD_WAYPOINTS Summary of this function goes here
%   Detailed explanation goes here
wpDict = cell(2);
wpDict{1} = [12.5 8;13 5; 12.5 8; 13 10; 11 11; 8 10.5; 7.5 9; 7.5 6;
             7.7 4; 6 3; 4 3; 3 5; 4 8; 8 8; 9.5 7.5; 8 8]';
wpDict{2} = [7.5 6; 7.5 10; 7.5 6; 7.5 3.6; 11 3.5; 13 6; 13 9.5; 11 11; 
             6 11; 3 11; 3 7; 3 3.5; 6 2.5; 7 3; 6 3.5; 5 5; 3 5; 3 7.5; 
             6 8; 9.5 8; 6 8]';
waypoints = wpDict{path};
end

