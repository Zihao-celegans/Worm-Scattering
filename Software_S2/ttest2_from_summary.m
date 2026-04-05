function [t, df, p] = ttest2_from_summary(m1, s1, n1, m2, s2, n2, vartype, tail)
%TTEST_FROM_SUMMARY t-test from summary statistics
%
% Inputs:
%   m1, s1, n1 : mean, SD, and sample size for group 1
%   m2, s2, n2 : mean, SD, and sample size for group 2
%   vartype    : 'welch' or 'equal'
%   tail       : 'both', 'right', or 'left'
%
% Hypotheses:
%   'both' : H1: m1 ~= m2
%   'right': H1: m1 > m2
%   'left' : H1: m1 < m2
%
% Outputs:
%   t  : t statistic
%   df : degrees of freedom
%   p  : p-value


    % Basic input checks
    if any([n1, n2] <= 1)
        error('n1 and n2 must both be > 1.');
    end
    if any([s1, s2] < 0)
        error('Standard deviations must be nonnegative.');
    end

    switch lower(vartype)
        case 'welch'
            se = sqrt(s1^2/n1 + s2^2/n2);
            t = (m1 - m2) / se;
            df = (s1^2/n1 + s2^2/n2)^2 / ...
                 ((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1));

        case 'equal'
            sp2 = ((n1-1)*s1^2 + (n2-1)*s2^2) / (n1+n2-2);
            se = sqrt(sp2 * (1/n1 + 1/n2));
            t = (m1 - m2) / se;
            df = n1 + n2 - 2;

        otherwise
            error('vartype must be ''welch'' or ''equal''.');
    end

    if se == 0
        error('Standard error is zero; test statistic is undefined.');
    end

    switch lower(tail)
        case 'both'
            p = 2 * (1 - tcdf(abs(t), df));

        case 'right'
            % H1: m1 > m2
            p = 1 - tcdf(t, df);

        case 'left'
            % H1: m1 < m2
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