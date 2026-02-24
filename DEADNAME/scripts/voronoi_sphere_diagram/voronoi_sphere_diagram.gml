/// @function voronoi_sphere_diagram(texture_size, file_name);
/// @description Generates a Voronoi Sphere Diagram Texture as a PNG image given the desired texture size and name of the file
/// @param {int} texture_size The Voronoi Sphere Diagram Texture's texture size
/// @param {real} cell_count The cell count used in the Voronoi Pattern generation
/// @param {string} file_name The name of the Voronoi Sphere Diagram Texture image file to save
function voronoi_sphere_diagram(texture_size, cell_count = 50, file_name = "voronoi_sphere_diagram") 
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
	var temp_voronoi_sphere_diagram_texture_size_index = shader_get_uniform(shd_voronoi_sphere_diagram, "u_TextureSize");
	var temp_voronoi_sphere_diagram_cell_count_index = shader_get_uniform(shd_voronoi_sphere_diagram, "u_CellCount");
	
	// Create Voronoi Sphere Diagram Surface with given Voronoi Sphere Diagram Texture Pixel Dimensions
	var temp_voronoi_sphere_diagram_surface = surface_create(texture_size * 2, texture_size, surface_rgba8unorm);
	
	// Set Voronoi Sphere DiagramSurface as Target Surface
	surface_set_target(temp_voronoi_sphere_diagram_surface);
	
	// Reset Voronoi Sphere Diagram Surface Color
	draw_clear(c_black);
	
	// Set Default Blendmode
	gpu_set_blendmode(bm_normal);
	
	// Set Voronoi Sphere Diagram Shader
	shader_set(shd_voronoi_sphere_diagram);
	
	// Set Voronoi Sphere Diagram Shader Properties
	shader_set_uniform_f(temp_voronoi_sphere_diagram_texture_size_index, texture_size);
	shader_set_uniform_f(temp_voronoi_sphere_diagram_cell_count_index, cell_count);
	
	// Draw Square UV Vertex Buffer
	vertex_submit(temp_square_uv_vertex_buffer, pr_trianglelist, -1);
	
	// Reset Shader
	shader_reset();
	
	// Reset Surface Target
	surface_reset_target();
	
	// Save Voronoi Sphere Diagram Texture
	var temp_file_path = $"{program_directory}\\{file_name}.png";
	surface_save(temp_voronoi_sphere_diagram_surface, temp_file_path);
	show_debug_message($"Voronoi Sphere Diagram Image saved - {temp_file_path}");
	
	// Delete Vertex Format
	vertex_format_delete(temp_square_uv_vertex_format);
	temp_square_uv_vertex_format = -1;
	
	// Delete Vertex Buffer
	vertex_delete_buffer(temp_square_uv_vertex_buffer);
	temp_square_uv_vertex_buffer = -1;
	
	// Delete Voronoi Sphere Diagram Surface
	surface_free(temp_voronoi_sphere_diagram_surface);
	temp_voronoi_sphere_diagram_surface = -1;
}
