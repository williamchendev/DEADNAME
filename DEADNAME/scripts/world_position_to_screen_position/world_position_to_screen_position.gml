/// @function world_position_to_screen_position(position_x, position_y, position_z, view_matrix, projection_matrix);
/// @description Converts the given world position into a screen position based on the view and projection matrix being applied to the Camera
/// @param {real} position_x The world position's x coordinate to grab the screen position from
/// @param {real} position_y The world position's y coordinate to grab the screen position from
/// @param {real} position_z The world position's z coordinate to grab the screen position from
/// @param {array<real>} view_matrix The View Matrix of the Camera
/// @param {array<real>} projection_matrix The Projection Matrix of the Camera
/// @return {array<real>} Returns an array of the world position converted to a screen position's x and y coordinate
function world_position_to_screen_position(position_x, position_y, position_z, view_matrix, projection_matrix) 
{
	// Establish Clip Space Variables
	var temp_clip_space_x, temp_clip_space_y;
	
	// Check if the Projection Matrix is Perspective or Orthographic
	if (projection_matrix[15] == 0) 
	{
		// Establish Clip Space W
		var temp_w = view_matrix[2] * position_x + view_matrix[6] * position_y + view_matrix[10] * position_z + view_matrix[14];
		
		// Check if Clip Space W is Valid
		if (temp_w == 0) 
		{
			return [-1, -1];
		}
		
		// Perspective Projection Matrix Clip Space Conversion
		var temp_clip_space_x = projection_matrix[8] + projection_matrix[0] * (view_matrix[0] * position_x + view_matrix[4] * position_y + view_matrix[8] * position_z + view_matrix[12]) / temp_w;
		var temp_clip_space_y = projection_matrix[9] + projection_matrix[5] * (view_matrix[1] * position_x + view_matrix[5] * position_y + view_matrix[9] * position_z + view_matrix[13]) / temp_w;
	} 
	else 
	{
		// Orthographic Projection Matrix Clip Space Conversion
		temp_clip_space_x = projection_matrix[12] + projection_matrix[0] * (view_matrix[0] * position_x + view_matrix[4] * position_y + view_matrix[8]  * position_z + view_matrix[12]);
		temp_clip_space_y = projection_matrix[13] + projection_matrix[5] * (view_matrix[1] * position_x + view_matrix[5] * position_y + view_matrix[9]  * position_z + view_matrix[13]);
	}
	
	// Return Clip Space Coordinate converted to Screen Position
	return [(0.5 + 0.5 * temp_clip_space_x) * GameManager.game_width, (0.5 + 0.5 * temp_clip_space_y) * GameManager.game_height];
}
