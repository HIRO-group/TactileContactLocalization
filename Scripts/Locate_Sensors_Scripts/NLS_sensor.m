% Author: Carson Kohlbrenner
% Date: 11/11/23

% Description: This function takes in a set of sensor measurements and
% tries to back out the location of the sensor using Non_linear Least
% Squares

% s_i = [x,y,z] of a single sensor
% y_k = [k x 1] of a single sensor's measurements
% f_k = [k x 3] of the touch location for each measurement

function s_i = NLS_sensor(y_k, f_K)
    c = [160, -0.1, -4, 1.5]; %Approximated, [a, b, c, d]

    %Capacitance equations
    x = @(s_i, f_k) sqrt( abs(f_k(:,1) - s_i(1))^2 + abs(f_k(:,2) - s_i(1))^2 + abs(f_k(:,3) - s_i(1))^2 );
    h_k = @(s_i, f_k, v_k) c(1)./(c(2) + c3(4).*x(s_i, f_k)) + c(3);

    %Covariance matrix
    sig_r = 0.1; % mm, Guess of the standard deviation of error?
    R_i = sig_r^2;
    R_big = eye(length(y_k)) * R_i;

end