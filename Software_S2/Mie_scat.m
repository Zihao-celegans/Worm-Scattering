
function [angles_deg, intensity_norm, tot_scat, firstHalf_R, firstHalf_anglerad] = Mie_scat( ...
    worm_dia_um, worm_L_um, eq_type, m, lambda_nm, const, smoothness)
%MIE_WORM_SCATTERING Compute normalized Mie scattering for a worm-shaped object
% approximated by an equivalent sphere based on surface area.
% Adapted from: Ali Ansari Hamedani (2026). 
% Mie Scattering (https://www.mathworks.com/matlabcentral/fileexchange/120258-mie-scattering), 
% MATLAB Central File Exchange. Retrieved March 28, 2026.
%
% Syntax:
%   [angles_deg, intensity_norm, tot_scat, firstHalf_R, firstHalf_anglerad] = ...
%       mie_worm_scattering(worm_dia_um, worm_L_um, m, lambda_nm, const, smoothness, doPlot)
%
% Inputs:
%   worm_dia_um  - Worm diameter in microns
%   worm_L_um    - Worm length in microns
%   m            - Refractive index
%   lambda_nm    - Incident wavelength in nm
%   const        - Isointensity degree (Is/Ii)
%   smoothness   - Number of angular intervals between 0 and 180
%   doPlot       - Logical true/false, whether to generate the plot
%
% Outputs:
%   angles_deg         - Angles in degrees for the first half of the pattern
%   intensity_norm     - Normalized scattering radius, firstHalf_R / tot_scat
%   tot_scat           - Total scattering integral
%   firstHalf_R        - Scattering radius values over 0 to pi
%   firstHalf_anglerad - Angles in radians over 0 to pi
%
% Example:
%   [angles_deg, intensity_norm, tot_scat] = mie_worm_scattering(50, 1000, 1.33, 629, 1, 50, true);


    % Convert worm dimensions from microns to nm
    worm_dia = worm_dia_um * 1000;
    worm_L   = worm_L_um * 1000;

    % Geometry calculations
    v_worm = pi * (worm_dia / 2)^2 * worm_L;
    A_worm = 2 * pi * (worm_dia / 2)^2 + 2 * pi * (worm_dia / 2) * worm_L;

    % Calculate equivalent radius
    r_vol_eq = ((3 * v_worm) / (4 * pi))^(1/3);
    r_surf_eq = sqrt(A_worm / (4 * pi));

    % Start of Mie scattering calculation

    % Particle radius (nm), according to equivalent type
    if (strcmp(eq_type, 'vol'))
        a = r_vol_eq;
        disp('Volume equivalent')
    elseif (strcmp(eq_type, 'surf'))
        a = r_surf_eq;
        disp('Surface area equivalent')
    elseif (strcmp(eq_type, 'worm_r'))
        a = worm_dia/2;
        disp('Radius equivalent')
    else
        error('Invalid equivalent type!');
    end
    
    D_micron = 2 * a / 1000;
    fprintf('\nD = %.3f micron\n\n', D_micron);
    n = smoothness;        % Smoothness of plot

    thetaprime = 0:180/n:180;
    angle = 0:180/n:360;

    thetaprimerad = deg2rad(thetaprime);
    anglerad = deg2rad(angle);

    k = 2 * pi / lambda_nm;            % Wavenumber
    x = k * a;                         % Size parameter
    nmax = round(x + 4 * x^(1/3) + 2); % Number of terms

    r = zeros(size(thetaprime));

    for aa = 1:numel(thetaprime)
        thetadeg = 0:180/(nmax-1):180;
        thetarad = deg2rad(thetaprime(aa));

        B = zeros(size(thetadeg));
        for ii = 1:length(thetadeg)
            B(ii) = (2 * ii + 1) / (ii * (ii + 1));
        end

        mu = cos(thetarad);
        C = zeros(size(thetadeg)); % Pi(n)
        D = zeros(size(thetadeg)); % Tau(n)

        C(1) = 1;
        C(2) = 3 * mu;
        D(1) = mu;

        for ii = 1:(length(thetadeg) - 2)
            C(ii + 2) = (((2 * ii + 3) / (ii + 1)) * mu * C(ii + 1)) ...
                      - (((ii + 2) / (ii + 1)) * C(ii));
        end

        for ii = 1:(length(thetadeg) - 1)
            D(ii + 1) = ((ii + 1) * mu * C(ii + 1)) - ((ii + 2) * C(ii));
        end

        % Mie coefficients
        n_orders = 1:nmax;
        nu = n_orders + 0.5;
        z = m * x;
        m2 = m * m;

        sqx = sqrt(0.5 * pi / x);
        sqz = sqrt(0.5 * pi / z);

        bx = besselj(nu, x) * sqx;
        bz = besselj(nu, z) * sqz;
        yx = bessely(nu, x) * sqx;
        hx = bx + 1i * yx;

        b1x = [sin(x) / x, bx(1:nmax-1)];
        b1z = [sin(z) / z, bz(1:nmax-1)];
        y1x = [-cos(x) / x, yx(1:nmax-1)];
        h1x = b1x + 1i * y1x;

        ax  = x * b1x - n_orders .* bx;
        az  = z * b1z - n_orders .* bz;
        ahx = x .* h1x - n_orders .* hx;

        an = (m2 .* bz .* ax - bx .* az) ./ (m2 .* bz .* ahx - hx .* az);
        bn = (bz .* ax - bx .* az) ./ (bz .* ahx - hx .* az);

        G = zeros(size(thetadeg));
        H = zeros(size(thetadeg));

        for jj = 1:length(thetadeg)
            G(jj) = B(jj) * an(jj) * C(jj) + B(jj) * bn(jj) * D(jj);
            H(jj) = B(jj) * an(jj) * D(jj) + B(jj) * bn(jj) * C(jj);
        end

        S1 = sum(G);
        S2 = sum(H);

        U = abs(S1)^2 + abs(S2)^2;
        v = (1 / k) * sqrt(U / const);
        r(aa) = v^2;
    end

    R = zeros(1, 2 * length(thetaprime) - 1);
    flipr = flip(r);

    for iii = 1:length(r)
        R(iii) = r(iii);
        R(length(r) + iii - 1) = flipr(iii);
    end

    % First half of angular domain
    halfLength = ceil(length(anglerad) / 2);
    firstHalf_anglerad = anglerad(1:halfLength);
    firstHalf_R = R(1:halfLength);

    ring_SFC = firstHalf_R * 2 * pi .* sin(firstHalf_anglerad);
    tot_scat = trapz(firstHalf_anglerad, ring_SFC);

    angles_deg = rad2deg(firstHalf_anglerad);
    intensity_norm = firstHalf_R / tot_scat;

end