% Author: Carson Kohlbrenner
% Date: 11/11/23

% Description: This function takes in a set of sensor measurements and
% tries to back out the location of the sensor using Non_linear Least
% Squares

% s_i = [x,y,z] of a single sensor
% y_k = [k x 1] of a single sensor's measurements
% f_k = [k x 3] of the touch location for each measurement
% s_i = [x,y,z] initial gues of the sensor's location

%NOTE: Only works for 3D

function s_i_pred = NLS_general(y_k, f_k, c, h_k)

    %Parameters per problem
    c_size = length(c)

    %Covariance matrix
    sig_r = 1; % mm, Guess of the standard deviation of error?
    R_i = sig_r^2;
    R_big = eye(length(y_k)) * R_i;

    %Cholesky Decomposition
    A = chol(inv(R_big));
    y_a = A*y_k;
    h_a = @(h_k) A*h_k;

    %Cost Function
    %J_NLS = @(s_i) norm(y_a - h_a(h_k(s_i, f_k)))^2;
    alpha = 0.01; %Step size for calculating the jacobian
    Alpha = eye(c_size)*alpha;


    %Jacobian
    H = @(c) (alpha^-1)*[  h_a(h_k(c+Alpha(:,1))) - h_a(h_k(c)), ...
                           h_a(h_k(c+Alpha(:,2))) - h_a(h_k(c)), ...
                           h_a(h_k(c+Alpha(:,3))) - h_a(h_k(c)), ...
                           h_a(h_k(c+Alpha(:,4))) - h_a(h_k(c))];

    


    %Gauss-Newton Method to Solve
    iter = 0;
    max_iter = 1000; %Number of iterations to terminate on if solution not found
    epsilon = 0.01; %Termination error 
    c_pred = [s_i0; c0(1)];
    beta = 0.01;
    while iter < max_iter
        s_i_pred = c_pred(1:3);

        %Debugging
%         dist = x(s_i_pred);
%         for j = 1:length(f_k)
%             fprintf("Pred: (%0.2f, %0.2f, %0.2f) ", s_i_pred(1), s_i_pred(2), s_i_pred(3));
%             fprintf("Touch: (%0.2f, %0.2f, %0.2f) ", f_k(j,1), f_k(j,2), f_k(j,3));
%             fprintf("Distance: %0.2f \n", dist(j));
%         end

        %calculate the jacobian and get the change in position guess
        Jac = H(c_pred);
        Res = (y_a - h_a(h_k(c_pred)));
        norm(Res)
        ds = inv(Jac' * Jac)*Jac' * Res;
        c_pred = c_pred + beta*ds;

        %Termination Condition
        if norm(ds*beta) < epsilon
            s_i_pred = c_pred(1:3);
            disp("Predicted Location: " + s_i_pred)
            return
        end

        if isnan(ds)
            disp("Did not converge!");
            s_i_pred = [0;0;0];
            return
        end

        iter = iter+1;
    end

    disp("Did not converge!");
    s_i_pred = [0;0;0];
    return


end