function [in_triangle, clamped_point] = face_clamp(v, point)
    % v is a 3x3 matrix of vertex positions
    % point is a 1x3 vector of the point to clamp

    in_triangle = true;
    closest_point = point;
    projected_point = zeros(3);
    min_distance = inf;
    closest_projected_point = [];

    for i = 1:3
        p1 = v(i, :);
        p2 = v(mod(i, 3) + 1, :);
        edge_vector = p2 - p1;
        point_vector = point - p1;
        cross_product = cross(edge_vector, point_vector);

        if cross_product(3) < 0
            in_triangle = false;
        end

        t = dot(point_vector, edge_vector) / norm(edge_vector)^2;
        t_clamped = max(0, min(1, t));  % This replaces the 'clip' function
        projection = t_clamped * edge_vector;
        projected_point(i, :) = p1 + projection;
        distance = norm(projected_point(i, :) - point);
        if distance < min_distance
            min_distance = distance;
            closest_projected_point = projected_point(i, :);
        end
    end

    if ~in_triangle
        closest_point = closest_projected_point;
    end

    clamped_point = closest_point;
end
