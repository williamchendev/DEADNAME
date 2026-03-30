/// @function screen_position_to_world_vector(screen_position_x, screen_position_y, view_matrix, projection_matrix);
/// @description Converts the given screen position into a normalized world vector of its direction from the view and projection matrix applied to the Camera (warning: only works with a perspective projection matrix)
/// @param {real} screen_position_x The screen position's horizontal coordinate to grab the world vector from
/// @param {real} screen_position_y The screen position's vertical coordinate to grab the world vector from
/// @param {array<real>} view_matrix The View Matrix of the Camera to convert the screen position to a world vector from
/// @param {array<real>} projection_matrix The Projection Matrix of the Camera to convert the screen position to a world vector from
/// @return {array<real>} Returns an array 3 indexes long of the screen position's normalized world direction vector
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
