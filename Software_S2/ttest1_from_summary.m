function [t, df, p] = ttest1_from_summary(m, s, n, mu0, tail)
%TTEST1_FROM_SUMMARY One-sample t-test from summary statistics
%
% Inputs:
%   m    : sample mean
%   s    : sample standard deviation
%   n    : sample size
%   mu0  : null hypothesis mean
%   tail : 'both' (default), 'right', or 'left'
%
% Hypotheses:
%   'both' : H1: m ~= mu0
%   'right': H1: m > mu0
%   'left' : H1: m < mu0
%
% Outputs:
%   t  : t statistic
%   df : degrees of freedom
%   p  : p-value

    % Basic input checks
    if n <= 1
        error('n must be > 1.');
    end
    if s < 0
        error('Standard deviation must be nonnegative.');
    end

    se = s / sqrt(n);

    if se == 0
        error('Standard error is zero; test statistic is undefined.');
    end

    t = (m - mu0) / se;
    df = n - 1;

    switch lower(tail)
        case 'both'
            p = 2 * (1 - tcdf(abs(t), df));

        case 'right'
            % H1: m > mu0
            p = 1 - tcdf(t, df);

        case 'left'
            % H1: m < mu0
            p = tcdf(t, df);

        otherwise
            error('tail must be ''both'', ''right'', or ''left''.');
    end

     % print out the p-value
    if p >= 0.001
        fprintf('p = %.3f\n\n', p);
    else
        fprintf('p < 0.001\n\n');
    end
    
end