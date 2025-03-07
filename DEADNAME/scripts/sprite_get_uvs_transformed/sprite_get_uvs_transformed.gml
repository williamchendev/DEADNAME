/// @function sprite_get_uvs_transformed(sprite1, subimg1, sprite2, subimg2)
/// @description Returns a transform array that can be used in a shader to align the UVs of sprite2 with sprite1 (takes cropping into account)
/// @param {sprite} spr1 The sprite align the UVs to
/// @param {int} subimg1 The sprite subimage to align the UVs to
/// @param {sprite} spr2 The sprite with UVs that will be aligned
/// @param {int} subimg2 The sprite subimage with UVs that will be aligned
/// @returns {array<Real>} returns an array containing the transformed uvs to sample of the second sprite in alignment with the first sprite
function sprite_get_uvs_transformed(sprite_a, subimage_a, sprite_b, subimage_b)
{
	// Get the uvs of the sprites
	var sprite_a_uvs = sprite_get_uvs(sprite_a, subimage_a);
	var sprite_b_uvs = sprite_get_uvs(sprite_b, subimage_b);
	
	// Get the sprite normalized values for the left and top cropping 
	var sprite_a_uvs_crop_left_sprite_total = sprite_a_uvs[4] / sprite_get_width(sprite_a);
	var sprite_a_uvs_crop_top_sprite_total = sprite_a_uvs[5] / sprite_get_height(sprite_a);
	var sprite_b_uvs_crop_left_sprite_total = sprite_b_uvs[4] / sprite_get_width(sprite_b);
	var sprite_b_uvs_crop_top_sprite_total = sprite_b_uvs[5] / sprite_get_height(sprite_b);
	
	// Get the sprite size relative to the texture page
	var sprite_a_uvs_width_texture_page = sprite_a_uvs[2] - sprite_a_uvs[0];
	var sprite_a_uvs_height_texture_page = sprite_a_uvs[3] - sprite_a_uvs[1];
	var sprite_b_uvs_width_texture_page = sprite_b_uvs[2] - sprite_b_uvs[0];
	var sprite_b_uvs_height_texture_page = sprite_b_uvs[3] - sprite_b_uvs[1];
	
	// Get the uncropped sizes on the texture page
	var sprite_a_uvs_uncropped_width_texture_page = sprite_a_uvs_width_texture_page / sprite_a_uvs[6];
	var sprite_a_uvs_uncropped_height_texture_page = sprite_a_uvs_height_texture_page / sprite_a_uvs[7];
	var sprite_b_uvs_uncropped_width_texture_page = sprite_b_uvs_width_texture_page / sprite_b_uvs[6];
	var sprite_b_uvs_uncropped_height_texture_page = sprite_b_uvs_height_texture_page / sprite_b_uvs[7];
	
	// Get the uncropped coordinates relative to the texture page
	var sprite_a_uvs_x_texture_page = sprite_a_uvs[0] - (sprite_a_uvs_uncropped_width_texture_page * sprite_a_uvs_crop_left_sprite_total);
	var sprite_a_uvs_y_texture_page = sprite_a_uvs[1] - (sprite_a_uvs_uncropped_height_texture_page * sprite_a_uvs_crop_top_sprite_total);
	var sprite_b_uvs_x_texture_page = sprite_b_uvs[0] - (sprite_b_uvs_uncropped_width_texture_page * sprite_b_uvs_crop_left_sprite_total);
	var sprite_b_uvs_y_texture_page = sprite_b_uvs[1] - (sprite_b_uvs_uncropped_height_texture_page * sprite_b_uvs_crop_top_sprite_total);
	
	// Get the positional offsets
	var x_scale = sprite_b_uvs_uncropped_width_texture_page / sprite_a_uvs_uncropped_width_texture_page;
	var y_scale = sprite_b_uvs_uncropped_height_texture_page / sprite_a_uvs_uncropped_height_texture_page;
	
	var x_offset = sprite_b_uvs_x_texture_page - sprite_a_uvs_x_texture_page * x_scale;
	var y_offset = sprite_b_uvs_y_texture_page - sprite_a_uvs_y_texture_page * y_scale;
	
	// Pack the values into an array and return it
	return [x_offset, y_offset, x_scale, y_scale];
}
