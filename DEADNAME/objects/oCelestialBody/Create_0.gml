/// @description Default Celestial Body Initialization
// Initializes the Celestial Body for Celestial Simulator Behaviour and Rendering

// Initialize as Persistent Object
persistent = true;

// Initialize Empty Celestial Object Type
celestial_object_type = CelestialObjectType.None;

// Initialize Geodesic Icosphere
event_inherited();

// Initialize Geodesic Icosphere Empty Elevation Array
icosphere.vertex_elevations = array_create(array_length(icosphere.vertices));

// Establish Heightmap Texture & Heightmap Displacement Buffer for Celestial Body's Icosphere
if (height_map != noone)
{
	// Establish Undefined Heightmap Buffer
	var temp_heightmap_buffer = undefined;
	
	// Establish Heightmap Texture Dimensions
	var temp_heightmap_buffer_width = sprite_get_width(height_map);
	var temp_heightmap_buffer_height = sprite_get_height(height_map);
	
	// Establish Heightmap Surface from Heightmap Texture Dimensions
	var temp_heightmap_surface = surface_create(temp_heightmap_buffer_width, temp_heightmap_buffer_height, surface_rgba8unorm);
	
	// Draw Heightmap to Heightmap Surface
	surface_set_target(temp_heightmap_surface);
	draw_sprite_ext(height_map, 0, 0, 0, 1, 1, 0, c_white, 1);
	surface_reset_target();
	
	// Load Heightmap Surface into Heightmap Buffer
	temp_heightmap_buffer = buffer_getpixel_begin(temp_heightmap_surface, temp_heightmap_buffer);
	
	// Clear and Delete Heightmap Surface
	surface_free(temp_heightmap_surface);
	temp_heightmap_surface = -1;
	
	// Establish Geodesic Icosphere's Elevation Array from Heightmap Values
	var temp_vertex_elevation_index = 0;
	
	repeat (array_length(icosphere.vertex_elevations))
	{
		// Get Vertex's UV Position
		var temp_vertex_uvs = icosphere.vertex_uvs[temp_vertex_elevation_index];
		
		// Clamp Texture Positions to prevent Heightmap Clipping and Seam Issues
		var temp_clamped_vertex_u = clamp(temp_vertex_uvs[0] * temp_heightmap_buffer_width, 1, temp_heightmap_buffer_width - 1);
		var temp_clamped_vertex_v = clamp(temp_vertex_uvs[1] * temp_heightmap_buffer_height, 1, temp_heightmap_buffer_height - 1);
		
		// Retreive Vertex's Elevation from Heightmap using the Vertex's UV Position
		var temp_vertex_elevation = buffer_getpixel_r(temp_heightmap_buffer, temp_clamped_vertex_u, temp_clamped_vertex_v) / 255;
		
		// Set Icosphere Vertex's Elevation at Array Index
		icosphere.vertex_elevations[temp_vertex_elevation_index] = temp_vertex_elevation;
		
		// Increment Vertex Index
		temp_vertex_elevation_index++;
	}
	
	// Delete Heightmap Buffer
	buffer_delete(temp_heightmap_buffer);
	temp_heightmap_buffer = -1;
}

// Establish Icosphere Diffuse Texture
diffuse_texture = sprite_get_texture(sprite_index, 0);
sprite_index = -1;

// Begin Initialization of Icosphere Vertex Buffer
icosphere_vertex_buffer = vertex_create_buffer();
vertex_begin(icosphere_vertex_buffer, CelestialSimulator.icosphere_render_vertex_format);

// Iterate through Icosphere Triangles and assemble Vertex Buffer
var temp_triangle_index = 0;

repeat (array_length(icosphere.triangles))
{
	// Retreive Triangle Data
	var temp_triangle = icosphere.triangles[temp_triangle_index];
	
	// Obtain Triangle Vertex Positions
	var temp_triangle1_pos = icosphere.vertices[temp_triangle[0]];
	var temp_triangle2_pos = icosphere.vertices[temp_triangle[1]];
	var temp_triangle3_pos = icosphere.vertices[temp_triangle[2]];
	
	// Obtain Triangle UVs Positions
	var temp_triangle1_uvs = icosphere.vertex_uvs[temp_triangle[0]];
	var temp_triangle2_uvs = icosphere.vertex_uvs[temp_triangle[1]];
	var temp_triangle3_uvs = icosphere.vertex_uvs[temp_triangle[2]];
	
	// Obtain Triangle Elevation Values
	var temp_triangle1_elevation = icosphere.vertex_elevations[temp_triangle[0]];
	var temp_triangle2_elevation = icosphere.vertex_elevations[temp_triangle[1]];
	var temp_triangle3_elevation = icosphere.vertex_elevations[temp_triangle[2]];
	
	// Create first Triangle Vertex Data
	vertex_position_3d(icosphere_vertex_buffer, temp_triangle1_pos[0], temp_triangle1_pos[1], temp_triangle1_pos[2]);
	vertex_color(icosphere_vertex_buffer, image_blend, image_alpha);
	vertex_texcoord(icosphere_vertex_buffer, temp_triangle1_elevation, 0);
	
	// Create second Triangle Vertex Data
	vertex_position_3d(icosphere_vertex_buffer, temp_triangle2_pos[0], temp_triangle2_pos[1], temp_triangle2_pos[2]);
	vertex_color(icosphere_vertex_buffer, image_blend, image_alpha);
	vertex_texcoord(icosphere_vertex_buffer, temp_triangle2_elevation, 0);
	
	// Create third Triangle Vertex Data
	vertex_position_3d(icosphere_vertex_buffer, temp_triangle3_pos[0], temp_triangle3_pos[1], temp_triangle3_pos[2]);
	vertex_color(icosphere_vertex_buffer, image_blend, image_alpha);
	vertex_texcoord(icosphere_vertex_buffer, temp_triangle3_elevation, 0);
	
	// Increment Triangle Index
	temp_triangle_index++;
}

// Finish Initializing Vertex Buffer
vertex_end(icosphere_vertex_buffer);
vertex_freeze(icosphere_vertex_buffer);

// Initialize Empty Frustum Culling Radius
frustum_culling_radius = -1;