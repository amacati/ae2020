function [map] = load_map(mapIndex)
%LOAD_MAP Loads the map objects from a map cell array.
%   Creates maps from wall definitions.
    
    %% Parsing of initialization arguments.
    p = inputParser;
    % Define validation expressions for each argument.
    validIndex = @(x) (isinteger(x) || floor(x) == x) && (1 <= x) && (x <= 1);
    % Add the arguments to the input parser.
    addRequired(p,'mapIndex',validIndex);
    % Parse all arguments.
    parse(p, mapIndex);
    mapIndex = p.Results.mapIndex;
    
    %% Define map walls
    walls = [0,0.1,0,2;
             1,1.1,-1,3;
             -2,1,3,3.1;
             ];
    
    for idx = 1:size(walls,1)
        wall = walls(idx,:);
        x = wall(1:2);
        y = wall(3:4);
        hold on
        plot(x,[y(1), y(1)],'k', 'LineWidth', 2);
        plot(x,[y(2), y(2)],'k', 'LineWidth', 2);
        plot([x(1), x(1)],y,'k', 'LineWidth', 2);
        plot([x(2), x(2)],y,'k', 'LineWidth', 2);
        xlim([-5,5])
        ylim([-5,5])
    end
    hold off
    map = walls;
end

