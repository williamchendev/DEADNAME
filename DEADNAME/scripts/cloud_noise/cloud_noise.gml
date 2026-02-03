/// @function cloud_noise(square_texture_size, cube_texture_size, file_name);
/// @description Generates a three-dimensional Cloud Noise Texture as a two dimensional PNG image given the desired texture size, cube texture size, and name of the file
/// @param {int} square_texture_size The Cloud Noise Texture's square length
/// @param {int} cube_texture_size The Cloud Noise Texture's cube length
/// @param {string} file_name The name of the Cloud Noise Texture image file to save
function cloud_noise(square_texture_size, cube_texture_size, file_name = "cloud_noise") 
{
	// Vertex Format
	vertex_format_begin();
	vertex_format_add_position();
	var temp_square_uv_vertex_format = vertex_format_end();

	// Vertex Buffer
	var temp_square_uv_vertex_buffer = vertex_create_buffer();
	
	vertex_begin(temp_square_uv_vertex_buffer, temp_square_uv_vertex_format);
	
	vertex_position(temp_square_uv_vertex_buffer, -1, -1);
	vertex_position(temp_square_uv_vertex_buffer, 1, -1);
	vertex_position(temp_square_uv_vertex_buffer, -1, 1);
	
	vertex_position(temp_square_uv_vertex_buffer, 1, 1);
	vertex_position(temp_square_uv_vertex_buffer, -1, 1);
	vertex_position(temp_square_uv_vertex_buffer, 1, -1);
	
	vertex_end(temp_square_uv_vertex_buffer);
	vertex_freeze(temp_square_uv_vertex_buffer);
	
	// Shader Indexes
	var temp_cloud_noise_shader_texture_size_index = shader_get_uniform(shd_cloud_noise, "u_TextureSize");
	var temp_cloud_noise_shader_cube_size_index = shader_get_uniform(shd_cloud_noise, "u_CubeSize");
	var temp_cloud_noise_shader_square_size_index = shader_get_uniform(shd_cloud_noise, "u_SquareSize");
	
	// Create Cloud Noise Surface with given Cloud Noise Texture Pixel Dimensions
	var temp_cloud_noise_surface = surface_create(square_texture_size, square_texture_size, surface_rgba8unorm);
	
	// Set Cloud Noise Surface as Target Surface
	surface_set_target(temp_cloud_noise_surface);
	
	// Reset Cloud Noise Surface Color and Transparency
	draw_clear_alpha(c_black, 0);
	
	// Set Default Blendmode
	gpu_set_blendmode(bm_normal);
	
	// Set Cloud Noise Shader
	shader_set(shd_cloud_noise);
	
	// Set Cloud Noise Shader Properties
	shader_set_uniform_f(temp_cloud_noise_shader_texture_size_index, square_texture_size);
	shader_set_uniform_f(temp_cloud_noise_shader_cube_size_index, cube_texture_size);
	shader_set_uniform_f(temp_cloud_noise_shader_square_size_index, square_texture_size);
	
	// Draw Square UV Vertex Buffer
	vertex_submit(temp_square_uv_vertex_buffer, pr_trianglelist, -1);
	
	// Reset Shader
	shader_reset();
	
	// Reset Surface Target
	surface_reset_target();
	
	// Save Cloud Noise Texture
	var temp_file_path = $"{program_directory}\\{file_name}.png";
	surface_save(temp_cloud_noise_surface, temp_file_path);
	show_debug_message($"Cloud Noise Image saved - {temp_file_path}");
	
	// Delete Vertex Format
	vertex_format_delete(temp_square_uv_vertex_format);
	temp_square_uv_vertex_format = -1;
	
	// Delete Vertex Buffer
	vertex_delete_buffer(temp_square_uv_vertex_buffer);
	temp_square_uv_vertex_buffer = -1;
	
	// Delete Cloud Noise Surface
	surface_free(temp_cloud_noise_surface);
	temp_cloud_noise_surface = -1;
}
