%Testing script to compare NLS

clc; close all; clear;

load("Archived_Datasets\UpdatedSkinPatch_B100.mat");
load("Archived_Datasets\Blue&WhiteVariedPatch.mat");

%Test calling for a single sensor
f_k = SkinDataSet.posLinAvgReal' * 2.54;
y_k = SkinDataSet.dataAvgsLin';
t = 0.2; %Thickness Guess
f_k = [f_k, ones(length(f_k),1)*t];
s_i0 = ones(3,1)*t;
threshold = 0; %Threshold to cut out uneeded data
threshold_dist = 6; %mm

range = 10;
error = zeros(range,range);
a_range = linspace(100,300,range);
b_range = linspace(-0.5,0.5,range);

%% For a single prediction
%Euclidean Distance Equation x(s_i, f_k)
% 2D Problem
%x = @(s_i) sqrt( (f_k(:,1) - s_i(1)).^2 + (f_k(:,2) - s_i(2)).^2); 
% 3D Problem
x = @(s_i, f_k) sqrt( (f_k(:,1) - s_i(1)).^2 + (f_k(:,2) - s_i(2)).^2 + (f_k(:,3) - s_i(3)).^2 ); 

%Capacitance Equation
h_k = @(c) c(4)./x(c(1:3), f_k);
h_k2 = @(c, f_k) c(4)./x(c(1:3), f_k);

%Hyper Parameters
sensor_num = 14;
a = 160;

%sense_range = sensor_num;
sense_range = 1:SkinDataSet.sensNum;
cont_range = 10;%mm
cont_res = 100;

for i = sense_range
    fx = f_k(:,1); fy = f_k(:,2); fz = f_k(:,3); sr = y_k(:,i);
    tpos = ones(length(f_k),3).*[trueSet.posReal(:,i);0]';
    cutoff_indices = vecnorm(f_k-tpos,2,2) < threshold_dist;
    %s_i0(1:3) = [SkinDataSet.posPred(:,i); -t];
    s_i0 = tpos(1,:)';

    c = [s_i0; a];

    %Sample many points to form a contour
%     px = linspace(tpos(1,1)-cont_range, tpos(1,1)+cont_range, cont_res);
%     py = linspace(tpos(1,2)-cont_range, tpos(1,2)+cont_range, cont_res);
%     pz = linspace(tpos(1,3)-cont_range, tpos(1,3)+cont_range, cont_res);
%     [X, Y, Z] = meshgrid(px, py, pz);
%     V = zeros(size(X));
%     for l = 1:length(px)
%         for j = 1:length(py)
%             for k = 1:length(pz)
%                 V(l,j,k) = h_k2([px(l), py(j), pz(k), a], tpos(1,:));
%             end
%         end
%     end

    %For analyzing the problem:
    %s_i0(1:2) = trueSet.posReal(:,i);

    [q_new, path] = NLS_sensor(sr(sr > threshold), f_k(sr > threshold, :), h_k2, c);
    s_i_pred(:,i) = q_new(1:3);
    %s_i_pred = q_new(1:3);

    %Plot the data
%     figure()
%     hold on; axis equal; grid on;
%     scatter3(fx(cutoff_indices), fy(cutoff_indices), fz(cutoff_indices), 20, sr(cutoff_indices), 'filled');
%     scatter3(trueSet.posReal(1,i), trueSet.posReal(2,i), 0, 'g', 'filled');
%     contourslice(X,Y,Z,V, tpos(1,1), tpos(1,2), tpos(1,3));
%     scatter3(s_i_pred(1), s_i_pred(2), s_i_pred(3),'b+');
%     scatter3(path(1,1), path(2,1), path(3,1), 'r+');
%     plot3(path(1,:), path(2,:), path(3,:), 'k--');
%     colorbar;
end


%%
% %c0 = [160, -0.1, -4, 1.5];
% c0 = 165;
% %s_i = NLS_sensor(y_k, f_k, s_i0)
% for i = 1:SkinDataSet.sensNum
%     s_i0(1:2) = SkinDataSet.posPred(:,i);
% 
%     %For analyzing the problem:
%     %s_i0(1:2) = trueSet.posReal(:,i);
% 
%     sr = y_k(:,i);
%     q_new = NLS_sensor(sr(sr > threshold), f_k(sr > threshold, :), s_i0, c0);
%     s_i_pred(:,i) = q_new(1:3);
% end
% 
%Plot the results
figure();
hold on;
axis equal;
scatter3(trueSet.posReal(1,:), trueSet.posReal(2,:), zeros(size(SkinDataSet.posPred(2,:))), 'g', 'filled');
scatter3(SkinDataSet.posPred(1,:), SkinDataSet.posPred(2,:), t*ones(size(SkinDataSet.posPred(2,:))), 'rx');
scatter3(s_i_pred(1,:), s_i_pred(2,:), s_i_pred(3,:),'b+');
hold off;
