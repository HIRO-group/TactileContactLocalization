% Clamp a point to the face of a surface made of triangles

function clamped_point = clamp_surface(v, f, point)
    % v is a Nx3 matrix of vertex positions
    % f is a Mx3 matrix of face indices
    % point is a 1x3 vector of the point to clamp

    % Find the closest vertex to the point
    [~, closest_vertex_index] = min(sum((v - point).^2, 2));

    % Find triangles that contain the closest vertex
    closest_triangles = f(any(f == closest_vertex_index, 2), :);

    min_distance = inf;
    clamped_points = zeros(size(closest_triangles, 1), 3);

    % Clamp the point to each triangle and find the closest
    for i = 1:size(closest_triangles, 1)
        [~, clamped_points(i, :)] = face_clamp(v(closest_triangles(i, :), :), point);
        distance = norm(clamped_points(i, :) - point);
        if distance < min_distance
            min_distance = distance;
            clamped_point = clamped_points(i, :);
        end
    end
end
