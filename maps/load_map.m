function [map] = load_map(varargin)
%LOAD_MAP Loads the map objects from a map cell array.
%   Creates maps from wall definitions.
    
    %% Define map walls
    walls = [0,12,0,10;
             2,5,4,5.5;
             4,5,2,4;
             2,5,6.5,8;
             6,7,7,8;
             7,8,7.5,8;
             8,10,4,8;
             6,7,4,5;
             7,8,4,4.5;
             6,8,2,4;
             8,9,3,4;
             10,12,0,2;
             2,4,0,0.3;
             6,8,0,0.3;
             3,4,9.5,10;
             6,7,9.5,10;
             9,10,9.5,10;
             11.5,12,6,8;
             1.7,2.3,1.7,2.3;
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

