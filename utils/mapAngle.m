function [angle] = mapAngle(angle)
%MAPANGLE Maps an angle to the interval of [-pi, pi]
angle = mod(angle + pi, 2*pi) - pi;
end

