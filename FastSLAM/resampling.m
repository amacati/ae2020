function [X,sampleIdx] = resampling(X)
%RESAMPLING Summary of this function goes here
%   Systematic resampling of the particles and the map
    nParticles = size(X,2);
    w = cumsum(X(4,:));
    rnd = (0:nParticles-1)/nParticles + rand()/nParticles;
    [~, idx] = max(w >= rnd', [], 2);  % Max takes first argument that is 1
    [row, ~] = ind2sub([nParticles,nParticles],idx);
    sampleIdx = row';
    X = X(:,sampleIdx);
end

