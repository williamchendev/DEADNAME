/// @description Icosphere Initialization
// Creates the Icosphere Vertex Buffer

// Initialize Geodesic Icosphere
icosphere = geodesic_icosphere_create(resolution);

// Begin Initialization of Icosphere Vertex Buffer
icosphere_vertex_buffer = vertex_create_buffer();
vertex_begin(icosphere_vertex_buffer, LightingEngine.lighting_engine_icosphere_render_vertex_format);

// Set Icosphere Texture
sprite_index = sphere_texture;

icosphere_texture = sprite_get_texture(sprite_index, 0);

sprite_index = -1;

//
var temp_heightmap_exists = heightmap_texture != noone;
var temp_heightmap_buffer = undefined;

if (temp_heightmap_exists)
{
	//
	var temp_heightmap_surface = surface_create(sprite_get_width(heightmap_texture), sprite_get_height(heightmap_texture), surface_rgba8unorm);
	
	//
	surface_set_target(temp_heightmap_surface);
	draw_sprite_ext(heightmap_texture, 0, 0, 0, 1, 1, 0, c_white, 1);
	surface_reset_target();
	
	//
	temp_heightmap_buffer = buffer_getpixel_begin(temp_heightmap_surface, temp_heightmap_buffer);
	
	//
	surface_free(temp_heightmap_surface);
	temp_heightmap_surface = -1;
}

// Iterate through Icosphere Triangles and assemble Vertex Buffer
var tri = 0;

repeat (array_length(icosphere.triangles))
{
	// Retreive Triangle Data
	var temp_triangle = icosphere.triangles[tri];
	
	// Obtain Triangle Vertex Positions
	var temp_triangle1_pos = icosphere.vertices[temp_triangle[0]];
	var temp_triangle2_pos = icosphere.vertices[temp_triangle[1]];
	var temp_triangle3_pos = icosphere.vertices[temp_triangle[2]];
	
	var temp_triangle1_pos_x = temp_triangle1_pos[0];
	var temp_triangle1_pos_y = temp_triangle1_pos[1];
	var temp_triangle1_pos_z = temp_triangle1_pos[2];
	
	var temp_triangle2_pos_x = temp_triangle2_pos[0];
	var temp_triangle2_pos_y = temp_triangle2_pos[1];
	var temp_triangle2_pos_z = temp_triangle2_pos[2];
	
	var temp_triangle3_pos_x = temp_triangle3_pos[0];
	var temp_triangle3_pos_y = temp_triangle3_pos[1];
	var temp_triangle3_pos_z = temp_triangle3_pos[2];
	
	// Obtain Triangle UVs Positions
	var temp_triangle1_uvs = icosphere.vertex_uvs[temp_triangle[0]];
	var temp_triangle2_uvs = icosphere.vertex_uvs[temp_triangle[1]];
	var temp_triangle3_uvs = icosphere.vertex_uvs[temp_triangle[2]];
	
	//
	if (temp_heightmap_exists)
	{
		//
		var temp_triangle1_height = (buffer_getpixel_r(temp_heightmap_buffer, round(temp_triangle1_uvs[0] * sprite_get_width(heightmap_texture)), round(temp_triangle1_uvs[1] * sprite_get_height(heightmap_texture))) / 256) * heightmap_offset / radius;
		var temp_triangle2_height = (buffer_getpixel_r(temp_heightmap_buffer, round(temp_triangle2_uvs[0] * sprite_get_width(heightmap_texture)), round(temp_triangle2_uvs[1] * sprite_get_height(heightmap_texture))) / 256) * heightmap_offset / radius;
		var temp_triangle3_height = (buffer_getpixel_r(temp_heightmap_buffer, round(temp_triangle3_uvs[0] * sprite_get_width(heightmap_texture)), round(temp_triangle3_uvs[1] * sprite_get_height(heightmap_texture))) / 256) * heightmap_offset / radius;
		
		//
		temp_triangle1_pos_x *= 1 + temp_triangle1_height;
		temp_triangle1_pos_y *= 1 + temp_triangle1_height;
		temp_triangle1_pos_z *= 1 + temp_triangle1_height;
		
		temp_triangle2_pos_x *= 1 + temp_triangle2_height;
		temp_triangle2_pos_y *= 1 + temp_triangle2_height;
		temp_triangle2_pos_z *= 1 + temp_triangle2_height;
		
		temp_triangle3_pos_x *= 1 + temp_triangle3_height;
		temp_triangle3_pos_y *= 1 + temp_triangle3_height;
		temp_triangle3_pos_z *= 1 + temp_triangle3_height;
	}
	
	// Create first Triangle Vertex Data
	vertex_position_3d(icosphere_vertex_buffer, temp_triangle1_pos_x, temp_triangle1_pos_y, temp_triangle1_pos_z);
	vertex_normal(icosphere_vertex_buffer, temp_triangle1_pos[0], temp_triangle1_pos[1], temp_triangle1_pos[2]);
	vertex_color(icosphere_vertex_buffer, image_blend, image_alpha);
	
	// Create second Triangle Vertex Data
	vertex_position_3d(icosphere_vertex_buffer, temp_triangle2_pos_x, temp_triangle2_pos_y, temp_triangle2_pos_z);
	vertex_normal(icosphere_vertex_buffer, temp_triangle2_pos[0], temp_triangle2_pos[1], temp_triangle2_pos[2]);
	vertex_color(icosphere_vertex_buffer, image_blend, image_alpha);
	
	// Create third Triangle Vertex Data
	vertex_position_3d(icosphere_vertex_buffer, temp_triangle3_pos_x, temp_triangle3_pos_y, temp_triangle3_pos_z);
	vertex_normal(icosphere_vertex_buffer, temp_triangle3_pos[0], temp_triangle3_pos[1], temp_triangle3_pos[2]);
	vertex_color(icosphere_vertex_buffer, image_blend, image_alpha);
	
	// Increment Triangle Index
	tri++;
}

// Finish Initializing Vertex Buffer
vertex_end(icosphere_vertex_buffer);
vertex_freeze(icosphere_vertex_buffer);

// DEBUG PLEASE REMOVE
rot_v = 0;
rot_spd = 0.001;

eu_h_spd = 1;
eu_v_spd = 1;