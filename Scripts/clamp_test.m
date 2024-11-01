clc; clear; close all;

load("ML_models/test_model.mat");
load("ML_models/test_validation_UK2.mat");

% Shape data
v = MLData.touchData.obj.v;
f = MLData.touchData.obj.f;

% Plot the cone
fig = figure();
UIAxes = axes(fig);
plotOBJ(UIAxes, v, f);
% Set the axes to be equal
axis(UIAxes, 'equal');
hold(UIAxes, 'on');

% Adjust the view for better visualization
view(UIAxes, -150, 12);
xlabel(UIAxes, 'X');
ylabel(UIAxes, 'Y');
zlabel(UIAxes, 'Z');
grid(UIAxes, 'on');

% Loop through and animate the prompted locations and the detected locations
prompts = validateData.prompts;
readings = validateData.readings;

while true
    for i = 1:length(prompts)
        prompt_point = prompts(i,:);
        reading_point = readings(i, :);

        clamped_point = clamp_surface(v, f, reading_point);
    
        scat_prompt = scatter3(UIAxes, prompt_point(1), prompt_point(2), prompt_point(3), 50, 'r', 'filled');
        scat_reading = scatter3(UIAxes, reading_point(1), reading_point(2), reading_point(3), 100, 'g', 'filled');
        scat_clamp = scatter3(UIAxes, clamped_point(1), clamped_point(2), clamped_point(3), 80, 'k', 'filled');
        % legend([scat_prompt, scat_reading], {'Prompted', 'Detected'}, 'Location', 'best');
        drawnow;
        pause(0.5);
        delete(scat_prompt);
        delete(scat_reading);
        delete(scat_clamp);
    end
end




