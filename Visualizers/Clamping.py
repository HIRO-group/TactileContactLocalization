##### Visualizer to test surface clamping #####

"""
This visualizer will validate the mathmatical model for surface clamping.
A three dimensional triangle surface will be initialized via 3 cooridnate points.
Then, a point will be randomly sampled from outside the triangle, and the closest point on the triangle will be found.
"""

import numpy as np
import quaternion
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def quaternion_from_vector_to_vector(a, b):
    # Normalize the input vectors
    a = a / np.linalg.norm(a)
    b = b / np.linalg.norm(b)
    
    # Compute the cross product (rotation axis)
    v = np.cross(a, b)
    
    # Compute the dot product (cosine of the angle)
    cos_theta = np.dot(a, b)
    
    # If vectors are parallel, the cross product will be zero
    if np.allclose(v, 0):
        # If vectors are in the same direction, return identity quaternion
        if cos_theta > 0:
            return quaternion.quaternion(1, 0, 0, 0)
        # If vectors are in opposite directions, return 180-degree rotation
        else:
            # Find an orthogonal vector to use as the rotation axis
            orthogonal = np.array([1, 0, 0]) if not np.allclose(a, [1, 0, 0]) else np.array([0, 1, 0])
            v = np.cross(a, orthogonal)
            v = v / np.linalg.norm(v)
            return quaternion.quaternion(0, *v)
    
    # Normalize the rotation axis
    v = v / np.linalg.norm(v)
    
    # Compute the quaternion
    q = quaternion.quaternion(np.sqrt((1 + cos_theta) / 2), *(v * np.sqrt((1 - cos_theta) / 2)))
    
    return q

def align_triangle_to_xy_plane(triangle_points, random_point):
    # Calculate the normal of the triangle
    edge1 = triangle_points[1] - triangle_points[0]
    edge2 = triangle_points[2] - triangle_points[0]
    normal = np.cross(edge1, edge2)
    normal = normal / np.linalg.norm(normal)  # Normalize the normal

    # Desired normal is the z-axis
    desired_normal = np.array([0, 0, 1])

    # Compute the quaternion to rotate the current normal to the z-axis
    q = quaternion_from_vector_to_vector(normal, desired_normal)
    qinv = quaternion_from_vector_to_vector(desired_normal, normal)

    # Rotate all triangle points
    rotated_points = np.array([quaternion.rotate_vectors(q, point) for point in triangle_points])
    rotated_random_point = quaternion.rotate_vectors(q, random_point)

    return rotated_points, rotated_random_point, qinv

def clamp_and_collision_check(triangle_points, random_point):
    in_triangle = True
    closest_point = random_point.copy()
    projected_point = [np.array([np.inf, np.inf, np.inf]) for _ in range(3)]
    min_distance = np.inf
    closest_projected_point = None
    
    for i in range(3):
        p1 = triangle_points[i]
        p2 = triangle_points[(i+1)%3]
        edge_vector = p2 - p1
        point_vector = random_point - p1
        cross_product = np.cross(edge_vector, point_vector)

        if cross_product[2] < 0:
            in_triangle = False

        projection = np.clip(np.dot(point_vector, edge_vector) / np.linalg.norm(edge_vector)**2, 0, 1) * edge_vector
        projected_point[i] = p1 + projection
        distance = np.linalg.norm(projected_point[i] - random_point)
        if distance < min_distance:
            min_distance = distance
            closest_projected_point = projected_point[i]

    if not in_triangle:
        closest_point = closest_projected_point

    return in_triangle, closest_point, projected_point

def clamp_point(triangle_points, random_point):
    t1 = triangle_points[0]

    triangle_points = triangle_points - t1
    random_point = random_point - t1

    aligned_triangle_points, aligned_random_point, qinv = align_triangle_to_xy_plane(triangle_points, random_point)
    aligned_random_point[2] = 0

    _, closest_point, _ = clamp_and_collision_check(aligned_triangle_points, aligned_random_point)

    clamped_point = quaternion.rotate_vectors(qinv, closest_point) + t1

    return clamped_point

