function [fitresult, gof] = createPowerFit(x_in, y_in)

[xData, yData] = prepareCurveData( x_in, y_in );

% Set up fittype and options.
ft = 'linearinterp';
opts = fitoptions( 'Method', 'LinearInterpolant' );
opts.ExtrapolationMethod = 'linear';
opts.Normalize = 'on';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'Reading vs. red_theta', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'red_theta', 'Interpreter', 'none' );
% ylabel( 'Reading', 'Interpreter', 'none' );
% grid on