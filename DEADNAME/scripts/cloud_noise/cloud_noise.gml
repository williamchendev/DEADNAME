

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
	
	//
	var temp_cloud_noise_surface = surface_create(square_texture_size, square_texture_size, surface_rgba8unorm);
	
	//
	surface_set_target(temp_cloud_noise_surface);
	
	//
	draw_clear_alpha(c_black, 0);
	
	//
	gpu_set_blendmode(bm_normal);
	
	//
	shader_set(shd_cloud_noise);
	
	// Set Cloud Noise Shader Properties
	shader_set_uniform_f(temp_cloud_noise_shader_texture_size_index, square_texture_size);
	shader_set_uniform_f(temp_cloud_noise_shader_cube_size_index, cube_texture_size);
	shader_set_uniform_f(temp_cloud_noise_shader_square_size_index, square_texture_size);
	
	//
	vertex_submit(temp_square_uv_vertex_buffer, pr_trianglelist, -1);
	
	//
	shader_reset();
	
	//
	surface_reset_target();
	
	//
	var temp_file_path = $"{program_directory}\\{file_name}.png";
	surface_save(temp_cloud_noise_surface, temp_file_path);
	show_debug_message($"Cloud Noise Image saved - {temp_file_path}");
	
	// Delete Vertex Format
	vertex_format_delete(temp_square_uv_vertex_format);
	temp_square_uv_vertex_format = -1;
	
	// Delete Vertex Buffer
	vertex_delete_buffer(temp_square_uv_vertex_buffer);
	temp_square_uv_vertex_buffer = -1;
	
	//
	surface_free(temp_cloud_noise_surface);
	temp_cloud_noise_surface = -1;
}

function cloud_noise_random(cloud_x, cloud_y, cloud_z)
{
	var temp_dot_a = dot_product_3d(cloud_x, cloud_y, cloud_z, 12.9898, 78.233, 34.897);
	var temp_dot_b = dot_product_3d(cloud_x, cloud_y, cloud_z, 12.345, 67.89, 412.12);
	var temp_dot_c = dot_product_3d(cloud_x, cloud_y, cloud_z, 56.345, 290.8912, 14.1212);
	
	var temp_trig_a = cos(temp_dot_a);
	var temp_trig_b = sin(temp_dot_b);
	var temp_trig_c = cos(temp_dot_c);
	
	var temp_mod_a = ((197.0 * temp_trig_a) mod 1.0 + temp_trig_a) * 0.5453;
	var temp_mod_b = ((197.0 * temp_trig_b) mod 1.0 + temp_trig_b) * 0.5453;
	var temp_mod_c = ((197.0 * temp_trig_c) mod 1.0 + temp_trig_c) * 0.5453;
	
	var temp_frac_a = frac(temp_mod_a * 43758.5453123) * 2.0 - 1.0;
	var temp_frac_b = frac(temp_mod_b * 43758.5453123) * 2.0 - 1.0;
	var temp_frac_c = frac(temp_mod_c * 43758.5453123) * 2.0 - 1.0;
	
	return [ temp_frac_a, temp_frac_b, temp_frac_c ];
}
