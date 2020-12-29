function [map] = load_map(varargin)
%LOAD_MAP Loads the map objects from a map cell array.
%   Creates maps from wall definitions.
    
    %% Define map walls
    walls = [2,14,2,12;
             4,7,6,7.5;
             6,7,4,6;
             4,7,8.5,10;
             8,9,9,10;
             9,10,9.5,10;
             10,12,6,10;
             8,9,6,7;
             9,10,6,6.5;
             8,10,4,6;
             10,11,5,6;
             12,14,2,4;
             4,6,2,2.3;
             8,10,2,2.3;
             5,6,11.5,12;
             8,9,11.5,12;
             11,12,11.5,12;
             13.5,14,8,10;
             3.7,4.3,3.7,4.3;
             ];
    if nargin > 0
        for idx = 1:size(walls,1)
            wall = walls(idx,:);
            x = wall(1:2);
            y = wall(3:4);
            hold on
            plot(x,[y(1), y(1)],'k', 'LineWidth', 2);
            plot(x,[y(2), y(2)],'k', 'LineWidth', 2);
            plot([x(1), x(1)],y,'k', 'LineWidth', 2);
            plot([x(2), x(2)],y,'k', 'LineWidth', 2);
            xlim([-1,13])
            ylim([-1,11])
        end
        hold off
    end
    map = walls;
end

