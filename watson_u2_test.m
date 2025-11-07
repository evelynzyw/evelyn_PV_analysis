function [U2, p] = watson_u2_test(alpha, n_boot)
% WATSON_U2_TEST  Watson U² uniformity test (p-value)

% input：
%   alpha --theta  
%   n_boot   
%
% output：
%   U2  - Watson U² 
%   p value
%
% ref：
%   Stephens, M. A. (1965). *Goodness-of-Fit for the von Mises Distribution*.
%   Biometrika, 52(1-2), 9–18.

    if nargin < 2
        n_boot = [];
    end
    if iscell(alpha)
        alpha = cell2mat(alpha(:));
    end
    alpha = alpha(:);
    alpha = alpha(~isnan(alpha));
    if isempty(alpha)
        error(' NaN。');
    end

 
    alpha = mod(alpha, 2*pi);
    n = numel(alpha);
    alpha = sort(alpha);

    Ui = alpha / (2*pi);
    Fi = ((1:n)' - 0.5) / n;

    % ---------- calculate U² ----------
    diff_FU = Fi - Ui;
    U2 = sum(diff_FU.^2) + 1/(12*n) - n*(mean(diff_FU))^2;

    % ----------  n_boot----------
    if ~isempty(n_boot)
        Fi_sim = ((1:n)' - 0.5) / n;
        sim_U2 = zeros(n_boot,1);
        for i = 1:n_boot
            Ui_sim = sort(rand(n,1));
            diff_sim = Fi_sim - Ui_sim;
            sim_U2(i) = sum(diff_sim.^2) + 1/(12*n) - n*(mean(diff_sim))^2;
        end
        p = mean(sim_U2 >= U2);
        return;
    end
  
    p = mean(sim_U2 >= U2);

   
    % U2n = (U2 - 0.1/n) * (1 + 0.8/n);
    %
    % if U2n < 0.052
    %     p = 1 - exp(-13.953*U2n);
    % elseif U2n < 0.103
    %     p = 1 - exp(-5.912*U2n + 0.018);
    % elseif U2n < 0.213
    %     p = 1 - exp(-3.227*U2n + 0.047);
    % elseif U2n < 0.405
    %     p = 1 - exp(-1.686*U2n + 0.103);
    % elseif U2n < 0.655
    %     p = 1 - exp(-0.917*U2n + 0.164);
    % else
    %     p = 1 - exp(-0.459*U2n + 0.212);
    % end
    % 
    % p = max(min(p,1), 1e-6);
end
