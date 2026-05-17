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

// Establish Undefined Heightmap Buffer
var temp_heightmap_buffer = undefined;
var temp_heightmap_buffer_exists = false;

var temp_heightmap_buffer_width = -1;
var temp_heightmap_buffer_height = -1;

// Establish Heightmap Texture & Heightmap Displacement Buffer for Celestial Body's Icosphere
if (height_map != noone)
{
	// Establish Heightmap Texture Dimensions
	temp_heightmap_buffer_width = sprite_get_width(height_map);
	temp_heightmap_buffer_height = sprite_get_height(height_map);
	
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
	
	// Set Heightmap Buffer Exists Toggle
	temp_heightmap_buffer_exists = true;
}

// Establish Undefined Regionmap Buffer
var temp_regionmap_buffer = undefined;
var temp_regionmap_buffer_exists = false;

var temp_regionmap_buffer_width = -1;
var temp_regionmap_buffer_height = -1;

// Establish Regionmap Texture & Regionmap Buffer for Celestial Body's Icosphere
if (region_map != noone)
{
	// Establish Regionmap Texture Dimensions
	temp_regionmap_buffer_width = sprite_get_width(region_map);
	temp_regionmap_buffer_height = sprite_get_height(region_map);
	
	// Establish Regionmap Surface from Regionmap Texture Dimensions
	var temp_regionmap_surface = surface_create(temp_regionmap_buffer_width, temp_regionmap_buffer_height, surface_rgba8unorm);
	
	// Draw Regionmap to Regionmap Surface
	surface_set_target(temp_regionmap_surface);
	draw_sprite_ext(region_map, 0, 0, 0, 1, 1, 0, c_white, 1);
	surface_reset_target();
	
	// Load Regionmap Surface into Regionmap Buffer
	temp_regionmap_buffer = buffer_getpixel_begin(temp_regionmap_surface, temp_regionmap_buffer);
	
	// Clear and Delete Regionmap Surface
	surface_free(temp_regionmap_surface);
	temp_regionmap_surface = -1;
	
	// Set Regionmap Buffer Exists Toggle
	temp_regionmap_buffer_exists = true;
}

// Establish Undefined Microclimatemap Buffer
var temp_microclimatemap_buffer = undefined;
var temp_microclimatemap_buffer_exists = false;

var temp_microclimatemap_buffer_width = -1;
var temp_microclimatemap_buffer_height = -1;

