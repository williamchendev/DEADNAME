/*
function screen_position_to_world_vector(screen_position_x, screen_position_y, view_matrix, projection_matrix) 
{
	// Establish Ray Variables
	var temp_ray_vector_x, temp_ray_vector_y, temp_ray_vector_z, temp_ray_origin_x, temp_ray_origin_y, temp_ray_origin_z;
	
	// Calculate Clip Space Position from Screen Position
	var temp_clip_space_x = 2 * ((screen_position_x / GameManager.game_width) - 0.5) / projection_matrix[0];
	var temp_clip_space_y = 2 * ((screen_position_x / GameManager.game_height) - 0.5) / projection_matrix[5];
	var temp_camera_x = -(view_matrix[12] * view_matrix[0] + view_matrix[13] * view_matrix[1] + view_matrix[14] * view_matrix[2]);
	var temp_camera_y = -(view_matrix[12] * view_matrix[4] + view_matrix[13] * view_matrix[5] + view_matrix[14] * view_matrix[6]);
	var temp_camera_z = -(view_matrix[12] * view_matrix[8] + view_matrix[13] * view_matrix[9] + view_matrix[14] * view_matrix[10]);
	
	// Check if Projection Matrix is an Orthographic Projection or a Perspective Projection
	if (projection_matrix[15] == 0)
	{
		// Calculate Perspective Ray Direction Vector
		temp_ray_vector_x = view_matrix[2]  + temp_clip_space_x * view_matrix[0] + temp_clip_space_y * view_matrix[1];
		temp_ray_vector_y = view_matrix[6]  + temp_clip_space_x * view_matrix[4] + temp_clip_space_y * view_matrix[5];
		temp_ray_vector_z = view_matrix[10] + temp_clip_space_x * view_matrix[8] + temp_clip_space_y * view_matrix[9];
		
		// Calculate Perspective Ray Origin Position
		temp_ray_origin_x = temp_camera_x;
		temp_ray_origin_y = temp_camera_y;
		temp_ray_origin_z = temp_camera_z;
	}
	else
	{
		// Calculate Orthographic Ray Direction Vector
		temp_ray_vector_x = view_matrix[2];
		temp_ray_vector_y = view_matrix[6];
		temp_ray_vector_z = view_matrix[10];
		
		// Calculate Orthographic Ray Origin Position
		temp_ray_origin_x = temp_camera_x + temp_clip_space_x * view_matrix[0] + temp_clip_space_y * view_matrix[1];
		temp_ray_origin_y = temp_camera_y + temp_clip_space_x * view_matrix[4] + temp_clip_space_y * view_matrix[5];
		temp_ray_origin_z = temp_camera_z + temp_clip_space_x * view_matrix[8] + temp_clip_space_y * view_matrix[9];
	}
	
	// Return Ray Direction Vector and Ray Origin Position
	return [ temp_ray_vector_x, temp_ray_vector_y, temp_ray_vector_z, temp_ray_origin_x, temp_ray_origin_y, temp_ray_origin_z ];
}
*/

function screen_position_to_world_vector(screen_position_x, screen_position_y, view_matrix, projection_matrix) 
{
	// Calculate Inverse of View and Projection Matrix
	var temp_inverse_view_matrix = matrix_inverse(view_matrix);
	var temp_inverse_projection_matrix = matrix_inverse(projection_matrix);
	
	// Calculate Horizontal & Vertical Normalized Device Coordinates of Screen Position
	var temp_ndc_x = (screen_position_x / GameManager.game_width) * 2 - 1;
	var temp_ndc_y = (screen_position_y / GameManager.game_height) * 2 - 1;
	var temp_ndc_z = -1;
	var temp_ndc_w = 1;
	
	// Calculate View Vector from Multiplying the Normalized Device Coordinates in Clip Space by the Inverse of the Projection Matrix
	var temp_view_x = temp_ndc_x * temp_inverse_projection_matrix[0] + temp_ndc_y * temp_inverse_projection_matrix[1] + temp_ndc_z * temp_inverse_projection_matrix[2] + temp_ndc_w * temp_inverse_projection_matrix[3];
	var temp_view_y = temp_ndc_x * temp_inverse_projection_matrix[4] + temp_ndc_y * temp_inverse_projection_matrix[5] + temp_ndc_z * temp_inverse_projection_matrix[6] + temp_ndc_w * temp_inverse_projection_matrix[7];
	var temp_view_z = 1;
	
	// Calculate World Vector from Multiplying the View Vector by the Inverse of the View Matrix
	var temp_world_vector_x = temp_view_x * temp_inverse_view_matrix[0] + temp_view_y * temp_inverse_view_matrix[4] + temp_view_z * temp_inverse_view_matrix[8];
	var temp_world_vector_y = temp_view_x * temp_inverse_view_matrix[1] + temp_view_y * temp_inverse_view_matrix[5] + temp_view_z * temp_inverse_view_matrix[9];
	var temp_world_vector_z = temp_view_x * temp_inverse_view_matrix[2] + temp_view_y * temp_inverse_view_matrix[6] + temp_view_z * temp_inverse_view_matrix[10];
	
	// Calculate World Vector's Magnitude to Normalize the World Vector
	var temp_world_vector_magnitude = sqrt(dot_product_3d(temp_world_vector_x, temp_world_vector_y, temp_world_vector_z, temp_world_vector_x, temp_world_vector_y, temp_world_vector_z));
	
	// Return the Screen Position's Normalized World Vector
	return [ temp_world_vector_x / temp_world_vector_magnitude, temp_world_vector_y / temp_world_vector_magnitude, temp_world_vector_z / temp_world_vector_magnitude ];
}