def plot_triangle(triangle_points, random_point, ax, color):
    ax.scatter(triangle_points[:, 0], triangle_points[:, 1], triangle_points[:, 2], c=color, marker='o', label='Triangle Points')
    ax.plot([triangle_points[0][0], triangle_points[1][0]], [triangle_points[0][1], triangle_points[1][1]], [triangle_points[0][2], triangle_points[1][2]], c=color)
    ax.plot([triangle_points[0][0], triangle_points[2][0]], [triangle_points[0][1], triangle_points[2][1]], [triangle_points[0][2], triangle_points[2][2]], c=color)
    ax.plot([triangle_points[1][0], triangle_points[2][0]], [triangle_points[1][1], triangle_points[2][1]], [triangle_points[1][2], triangle_points[2][2]], c=color)
    ax.scatter(random_point[0], random_point[1], random_point[2], c=color, marker='x', label='Random Point')

    # Calculate normal vector
    triangle_normal = np.cross(triangle_points[1] - triangle_points[0], triangle_points[2] - triangle_points[0])
    triangle_normal = triangle_normal / np.linalg.norm(triangle_normal)

    # Plot normal vector on first point
    ax.quiver(triangle_points[0][0], triangle_points[0][1], triangle_points[0][2], triangle_normal[0], triangle_normal[1], triangle_normal[2], color='k', label='Normal Vector')

if __name__ == "__main__":
    # Initialize triangle points
    bounds = 10
    triangle_points_original = np.array([np.random.rand(3)*bounds, np.random.rand(3)*bounds, np.random.rand(3)*bounds])
    random_point_original = np.array([np.random.rand()*bounds, np.random.rand()*bounds, np.random.rand()*bounds])

    # Make all the points relative to the first point
    triangle_points = triangle_points_original - triangle_points_original[0]
    random_point = random_point_original - triangle_points_original[0]

    # Initialize a figure to keep track of the points
    fig = plt.figure(figsize=(12, 6))  # Increased figure size
    ax = fig.add_subplot(121, projection='3d')
    # plot_triangle(triangle_points, random_point, ax, 'r')
    # # Set equal aspect ratio for all axes
    ax.set_box_aspect((1, 1, 1))
    # ax.set_title("Original Points")
    # plt.show()

    #Determine the rotation matrix to align the z-axis with the triangle normal
    aligned_triangle_points, aligned_random_point, qinv = align_triangle_to_xy_plane(triangle_points, random_point)

    # Plot the rotated triangle points on the same plot
    tp_rotated = aligned_triangle_points
    rp_rotated = aligned_random_point.copy()
    rp_rotated[2] = 0

    plot_triangle(tp_rotated, aligned_random_point, ax, 'b')
    ax.scatter(rp_rotated[0], rp_rotated[1], rp_rotated[2], c='r', marker='x', label='Random Point')
    ax.set_title("Rotated Points")

    #Check if the random point is within the triangle on the xy-plane
    in_triangle, new_point, projected_point = clamp_and_collision_check(tp_rotated, rp_rotated)

    # Plot the projected points
    for i in range(3):
        ax.scatter(projected_point[i][0], projected_point[i][1], projected_point[i][2], c='black', marker='o', s=100)
    ax.scatter(new_point[0], new_point[1], new_point[2], c='g', marker='x', label='Clamped Point')
    ax.set_title("Clamped Point")


    #Rotate the point back to the original coordinate system
    clamped_point = clamp_point(triangle_points_original, random_point_original)
    ax = fig.add_subplot(122, projection='3d')
    plot_triangle(triangle_points_original, random_point_original, ax, 'r')
    ax.scatter(clamped_point[0], clamped_point[1], clamped_point[2], c='g', marker='x', label='Clamped Point')
    ax.set_title("Clamped Point")
    ax.set_box_aspect((1, 1, 1))
    plt.show()