// Establish Microclimatemap Texture & Microclimatemap Buffer for Celestial Body's Icosphere
if (microclimate_map != noone)
{
	// Establish Microclimatemap Texture Dimensions
	temp_microclimatemap_buffer_width = sprite_get_width(microclimate_map);
	temp_microclimatemap_buffer_height = sprite_get_height(microclimate_map);
	
	// Establish Microclimatemap Surface from Microclimatemap Texture Dimensions
	var temp_microclimatemap_surface = surface_create(temp_microclimatemap_buffer_width, temp_microclimatemap_buffer_height, surface_rgba8unorm);
	
	// Draw Microclimatemap to Microclimatemap Surface
	surface_set_target(temp_microclimatemap_surface);
	draw_sprite_ext(microclimate_map, 0, 0, 0, 1, 1, 0, c_white, 1);
	surface_reset_target();
	
	// Load Microclimatemap Surface into Microclimatemap Buffer
	temp_microclimatemap_buffer = buffer_getpixel_begin(temp_microclimatemap_surface, temp_microclimatemap_buffer);
	
	// Clear and Delete Microclimatemap Surface
	surface_free(temp_microclimatemap_surface);
	temp_microclimatemap_surface = -1;
	
	// Set Microclimatemap Buffer Exists Toggle
	temp_microclimatemap_buffer_exists = true;
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

// Initialize Region Arrays
region_name_array = array_create(0);
region_color_hex_array = array_create(0);

// Initialize Microclimates Arrays
microclimate_name_array = array_create(0);
microclimate_color_hex_array = array_create(0);
microclimate_biome_type_array = array_create(0);
microclimate_sample_index_array = array_create(0);
microclimate_pathfinding_nodes_array = array_create(0);

// Initialize Celestial Body's Pathfinding System
pathfinding_nodes_count = 0;

pathfinding_group_direction_array = -1;
pathfinding_group_node_index_array = -1;

pathfinding_node_x_array = -1;
pathfinding_node_y_array = -1;
pathfinding_node_z_array = -1;
pathfinding_node_u_array = -1;
pathfinding_node_v_array = -1;
pathfinding_node_region_array = -1;
pathfinding_node_city_array = -1;
pathfinding_node_units_array = -1;
pathfinding_node_elevation_array = -1;
pathfinding_node_microclimate_array = -1;
pathfinding_node_edges_array = -1;
pathfinding_node_edges_portal_left_array = -1;
pathfinding_node_edges_portal_right_array = -1;

pathfinding_portal_count = 0;
pathfinding_portal_x_array = -1;
pathfinding_portal_y_array = -1;
pathfinding_portal_z_array = -1;
pathfinding_portal_elevation_array = -1;

pathfinding_node_distance = -1;

pathfinding_node_battles_map = undefined;

/// @function celestial_pathfinding_heuristic(celestial_object, first_node_index, second_node_index);
/// @description Finds the distance heuristic between two Pathfinding Node Indexes on the Celestial Object
/// @param {int} first_node_index The first Pathfinding Node's Index to find the distance heuristic relative to the second Pathfinding Node Index
/// @param {int} second_node_index The second Pathfinding Node's Index to find the distance heuristic relative to the first Pathfinding Node Index
/// @returns {real} Returns the Pathfinding Heuristic Score of the two given Pathfinding Node Indexes
celestial_pathfinding_heuristic = function(first_node_index, second_node_index)
{
	// Find the Position of the First Pathfinding Node's Local Position
	var temp_first_node_x = pathfinding_node_x_array[first_node_index];
	var temp_first_node_y = pathfinding_node_y_array[first_node_index];
	var temp_first_node_z = pathfinding_node_z_array[first_node_index];
	
	// Find the Position of the Second Pathfinding Node's Local Position
	var temp_second_node_x = pathfinding_node_x_array[second_node_index];
	var temp_second_node_y = pathfinding_node_y_array[second_node_index];
	var temp_second_node_z = pathfinding_node_z_array[second_node_index];
	
	// Find the Great Circle Distance between the First Pathfinding Node and the Second Pathfinding Node
	var temp_dot = clamp(dot_product_3d(temp_first_node_x, temp_first_node_y, temp_first_node_z, temp_second_node_x, temp_second_node_y, temp_second_node_z), -1, 1);
	var temp_angle = arccos(temp_dot);
	
	// Return Pathfinding Heuristic Score as the Great Circle Distance
	return radius * temp_angle;
}

/// @function celestial_pathfinding_heuristic_multiple(celestial_object, first_node_index, second_node_index);
/// @description Finds the smallest distance heuristic between the first Pathfinding Node Index and any of the Pathfinding Node Indexes within the given array of Pathfinding Node Indexes on the Celestial Object
/// @param {int} first_node_index The first Pathfinding Node's Index to find the distance heuristic relative to any of the possible second Pathfinding Node Indexes
/// @param {array<int>} second_node_indexes An array of possible second Pathfinding Node Indexes to find the distance heuristic relative to the first Pathfinding Node Index
/// @returns {real} Returns the Pathfinding Heuristic Score of the two given Pathfinding Node Indexes
celestial_pathfinding_heuristic_multiple = function(first_node_index, second_node_indexes)
{
	// Find the Pathfinding Heuristic between the First Pathfinding Node and the first indexed Pathfinding Node within the array of possible Second Pathfinding Node Indexes
	var temp_heuristic = celestial_pathfinding_heuristic(first_node_index, second_node_indexes[0]);
	
	// Iterate through the remaining possible Second Pathfinding Node Indexes to find the minimum possible Second Node Distance
	var temp_second_node_array_index = 1;
	
	repeat (array_length(second_node_indexes) - 1)
	{
		// Find the Position of the First Pathfinding Node's Local Position
		var temp_first_node_x = pathfinding_node_x_array[first_node_index];
		var temp_first_node_y = pathfinding_node_y_array[first_node_index];
		var temp_first_node_z = pathfinding_node_z_array[first_node_index];
		
		// Find the Position of the Second Pathfinding Node's Local Position
		var temp_second_node_x = pathfinding_node_x_array[second_node_indexes[temp_second_node_array_index]];
		var temp_second_node_y = pathfinding_node_y_array[second_node_indexes[temp_second_node_array_index]];
		var temp_second_node_z = pathfinding_node_z_array[second_node_indexes[temp_second_node_array_index]];
		
		// Find the Great Circle Distance between the First Pathfinding Node and the Second Pathfinding Node
		var temp_dot = clamp(dot_product_3d(temp_first_node_x, temp_first_node_y, temp_first_node_z, temp_second_node_x, temp_second_node_y, temp_second_node_z), -1, 1);
		var temp_angle = arccos(temp_dot);
		
		// Compare the current Pathfinding Heuristic Score to the new Pathfinding Heuristic Score and take the minimum
		temp_heuristic = min(temp_heuristic, radius * temp_angle);
		
		// Increment Index of the possible Second Pathfinding Node
		temp_second_node_array_index++;
	}
	
	// Return Pathfinding Heuristic Score as the Great Circle Distance
	return temp_heuristic;
}

// Check if Celestial Body has Pathfinding Enabled
if (pathfinding_enabled)
{
	// Initialize Pathfinding Icosphere
	var temp_pathfinding_geodesic_icosphere = geodesic_icosphere_create(pathfinding_resolution);
	
	// Initialize Pathfinding Nodes Count
	pathfinding_nodes_count = array_length(temp_pathfinding_geodesic_icosphere.triangles);
	
	// Initialize Pathfinding Groups
	pathfinding_group_direction_array = array_create(0);
	pathfinding_group_node_index_array = array_create(0);
	
	array_push(pathfinding_group_direction_array, [-1, 0, 0]);
	array_push(pathfinding_group_node_index_array, array_create(0));
	array_push(pathfinding_group_direction_array, [1, 0, 0]);
	array_push(pathfinding_group_node_index_array, array_create(0));
	array_push(pathfinding_group_direction_array, [0, -1, 0]);
	array_push(pathfinding_group_node_index_array, array_create(0));
	array_push(pathfinding_group_direction_array, [0, 1, 0]);
	array_push(pathfinding_group_node_index_array, array_create(0));
	array_push(pathfinding_group_direction_array, [0, 0, -1]);
	array_push(pathfinding_group_node_index_array, array_create(0));
	array_push(pathfinding_group_direction_array, [0, 0, 1]);
	array_push(pathfinding_group_node_index_array, array_create(0));
	
	// Initialize Pathfinding Node Arrays to Size of Pathfinding Icosphere's Triangles Count
	pathfinding_node_x_array = array_create(pathfinding_nodes_count);
	pathfinding_node_y_array = array_create(pathfinding_nodes_count);
	pathfinding_node_z_array = array_create(pathfinding_nodes_count);
	pathfinding_node_u_array = array_create(pathfinding_nodes_count);
	pathfinding_node_v_array = array_create(pathfinding_nodes_count);
	pathfinding_node_region_array = array_create(pathfinding_nodes_count);
	pathfinding_node_city_array = array_create(pathfinding_nodes_count);
	pathfinding_node_units_array = array_create(pathfinding_nodes_count);
	pathfinding_node_elevation_array = array_create(pathfinding_nodes_count);
	pathfinding_node_microclimate_array = array_create(pathfinding_nodes_count);
	pathfinding_node_edges_array = array_create(pathfinding_nodes_count, -1);
	pathfinding_node_edges_portal_left_array = array_create(pathfinding_nodes_count, -1);
	pathfinding_node_edges_portal_right_array = array_create(pathfinding_nodes_count, -1);
	
	// Establish Pathfinding Icosphere's Pathfinding Node Data
	var temp_pathfinding_node_index = 0;
	
	repeat (pathfinding_nodes_count)
	{
		// Get Node Triangle Data
		var temp_pathfinding_triangle = temp_pathfinding_geodesic_icosphere.triangles[temp_pathfinding_node_index];
		
		// Get Node Triangle Vertices
		var temp_pathfinding_triangle_vertex_a_pos = temp_pathfinding_geodesic_icosphere.vertices[temp_pathfinding_triangle[0]];
		var temp_pathfinding_triangle_vertex_b_pos = temp_pathfinding_geodesic_icosphere.vertices[temp_pathfinding_triangle[1]];
		var temp_pathfinding_triangle_vertex_c_pos = temp_pathfinding_geodesic_icosphere.vertices[temp_pathfinding_triangle[2]];
		
		// Get Node Triangle Vertex's Position
		var temp_node_pos = [ 0, 0, 0 ];
		
		temp_node_pos[0] = (temp_pathfinding_triangle_vertex_a_pos[0] + temp_pathfinding_triangle_vertex_b_pos[0] + temp_pathfinding_triangle_vertex_c_pos[0]) / 3;
		temp_node_pos[1] = (temp_pathfinding_triangle_vertex_a_pos[1] + temp_pathfinding_triangle_vertex_b_pos[1] + temp_pathfinding_triangle_vertex_c_pos[1]) / 3;
		temp_node_pos[2] = (temp_pathfinding_triangle_vertex_a_pos[2] + temp_pathfinding_triangle_vertex_b_pos[2] + temp_pathfinding_triangle_vertex_c_pos[2]) / 3;
		
		// Get Node Triangle Vertex's UV Position
		var temp_node_uvs = [ 0.5, 0.5 ];
		
		temp_node_uvs[0] = 0.5 - arctan2(-temp_node_pos[0], -temp_node_pos[2]) / (2 * pi);
		temp_node_uvs[1] = 0.5 - arcsin(temp_node_pos[1]) / pi;
		
		// Retreive Node's Elevation from Heightmap using the Triangle Vertex's UV Position
		var temp_node_elevation = 0;
		
		if (temp_heightmap_buffer_exists)
		{
			// Get Node Triangle Vertex UVs
			var temp_pathfinding_triangle_vertex_a_uvs = temp_pathfinding_geodesic_icosphere.vertex_uvs[temp_pathfinding_triangle[0]];
			var temp_pathfinding_triangle_vertex_b_uvs = temp_pathfinding_geodesic_icosphere.vertex_uvs[temp_pathfinding_triangle[1]];
			var temp_pathfinding_triangle_vertex_c_uvs = temp_pathfinding_geodesic_icosphere.vertex_uvs[temp_pathfinding_triangle[2]];
			
			// Clamp Texture Positions to prevent Heightmap Clipping and Seam Issues
			var temp_heightmap_clamped_node_a_u = clamp(temp_pathfinding_triangle_vertex_a_uvs[0] * temp_heightmap_buffer_width, 1, temp_heightmap_buffer_width - 1);
			var temp_heightmap_clamped_node_a_v = clamp((1 - temp_pathfinding_triangle_vertex_a_uvs[1]) * temp_heightmap_buffer_height, 1, temp_heightmap_buffer_height - 1);
			
			var temp_heightmap_clamped_node_b_u = clamp(temp_pathfinding_triangle_vertex_b_uvs[0] * temp_heightmap_buffer_width, 1, temp_heightmap_buffer_width - 1);
			var temp_heightmap_clamped_node_b_v = clamp((1 - temp_pathfinding_triangle_vertex_b_uvs[1]) * temp_heightmap_buffer_height, 1, temp_heightmap_buffer_height - 1);
			
			var temp_heightmap_clamped_node_c_u = clamp(temp_pathfinding_triangle_vertex_c_uvs[0] * temp_heightmap_buffer_width, 1, temp_heightmap_buffer_width - 1);
			var temp_heightmap_clamped_node_c_v = clamp((1 - temp_pathfinding_triangle_vertex_c_uvs[1]) * temp_heightmap_buffer_height, 1, temp_heightmap_buffer_height - 1);
			
			// Find the Triangle Vertices' Elevation from Heightmap's Red Channel Value
			var temp_node_a_elevation = buffer_getpixel_r(temp_heightmap_buffer, temp_heightmap_clamped_node_a_u, temp_heightmap_clamped_node_a_v) / 255;
			var temp_node_b_elevation = buffer_getpixel_r(temp_heightmap_buffer, temp_heightmap_clamped_node_b_u, temp_heightmap_clamped_node_b_v) / 255;
			var temp_node_c_elevation = buffer_getpixel_r(temp_heightmap_buffer, temp_heightmap_clamped_node_c_u, temp_heightmap_clamped_node_c_v) / 255;
			
			// Find Node's Elevation from the average of all the Elevation Values
			temp_node_elevation = (temp_node_a_elevation + temp_node_b_elevation + temp_node_c_elevation) / 3;
		}
		
		// Retreive Node's Region from Regionmap using the Triangle Vertex's UV Position
		var temp_node_region = -1;
		
		if (temp_regionmap_buffer_exists)
		{
			// Clamp Texture Positions to prevent Regionmap Clipping and Seam Issues
			var temp_regionmap_clamped_node_u = clamp(temp_node_uvs[0] * temp_regionmap_buffer_width, 1, temp_regionmap_buffer_width - 1);
			var temp_regionmap_clamped_node_v = clamp(temp_node_uvs[1] * temp_regionmap_buffer_height, 1, temp_regionmap_buffer_height - 1);
			
			// Find Node's Region Color Red, Green, and Blue Values
			var temp_node_region_color_r = buffer_getpixel_r(temp_regionmap_buffer, temp_regionmap_clamped_node_u, temp_regionmap_clamped_node_v);
			var temp_node_region_color_g = buffer_getpixel_g(temp_regionmap_buffer, temp_regionmap_clamped_node_u, temp_regionmap_clamped_node_v);
			var temp_node_region_color_b = buffer_getpixel_b(temp_regionmap_buffer, temp_regionmap_clamped_node_u, temp_regionmap_clamped_node_v);
			
			// Create Node's Region Color Hexadecimal Code from Red, Green, and Blue Values
			var temp_node_region_color_hex = color_get_hex(make_color_rgb(temp_node_region_color_r, temp_node_region_color_g, temp_node_region_color_b));
			
			// Find Index of Node's Region Color Hexadecimal Code in Regions Color Hexadecimal Array
			var temp_node_region_index = array_get_index(region_color_hex_array, temp_node_region_color_hex);
			
			// Check if Node's Region Color Hexadecimal Code corresponds to a indexed Region
			if (temp_node_region_index != -1)
			{
				// Region Hexadecimal Code is Indexed - Use Region Index
				temp_node_region = temp_node_region_index;
			}
			else
			{
				// Region Hexadecimal Code is not Indexed - Create new Region Index
				temp_node_region = array_length(region_color_hex_array);
				array_push(region_name_array, $"region_{temp_node_region}");
				array_push(region_color_hex_array, temp_node_region_color_hex);
			}
		}
		
		// Retreive Node's Microclimate from Microclimatemap using the Vertex's UV Position
		var temp_node_microclimate = -1;
		
		if (temp_microclimatemap_buffer_exists)
		{
			// Clamp Texture Positions to prevent Microclimatemap Clipping and Seam Issues
			var temp_microclimatemap_clamped_node_u = clamp(temp_node_uvs[0] * temp_microclimatemap_buffer_width, 1, temp_microclimatemap_buffer_width - 1);
			var temp_microclimatemap_clamped_node_v = clamp(temp_node_uvs[1] * temp_microclimatemap_buffer_height, 1, temp_microclimatemap_buffer_height - 1);
			
			// Find Node's Microclimate Color Red, Green, and Blue Values
			var temp_node_microclimate_color_r = buffer_getpixel_r(temp_microclimatemap_buffer, temp_microclimatemap_clamped_node_u, temp_microclimatemap_clamped_node_v);
			var temp_node_microclimate_color_g = buffer_getpixel_g(temp_microclimatemap_buffer, temp_microclimatemap_clamped_node_u, temp_microclimatemap_clamped_node_v);
			var temp_node_microclimate_color_b = buffer_getpixel_b(temp_microclimatemap_buffer, temp_microclimatemap_clamped_node_u, temp_microclimatemap_clamped_node_v);
			
			// Create Node's Microclimate Color Hexadecimal Code from Red, Green, and Blue Values
			var temp_node_microclimate_color_hex = color_get_hex(make_color_rgb(temp_node_microclimate_color_r, temp_node_microclimate_color_g, temp_node_microclimate_color_b));
			
			// Find Index of Node's Microclimate Color Hexadecimal Code in Microclimates Color Hexadecimal Array
			var temp_node_microclimate_index = array_get_index(microclimate_color_hex_array, temp_node_microclimate_color_hex);
			
			// Check if Node's Microclimate Color Hexadecimal Code corresponds to a indexed Microclimate
			if (temp_node_microclimate_index != -1)
			{
				// Microclimate Hexadecimal Code is Indexed - Use Microclimate Index
				temp_node_microclimate = temp_node_microclimate_index;
				array_push(microclimate_pathfinding_nodes_array[temp_node_microclimate], temp_pathfinding_node_index);
			}
			else
			{
				// Microclimate Hexadecimal Code is not Indexed - Create new Microclimate Index
				temp_node_microclimate = array_length(microclimate_color_hex_array);
				array_push(microclimate_name_array, $"microclimate_{temp_node_microclimate}");
				array_push(microclimate_color_hex_array, temp_node_microclimate_color_hex);
				array_push(microclimate_biome_type_array, CelestialMicroclimateBiomeType.None); // DEBUG FOR NOW BUT LATER WE GOTTA HAVE A BETTER WAY OF DOING THIS
				array_push(microclimate_sample_index_array, 0);
				array_push(microclimate_pathfinding_nodes_array, [ temp_pathfinding_node_index ]);
			}
		}
		
		// Set Pathfinding Node's Position and UV from Triangle Data to Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_x_array[temp_pathfinding_node_index] = temp_node_pos[0];
		pathfinding_node_y_array[temp_pathfinding_node_index] = temp_node_pos[1];
		pathfinding_node_z_array[temp_pathfinding_node_index] = temp_node_pos[2];
		
		pathfinding_node_u_array[temp_pathfinding_node_index] = temp_node_uvs[0];
		pathfinding_node_v_array[temp_pathfinding_node_index] = temp_node_uvs[1];
		
		// Set Pathfinding Node's Region from Triangle Data to Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_region_array[temp_pathfinding_node_index] = temp_node_region;
		
		// Set Pathfinding Node's City as Empty to Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_city_array[temp_pathfinding_node_index] = noone;
		
		// Create Empty Pathfinding Node Units Arrays for the new Pathfinding Node within the Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_units_array[temp_pathfinding_node_index] = array_create(0);
		
		// Set Pathfinding Node's Elevation from Triangle Data to Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_elevation_array[temp_pathfinding_node_index] = temp_node_elevation;
		
		// Set Pathfinding Node's Microclimate from Triangle Data to Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_microclimate_array[temp_pathfinding_node_index] = temp_node_microclimate;
		
		// Create Empty Pathfinding Node Edges Arrays for the new Pathfinding Node within the Celestial Body's Pathfinding Node Data Arrays
		pathfinding_node_edges_array[temp_pathfinding_node_index] = array_create(0);
		pathfinding_node_edges_portal_left_array[temp_pathfinding_node_index] = array_create(0);
		pathfinding_node_edges_portal_right_array[temp_pathfinding_node_index] = array_create(0);
		
		// Index Pathfinding Node into Pathfinding Group based on Node Vertex Position
		var temp_pathfinding_group_index = 0;
		var temp_pathfinding_group_best = -1;
		var temp_pathfinding_group_dot_product = -1;
		
		repeat (array_length(pathfinding_group_direction_array))
		{
			// Find Group Direction
			var temp_group_direction_x = array_get(pathfinding_group_direction_array[temp_pathfinding_group_index], 0);
			var temp_group_direction_y = array_get(pathfinding_group_direction_array[temp_pathfinding_group_index], 1);
			var temp_group_direction_z = array_get(pathfinding_group_direction_array[temp_pathfinding_group_index], 2);
			
			// Calculate Dot Product of Pathfinding Node's Normalized Sphere Vector and the Pathfinding Group's Normalized Sphere Vector
			var temp_group_comparison_dot_product = dot_product_3d(temp_node_pos[0], temp_node_pos[1], temp_node_pos[2], temp_group_direction_x, temp_group_direction_y, temp_group_direction_z);
			
			// Compare the new Dot Product of the Pathfinding Node
			if (temp_group_comparison_dot_product > temp_pathfinding_group_dot_product)
			{
				// Update Pathfinding Group Index and Dot Product
				temp_pathfinding_group_best = temp_pathfinding_group_index;
				temp_pathfinding_group_dot_product = temp_group_comparison_dot_product;
			}
			
			// Increment Pathfinding Group
			temp_pathfinding_group_index++;
		}
		
		// Index Pathfinding Node into Pathfinding Group
		if (temp_pathfinding_group_best != -1)
		{
			array_push(pathfinding_group_node_index_array[temp_pathfinding_group_best], temp_pathfinding_node_index);
		}
		
		// Increment Node Index
		temp_pathfinding_node_index++;
	}
	
	// Initialize Pathfinding Portal Count
	pathfinding_portal_count = array_length(temp_pathfinding_geodesic_icosphere.vertices)
	
	// Initialize Pathfinding Portal Arrays to Size of Pathfinding Icosphere's Vertices Count
	pathfinding_portal_x_array = array_create(pathfinding_portal_count);
	pathfinding_portal_y_array = array_create(pathfinding_portal_count);
	pathfinding_portal_z_array = array_create(pathfinding_portal_count);
	pathfinding_portal_elevation_array = array_create(pathfinding_portal_count);
	
	// Establish Pathfinding Icosphere's Pathfinding Portal Data
	var temp_pathfinding_portal_index = 0;
	
	repeat (pathfinding_portal_count)
	{
		// Get Portal Vertex Position
		var temp_portal_pos = temp_pathfinding_geodesic_icosphere.vertices[temp_pathfinding_portal_index];
		
		// Get Portal Vertex's UV Position
		var temp_portal_uvs = temp_pathfinding_geodesic_icosphere.vertex_uvs[temp_pathfinding_portal_index];
		
		// Retreive Portal's Elevation from Heightmap using the Vertex's UV Position
		var temp_portal_elevation = 0;
		
		if (temp_heightmap_buffer_exists)
		{
			// Clamp Texture Positions to prevent Heightmap Clipping and Seam Issues
			var temp_heightmap_clamped_portal_u = clamp(temp_portal_uvs[0] * temp_heightmap_buffer_width, 1, temp_heightmap_buffer_width - 1);
			var temp_heightmap_clamped_portal_v = clamp((1 - temp_portal_uvs[1]) * temp_heightmap_buffer_height, 1, temp_heightmap_buffer_height - 1);
			
			// Find Portal's Elevation from Heightmap's Red Channel Value
			temp_portal_elevation = buffer_getpixel_r(temp_heightmap_buffer, temp_heightmap_clamped_portal_u, temp_heightmap_clamped_portal_v) / 255;
		}
		
		// Set Pathfinding Portal's Position from Vertex Data to Celestial Body's Pathfinding Portal Data Arrays
		pathfinding_portal_x_array[temp_pathfinding_portal_index] = temp_portal_pos[0];
		pathfinding_portal_y_array[temp_pathfinding_portal_index] = temp_portal_pos[1];
		pathfinding_portal_z_array[temp_pathfinding_portal_index] = temp_portal_pos[2];
		
		// Set Pathfinding Portal's Elevation from Vertex Data to Celestial Body's Pathfinding Portal Data Arrays
		pathfinding_portal_elevation_array[temp_pathfinding_portal_index] = temp_portal_elevation;
		
		// Increment Portal Index
		temp_pathfinding_portal_index++;
	}
	
	// Initialize Pathfinding Edges DS Map
	var temp_pathfinding_edges_map = ds_map_create();
	
	// Iterate through Pathfinding Icosphere Triangles and assemble Pathfinding Grid's Edges
	var temp_node_triangle_index = 0;
	
	repeat (array_length(temp_pathfinding_geodesic_icosphere.triangles))
	{
		// Retreive Triangle Data
		var temp_pathfinding_triangle = temp_pathfinding_geodesic_icosphere.triangles[temp_node_triangle_index];
		
		// Create Edge IDs from Triangle Edge Data
		var temp_pathfinding_triangle_edge_id_a = $"{min(temp_pathfinding_triangle[0], temp_pathfinding_triangle[1])}:{max(temp_pathfinding_triangle[0], temp_pathfinding_triangle[1])}";
		var temp_pathfinding_triangle_edge_id_b = $"{min(temp_pathfinding_triangle[1], temp_pathfinding_triangle[2])}:{max(temp_pathfinding_triangle[1], temp_pathfinding_triangle[2])}";
		var temp_pathfinding_triangle_edge_id_c = $"{min(temp_pathfinding_triangle[2], temp_pathfinding_triangle[0])}:{max(temp_pathfinding_triangle[2], temp_pathfinding_triangle[0])}";
		
		// Retreive Triangle Edge Indexes from Pathfinding Edges DS Map with Edge IDs
		var temp_pathfinding_triangle_edge_connected_triangle_index_a = ds_map_find_value(temp_pathfinding_edges_map, temp_pathfinding_triangle_edge_id_a);
		var temp_pathfinding_triangle_edge_connected_triangle_index_b = ds_map_find_value(temp_pathfinding_edges_map, temp_pathfinding_triangle_edge_id_b);
		var temp_pathfinding_triangle_edge_connected_triangle_index_c = ds_map_find_value(temp_pathfinding_edges_map, temp_pathfinding_triangle_edge_id_c);
		
		// Check if First Triangle Index Exists
		if (is_undefined(temp_pathfinding_triangle_edge_connected_triangle_index_a))
		{
			// Index Triangle and Edge Data in Pathfinding Edges DS Map
			ds_map_add(temp_pathfinding_edges_map, temp_pathfinding_triangle_edge_id_a, temp_node_triangle_index);
		}
		else
		{
			// Index Pathfinding Edge in Pathfinding Node Edges Arrays
			array_push(pathfinding_node_edges_array[temp_node_triangle_index], temp_pathfinding_triangle_edge_connected_triangle_index_a);
			array_push(pathfinding_node_edges_array[temp_pathfinding_triangle_edge_connected_triangle_index_a], temp_node_triangle_index);
			
			// Determine Portal Left/Right Orientation
			var temp_triangle_a_forward_vector_x = lerp(pathfinding_portal_x_array[temp_pathfinding_triangle[0]], pathfinding_portal_x_array[temp_pathfinding_triangle[1]], 0.5) - pathfinding_node_x_array[temp_node_triangle_index];
			var temp_triangle_a_forward_vector_y = lerp(pathfinding_portal_y_array[temp_pathfinding_triangle[0]], pathfinding_portal_y_array[temp_pathfinding_triangle[1]], 0.5) - pathfinding_node_y_array[temp_node_triangle_index];
			var temp_triangle_a_forward_vector_z = lerp(pathfinding_portal_z_array[temp_pathfinding_triangle[0]], pathfinding_portal_z_array[temp_pathfinding_triangle[1]], 0.5) - pathfinding_node_z_array[temp_node_triangle_index];
			
			var temp_triangle_a_edge_vector_x = pathfinding_portal_x_array[temp_pathfinding_triangle[1]] - pathfinding_portal_x_array[temp_pathfinding_triangle[0]];
			var temp_triangle_a_edge_vector_y = pathfinding_portal_y_array[temp_pathfinding_triangle[1]] - pathfinding_portal_y_array[temp_pathfinding_triangle[0]];
			var temp_triangle_a_edge_vector_z = pathfinding_portal_z_array[temp_pathfinding_triangle[1]] - pathfinding_portal_z_array[temp_pathfinding_triangle[0]];
			
			var temp_triangle_a_cross_x = temp_triangle_a_forward_vector_y * temp_triangle_a_edge_vector_z - temp_triangle_a_forward_vector_z * temp_triangle_a_edge_vector_y;
            var temp_triangle_a_cross_y = temp_triangle_a_forward_vector_z * temp_triangle_a_edge_vector_x - temp_triangle_a_forward_vector_x * temp_triangle_a_edge_vector_z;
            var temp_triangle_a_cross_z = temp_triangle_a_forward_vector_x * temp_triangle_a_edge_vector_y - temp_triangle_a_forward_vector_y * temp_triangle_a_edge_vector_x;
            
            var temp_triangle_a_side_dot_product = dot_product_3d(temp_triangle_a_cross_x, temp_triangle_a_cross_y, temp_triangle_a_cross_z, pathfinding_node_x_array[temp_node_triangle_index], pathfinding_node_y_array[temp_node_triangle_index], pathfinding_node_z_array[temp_node_triangle_index]);
			
			// Index Pathfinding Edge Portals in Pathfinding Node Edges Arrays
			array_push(pathfinding_node_edges_portal_left_array[temp_node_triangle_index], temp_triangle_a_side_dot_product > 0 ? temp_pathfinding_triangle[0] : temp_pathfinding_triangle[1]);
			array_push(pathfinding_node_edges_portal_right_array[temp_node_triangle_index], temp_triangle_a_side_dot_product > 0 ? temp_pathfinding_triangle[1] : temp_pathfinding_triangle[0]);
			
			array_push(pathfinding_node_edges_portal_left_array[temp_pathfinding_triangle_edge_connected_triangle_index_a], temp_triangle_a_side_dot_product > 0 ? temp_pathfinding_triangle[1] : temp_pathfinding_triangle[0]);
			array_push(pathfinding_node_edges_portal_right_array[temp_pathfinding_triangle_edge_connected_triangle_index_a], temp_triangle_a_side_dot_product > 0 ? temp_pathfinding_triangle[0] : temp_pathfinding_triangle[1]);
		}
		
		// Check if Second Triangle Index Exists
		if (is_undefined(temp_pathfinding_triangle_edge_connected_triangle_index_b))
		{
			// Index Triangle and Edge Data in Pathfinding Edges DS Map
			ds_map_add(temp_pathfinding_edges_map, temp_pathfinding_triangle_edge_id_b, temp_node_triangle_index);
		}
		else
		{
			// Index Pathfinding Edge in Pathfinding Node Edges Arrays
			array_push(pathfinding_node_edges_array[temp_node_triangle_index], temp_pathfinding_triangle_edge_connected_triangle_index_b);
			array_push(pathfinding_node_edges_array[temp_pathfinding_triangle_edge_connected_triangle_index_b], temp_node_triangle_index);
			
			// Determine Portal Left/Right Orientation
			var temp_triangle_b_forward_vector_x = lerp(pathfinding_portal_x_array[temp_pathfinding_triangle[1]], pathfinding_portal_x_array[temp_pathfinding_triangle[2]], 0.5) - pathfinding_node_x_array[temp_node_triangle_index];
			var temp_triangle_b_forward_vector_y = lerp(pathfinding_portal_y_array[temp_pathfinding_triangle[1]], pathfinding_portal_y_array[temp_pathfinding_triangle[2]], 0.5) - pathfinding_node_y_array[temp_node_triangle_index];
			var temp_triangle_b_forward_vector_z = lerp(pathfinding_portal_z_array[temp_pathfinding_triangle[1]], pathfinding_portal_z_array[temp_pathfinding_triangle[2]], 0.5) - pathfinding_node_z_array[temp_node_triangle_index];
			
			var temp_triangle_b_edge_vector_x = pathfinding_portal_x_array[temp_pathfinding_triangle[2]] - pathfinding_portal_x_array[temp_pathfinding_triangle[1]];
			var temp_triangle_b_edge_vector_y = pathfinding_portal_y_array[temp_pathfinding_triangle[2]] - pathfinding_portal_y_array[temp_pathfinding_triangle[1]];
			var temp_triangle_b_edge_vector_z = pathfinding_portal_z_array[temp_pathfinding_triangle[2]] - pathfinding_portal_z_array[temp_pathfinding_triangle[1]];
			
			var temp_triangle_b_cross_x = temp_triangle_b_forward_vector_y * temp_triangle_b_edge_vector_z - temp_triangle_b_forward_vector_z * temp_triangle_b_edge_vector_y;
            var temp_triangle_b_cross_y = temp_triangle_b_forward_vector_z * temp_triangle_b_edge_vector_x - temp_triangle_b_forward_vector_x * temp_triangle_b_edge_vector_z;
            var temp_triangle_b_cross_z = temp_triangle_b_forward_vector_x * temp_triangle_b_edge_vector_y - temp_triangle_b_forward_vector_y * temp_triangle_b_edge_vector_x;
            
            var temp_triangle_b_side_dot_product = dot_product_3d(temp_triangle_b_cross_x, temp_triangle_b_cross_y, temp_triangle_b_cross_z, pathfinding_node_x_array[temp_node_triangle_index], pathfinding_node_y_array[temp_node_triangle_index], pathfinding_node_z_array[temp_node_triangle_index]);
			
			// Index Pathfinding Edge Portals in Pathfinding Node Edges Arrays
			array_push(pathfinding_node_edges_portal_left_array[temp_node_triangle_index], temp_triangle_b_side_dot_product > 0 ? temp_pathfinding_triangle[1] : temp_pathfinding_triangle[2]);
			array_push(pathfinding_node_edges_portal_right_array[temp_node_triangle_index], temp_triangle_b_side_dot_product > 0 ? temp_pathfinding_triangle[2] : temp_pathfinding_triangle[1]);
			
			array_push(pathfinding_node_edges_portal_left_array[temp_pathfinding_triangle_edge_connected_triangle_index_b], temp_triangle_b_side_dot_product > 0 ? temp_pathfinding_triangle[2] : temp_pathfinding_triangle[1]);
			array_push(pathfinding_node_edges_portal_right_array[temp_pathfinding_triangle_edge_connected_triangle_index_b], temp_triangle_b_side_dot_product > 0 ? temp_pathfinding_triangle[1] : temp_pathfinding_triangle[2]);
		}
		
		// Check if Third Triangle Index Exists
		if (is_undefined(temp_pathfinding_triangle_edge_connected_triangle_index_c))
		{
			// Index Triangle and Edge Data in Pathfinding Edges DS Map
			ds_map_add(temp_pathfinding_edges_map, temp_pathfinding_triangle_edge_id_c, temp_node_triangle_index);
		}
		else
		{
			// Index Pathfinding Edge in Pathfinding Node Edges Arrays
			array_push(pathfinding_node_edges_array[temp_node_triangle_index], temp_pathfinding_triangle_edge_connected_triangle_index_c);
			array_push(pathfinding_node_edges_array[temp_pathfinding_triangle_edge_connected_triangle_index_c], temp_node_triangle_index);
			
			// Determine Portal Left/Right Orientation
			var temp_triangle_c_forward_vector_x = lerp(pathfinding_portal_x_array[temp_pathfinding_triangle[2]], pathfinding_portal_x_array[temp_pathfinding_triangle[0]], 0.5) - pathfinding_node_x_array[temp_node_triangle_index];
			var temp_triangle_c_forward_vector_y = lerp(pathfinding_portal_y_array[temp_pathfinding_triangle[2]], pathfinding_portal_y_array[temp_pathfinding_triangle[0]], 0.5) - pathfinding_node_y_array[temp_node_triangle_index];
			var temp_triangle_c_forward_vector_z = lerp(pathfinding_portal_z_array[temp_pathfinding_triangle[2]], pathfinding_portal_z_array[temp_pathfinding_triangle[0]], 0.5) - pathfinding_node_z_array[temp_node_triangle_index];
			
			var temp_triangle_c_edge_vector_x = pathfinding_portal_x_array[temp_pathfinding_triangle[0]] - pathfinding_portal_x_array[temp_pathfinding_triangle[2]];
			var temp_triangle_c_edge_vector_y = pathfinding_portal_y_array[temp_pathfinding_triangle[0]] - pathfinding_portal_y_array[temp_pathfinding_triangle[2]];
			var temp_triangle_c_edge_vector_z = pathfinding_portal_z_array[temp_pathfinding_triangle[0]] - pathfinding_portal_z_array[temp_pathfinding_triangle[2]];
			
			var temp_triangle_c_cross_x = temp_triangle_c_forward_vector_y * temp_triangle_c_edge_vector_z - temp_triangle_c_forward_vector_z * temp_triangle_c_edge_vector_y;
            var temp_triangle_c_cross_y = temp_triangle_c_forward_vector_z * temp_triangle_c_edge_vector_x - temp_triangle_c_forward_vector_x * temp_triangle_c_edge_vector_z;
            var temp_triangle_c_cross_z = temp_triangle_c_forward_vector_x * temp_triangle_c_edge_vector_y - temp_triangle_c_forward_vector_y * temp_triangle_c_edge_vector_x;
            
            var temp_triangle_c_side_dot_product = dot_product_3d(temp_triangle_c_cross_x, temp_triangle_c_cross_y, temp_triangle_c_cross_z, pathfinding_node_x_array[temp_node_triangle_index], pathfinding_node_y_array[temp_node_triangle_index], pathfinding_node_z_array[temp_node_triangle_index]);
			
			// Index Pathfinding Edge Portals in Pathfinding Node Edges Arrays
			array_push(pathfinding_node_edges_portal_left_array[temp_node_triangle_index], temp_triangle_c_side_dot_product > 0 ? temp_pathfinding_triangle[2] : temp_pathfinding_triangle[0]);
			array_push(pathfinding_node_edges_portal_right_array[temp_node_triangle_index], temp_triangle_c_side_dot_product > 0 ? temp_pathfinding_triangle[0] : temp_pathfinding_triangle[2]);
			
			array_push(pathfinding_node_edges_portal_left_array[temp_pathfinding_triangle_edge_connected_triangle_index_c], temp_triangle_c_side_dot_product > 0 ? temp_pathfinding_triangle[0] : temp_pathfinding_triangle[2]);
			array_push(pathfinding_node_edges_portal_right_array[temp_pathfinding_triangle_edge_connected_triangle_index_c], temp_triangle_c_side_dot_product > 0 ? temp_pathfinding_triangle[2] : temp_pathfinding_triangle[0]);
		}
		
		// Increment Triangle Index
		temp_node_triangle_index++;
	}
	
	// Destroy Pathfinding Edges DS Map
	ds_map_destroy(temp_pathfinding_edges_map);
	temp_pathfinding_edges_map = -1;
	
	// Initialize Pathfinding Node Distance
	var temp_second_pathfinding_node_index = array_get(pathfinding_node_edges_portal_left_array[0], 0);
	
	var temp_first_pathfinding_node_x = pathfinding_portal_x_array[0];
	var temp_first_pathfinding_node_y = pathfinding_portal_y_array[0];
	var temp_first_pathfinding_node_z = pathfinding_portal_z_array[0];
	
	var temp_second_pathfinding_node_x = pathfinding_portal_x_array[temp_second_pathfinding_node_index];
	var temp_second_pathfinding_node_y = pathfinding_portal_y_array[temp_second_pathfinding_node_index];
	var temp_second_pathfinding_node_z = pathfinding_portal_z_array[temp_second_pathfinding_node_index];
	
	pathfinding_node_distance = point_distance_3d(temp_first_pathfinding_node_x, temp_first_pathfinding_node_y, temp_first_pathfinding_node_z, temp_second_pathfinding_node_x, temp_second_pathfinding_node_y, temp_second_pathfinding_node_z);
	
	// Initialize Pathfinding Node Battles Map
	pathfinding_node_battles_map = ds_map_create();
	
	/*
	var temp_goals = [ 1, 1, 1, 1, 1, 1, 1, 1 ];
	show_debug_message(temp_goals);
	
	var temp_time_start = get_timer();
	var temp_test = celestial_pathfinding(id, 0, temp_goals);
	show_debug_message($"{(get_timer() - temp_time_start) / 1000} ms");
	
	if (!is_undefined(temp_test))
	{
		for (var i = 0; i < ds_list_size(temp_test); i++)
		{
			show_debug_message(ds_list_find_value(temp_test, i));
		}
	}
	
	ds_list_destroy(temp_test);
	
	//
	show_debug_message($"microclimates count: {array_length(microclimate_color_hex_array)}");
	
	for (var q = 0; q < array_length(microclimate_name_array); q++)
	{
		show_debug_message($"[{microclimate_name_array[q]}] - color:{microclimate_color_hex_array[q]}");
		var temp_nodes_array = microclimate_pathfinding_nodes_array[q];
		
		for (var p = 0; p < array_length(temp_nodes_array); p++)
		{
			show_debug_message($"     node[{p}]:{temp_nodes_array[p]}");
		}
	}
	*/
}

// Check if Heightmap Buffer Exists
if (temp_heightmap_buffer_exists)
{
	// Delete Heightmap Buffer
	buffer_delete(temp_heightmap_buffer);
	temp_heightmap_buffer = -1;
}

// Check if Regionmap Buffer Exists
if (temp_regionmap_buffer_exists)
{
	// Delete Regionmap Buffer
	buffer_delete(temp_regionmap_buffer);
	temp_regionmap_buffer = -1;
}

// Check if Microclimatemap Buffer Exists
if (temp_microclimatemap_buffer_exists)
{
	// Delete Microclimatemap Buffer
	buffer_delete(temp_microclimatemap_buffer);
	temp_microclimatemap_buffer = -1;
}

// Initialize Sub Objects Arrays
sub_objects_render_enabled = false;

sub_objects_back_layer_index_array = array_create(0);
sub_objects_back_layer_depth_array = array_create(0);
sub_objects_back_layer_instance_array = array_create(0);

sub_objects_front_layer_index_array = array_create(0);
sub_objects_front_layer_depth_array = array_create(0);
sub_objects_front_layer_instance_array = array_create(0);

// Initialize Identity Matrix
identity_matrix = matrix_build_identity();

// Initialize Rotation Matrix
rotation_matrix = rotation_matrix_from_euler_angles(euler_angle_x, euler_angle_y, euler_angle_z);

// Initialize Solar System Variables
solar_system_id = "null";
orbit_parent_instance = noone;

// Initialize Empty Render Depth Radius and Frustum Culling Radius
render_depth_radius = 0;
frustum_culling_radius = -1;

// Initialize Unit Arrays
units = array_create(0);

// Initialize City Arrays
cities = array_create(0);

// Initialize Satellite Arrays
satellites = array_create(0);

// Initialize Battles Array
battles = array_create(0);

// Celestial Body Functions
add_unit_node = function(unit_instance, node_index)
{
	// Set Unit's Celestial Body Instance
	unit_instance.celestial_body_instance = id;
	
	// Index Unit Instance into Celestial Body Units Array
	array_push(units, unit_instance);
	
	// Check if Celestial Body has Pathfinding Enabled
	if (pathfinding_enabled)
	{
		// Update Unit's Pathfinding Node Index
		unit_instance.pathfinding_node_index = clamp(node_index, 0, pathfinding_nodes_count - 1);
		
		// Update Unit's Pathfinding Position & Elevation with their Pathfinding Node Index
		unit_instance.pathfinding_position_x = pathfinding_node_x_array[unit_instance.pathfinding_node_index];
		unit_instance.pathfinding_position_y = pathfinding_node_y_array[unit_instance.pathfinding_node_index];
		unit_instance.pathfinding_position_z = pathfinding_node_z_array[unit_instance.pathfinding_node_index];
		unit_instance.pathfinding_position_elevation = pathfinding_node_elevation_array[unit_instance.pathfinding_node_index];
		
		// Update Pathfinding Node Units Instance Array
		array_push(pathfinding_node_units_array[unit_instance.pathfinding_node_index], unit_instance);
	}
}

add_unit_uv = function(unit_instance, unit_u, unit_v)
{
	// Set Unit's Celestial Body Instance
	unit_instance.celestial_body_instance = id;
	
	// Update Unit's UV Position
	unit_instance.local_position_u = unit_u;
	unit_instance.local_position_v = unit_v;
	
	// Index Unit Instance into Celestial Body Units Array
	array_push(units, unit_instance);
}

add_city_node = function(city_instance, node_index)
{
	// Set City's Celestial Body Instance
	city_instance.celestial_body_instance = id;
	
	// Index City Instance into Celestial Body Cities Array
	array_push(cities, city_instance);
	
	// Check if Celestial Body has Pathfinding Enabled
	if (pathfinding_enabled)
	{
		// Update City's Pathfinding Node Index
		city_instance.pathfinding_node_index = clamp(node_index, 0, pathfinding_nodes_count - 1);
		
		// Update Pathfinding Node City Instance Array
		pathfinding_node_city_array[city_instance.pathfinding_node_index] = city_instance;
	}
}

add_city_uv = function(city_instance, city_u, city_v)
{
	// Set City's Celestial Body Instance
	city_instance.celestial_body_instance = id;
	
	// Update City's UV Position
	city_instance.local_position_u = city_u;
	city_instance.local_position_v = city_v;
	
	// Index City Instance into Celestial Body Cities Array
	array_push(cities, city_instance);
}

add_satellite_node = function(satellite_instance, node_index)
{
	// Set Satellite's Celestial Body Instance
	satellite_instance.celestial_body_instance = id;
	
	// Index Satellite Instance into Celestial Body Satellites Array
	array_push(satellites, satellite_instance);
	
	// Check if Celestial Body has Pathfinding Enabled
	if (pathfinding_enabled)
	{
		// Update Satellite's Pathfinding Node Index
		satellite_instance.pathfinding_node_index = clamp(node_index, 0, pathfinding_nodes_count - 1);
	}
}

add_satellite_uv = function(satellite_instance, satellite_u, satellite_v)
{
	// Set Satellite's Celestial Body Instance
	satellite_instance.celestial_body_instance = id;
	
	// Update Satellite's UV Position
	satellite_instance.local_position_u = satellite_u;
	satellite_instance.local_position_v = satellite_v;
	
	// Index Satellite Instance into Celestial Body Satellites Array
	array_push(satellites, satellite_instance);
}

// DEBUG
if (pathfinding_enabled)
{
	add_unit_node(instance_create_depth(0, 0, 0, oCelestialUnit), irandom_range(0, pathfinding_nodes_count - 1));
	
	repeat(200)
	{
		add_unit_node(instance_create_depth(0, 0, 0, oCelestialUnit), irandom_range(0, pathfinding_nodes_count - 1));
	}
	
	repeat(50)
	{
		add_satellite_node(instance_create_depth(0, 0, 0, oCelestialSatellite), irandom_range(0, pathfinding_nodes_count - 1));
	}
	
	repeat(50)
	{
		add_city_node(instance_create_depth(0, 0, 0, oCelestialCity), irandom_range(0, pathfinding_nodes_count - 1));
	}
}