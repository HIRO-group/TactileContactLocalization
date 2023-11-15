% Author: Carson Kohlbrenner
% Date: 11/11/23

% Description: This function takes in a set of sensor measurements and
% tries to back out the location of the sensor using Non_linear Least
% Squares

% s_i = [x,y,z] of a single sensor
% y_k = [k x 1] of a single sensor's measurements
% f_k = [k x 3] of the touch location for each measurement
% s_i = [x,y,z] initial gues of the sensor's location

function [s_i_pred, path] = NLS_sensor(y_k, f_k, h_k, c0)
    %Parameters of the sensors (determined experimentally)
    c = c0; %Approximated, [a, b, c, d]
    path = c;
    c_size = length(c);

    %Capacitance equation
    %h_k = @(s_i, f_k, v_k) c(1)./(c(2) + c(4).*x(s_i, f_k)) + c(3) + v_k;
    %h_k = @(s_i) c(1)./(c(2) + c(4).*x(s_i)) + c(3);

    %%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%%
    %See if the equation used makes sense for this problem
%     figure();
%     c = hot(100);
%     colormap(c(1:80, :));
% 
%     %Experimental values
%     subplot(2,1,1);
%     hold on;
%     axis equal;
%     scatter3(f_k(:,1), f_k(:,2), f_k(:,3), 100, y_k, 'filled');
%     title("Experimental");
%     colorbar;
%     hold off;
% 
%     %Ideal values
%     subplot(2,1,2);
%     hold on;
%     axis equal;
%     scatter3(f_k(:,1), f_k(:,2), f_k(:,3), 100, h_k(s_i0), 'filled');
%     title("Ideal");
%     colorbar;
%     hold off;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Covariance matrix
    sig_r = 0.1; % mm, Guess of the standard deviation of error?
    R_i = sig_r^2;
    R_big = eye(length(y_k)) * R_i;

    %Cholesky Decomposition
    A = chol(inv(R_big));
    y_a = A*y_k;
    h_a = @(h_k) A*h_k;


%     %%%%%%%%%%%%%% Parameter Optimization %%%%%%%%%%%%%%%
%     %Try to fit the parameters of the capacitance equation to the initial
%     %guess location before solving for x_0
%     %Cost Function
%     h_c = @(c) (c(1))./x(s_i0);
%     J_NLS = @(c) norm(y_a - h_a(h_c(c)))^2;
% 
%     % Define the linear inequality constraints
%     A = [1,20];
%     b = 100;
% 
%     %Define bounds:
%     lb = 2;
%     ub = 200;
% 
%     [c, fval] = fmincon(J_NLS, c0, A, b, [], [], lb, ub);
    

    alpha = 0.01; %Step size for calculating the jacobian
    Alpha = eye(c_size)*alpha;

    % Numerical Jacobian
    if c_size == 2
        H = @(c) (alpha^-1)*[h_a(h_k(c+Alpha(:,1), f_k)) - h_a(h_k(c, f_k)), ...
                               h_a(h_k(c+Alpha(:,2), f_k)) - h_a(h_k(c, f_k))];
    elseif c_size == 3
        H = @(c) (alpha^-1)*[h_a(h_k(c+Alpha(:,1), f_k)) - h_a(h_k(c, f_k)), ...
                               h_a(h_k(c+Alpha(:,2), f_k)) - h_a(h_k(c, f_k)), ...
                               h_a(h_k(c+Alpha(:,3), f_k)) - h_a(h_k(c, f_k))];
    elseif c_size == 4
        %Jacobian
        H = @(c) (alpha^-1)*[  h_a(h_k(c+Alpha(:,1), f_k)) - h_a(h_k(c, f_k)), ...
                               h_a(h_k(c+Alpha(:,2), f_k)) - h_a(h_k(c, f_k)), ...
                               h_a(h_k(c+Alpha(:,3), f_k)) - h_a(h_k(c, f_k)), ...
                               h_a(h_k(c+Alpha(:,4), f_k)) - h_a(h_k(c, f_k))];
    else
        disp("Cannot calculate the Jacobian!");
        return;
    end


    %Gauss-Newton Method to Solve
    iter = 0;
    max_iter = 1000; %Number of iterations to terminate on if solution not found
    epsilon = 0.003; %Termination error 
    s_i_pred = c(1:3);
    beta = 0.01;
    while iter < max_iter

        %Debugging
%         dist = x(s_i_pred);
%         if prob_size == 2
%             for j = 1:length(f_k)
%                 fprintf("Pred: (%0.2f, %0.2f) ", s_i_pred(1), s_i_pred(2));
%                 fprintf("Touch: (%0.2f, %0.2f) ", f_k(j,1), f_k(j,2));
%                 fprintf("Distance: %0.2f \n", dist(j));
%             end
%         else
%             for j = 1:length(f_k)
%                 fprintf("Pred: (%0.2f, %0.2f, %0.2f) ", s_i_pred(1), s_i_pred(2), s_i_pred(3));
%                 fprintf("Touch: (%0.2f, %0.2f, %0.2f) ", f_k(j,1), f_k(j,2), f_k(j,3));
%                 fprintf("Distance: %0.2f \n", dist(j));
%             end
%         end

        %calculate the jacobian and get the change in position guess
        Jac = H(c);
        ds = inv(Jac' * Jac)*Jac' * (y_a - h_a(h_k(c, f_k)));
        c = c + beta*ds;
        path = [path,c];

        %Termination Condition
        if norm(beta*ds) < epsilon
            s_i_pred = c(1:3);
            disp("Predicted Location: " + c(1:3))
            return
        end

        if isnan(ds)
            %disp("Did not converge!");
            s_i_pred = [0;0;0];
            return
        end

        iter = iter+1;
    end

    disp("Did not converge!");
    s_i_pred = c(1:3);
    %s_i_pred = [0;0;0];
    return

end