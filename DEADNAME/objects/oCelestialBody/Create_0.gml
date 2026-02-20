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

// Establish Heightmap Texture & Heightmap Displacement Buffer for Celestial Body's Icosphere
if (height_map != noone)
{
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
	
	// Set Heightmap Buffer Exists Toggle
	temp_heightmap_buffer_exists = true;
}

// Establish Undefined Regionmap Buffer
var temp_regionmap_buffer = undefined;
var temp_regionmap_buffer_exists = false;

// Establish Regionmap Texture & Regionmap Buffer for Celestial Body's Icosphere
if (region_map != noone)
{
	// Establish Regionmap Texture Dimensions
	var temp_regionmap_buffer_width = sprite_get_width(region_map);
	var temp_regionmap_buffer_height = sprite_get_height(region_map);
	
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
region_cities_array = array_create(0);
region_color_hex_array = array_create(0);

// Initialize Cities Arrays
city_name_array = array_create(0);
city_buildings_array = array_create(0);
city_infrastructure_array = array_create(0);
city_region_array = array_create(0);
city_pathfinding_node_array = array_create(0);

// Initialize Celestial Body's Pathfinding System
pathfinding_node_x_array = -1;
pathfinding_node_y_array = -1;
pathfinding_node_z_array = -1;
pathfinding_node_u_array = -1;
pathfinding_node_v_array = -1;
pathfinding_node_region_array = -1;
pathfinding_node_elevation_array = -1;
pathfinding_node_edges_array = -1;

// Check if Celestial Body has Pathfinding Enabled
if (pathfinding_enabled)
{
	// Initialize Pathfinding Icosphere & Pathfinding Nodes Count
	var temp_pathfinding_geodesic_icosphere = geodesic_icosphere_create(pathfinding_resolution);
	var temp_pathfinding_nodes_count = array_length(temp_pathfinding_geodesic_icosphere.vertices);
	
	// Initialize Pathfinding Node Arrays to Size of Pathfinding Icosphere's Vertices Count
	pathfinding_node_x_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_y_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_z_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_u_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_v_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_region_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_elevation_array = array_create(temp_pathfinding_nodes_count);
	pathfinding_node_edges_array = array_create(temp_pathfinding_nodes_count, array_create(0));
	
	// Establish Pathfinding Icosphere's Pathfinding Node Data
	var temp_pathfinding_vertex_index = 0;
	
	repeat (temp_pathfinding_nodes_count)
	{
		// Get Vertex's Position
		var temp_vertex_pos = temp_pathfinding_geodesic_icosphere.vertices[temp_pathfinding_vertex_index];
		
		// Get Vertex's UV Position
		var temp_vertex_uvs = temp_pathfinding_geodesic_icosphere.vertex_uvs[temp_pathfinding_vertex_index];
		
		// Clamp Texture Positions to prevent Heightmap Clipping and Seam Issues
		var temp_clamped_vertex_u = clamp(temp_vertex_uvs[0] * temp_heightmap_buffer_width, 1, temp_heightmap_buffer_width - 1);
		var temp_clamped_vertex_v = clamp(temp_vertex_uvs[1] * temp_heightmap_buffer_height, 1, temp_heightmap_buffer_height - 1);
		
		// Retreive Vertex's Region from Regionmap using the Vertex's UV Position
		var temp_vertex_region = -1;
		
		if (temp_regionmap_buffer_exists)
		{
			// Find Vertex's Region Color Red, Green, and Blue Values
			var temp_vertex_region_color_r = buffer_getpixel_r(temp_regionmap_buffer, temp_clamped_vertex_u, temp_clamped_vertex_v);
			var temp_vertex_region_color_g = buffer_getpixel_g(temp_regionmap_buffer, temp_clamped_vertex_u, temp_clamped_vertex_v);
			var temp_vertex_region_color_b = buffer_getpixel_b(temp_regionmap_buffer, temp_clamped_vertex_u, temp_clamped_vertex_v);
			
			// Create Vertex's Region Color Hexadecimal Code from Red, Green, and Blue Values
			var temp_vertex_region_color_hex = color_get_hex(make_color_rgb(temp_vertex_region_color_r, temp_vertex_region_color_g, temp_vertex_region_color_b));
			
			// Find Index of Vertex's Region Color Hexadecimal Code in Regions Color Hexadecimal Array
			var temp_vertex_region_index = array_get_index(region_color_hex_array, temp_vertex_region_color_hex);
			
			// Check if Vertex's Region Color Hexadecimal Code corresponds to a indexed Region
			if (temp_vertex_region_index != -1)
			{
				// Region Hexadecimal Code is Indexed - Use Region Index
				temp_vertex_region = temp_vertex_region_index;
			}
			else
			{
				// Region Hexadecimal Code is not Indexed - Create new Region Index
				temp_vertex_region = array_length(region_color_hex_array);
				array_push(region_name_array, "new_region");
				array_push(region_cities_array, array_create(0));
				array_push(region_color_hex_array, temp_vertex_region_color_hex);
			}
		}
		
		// Retreive Vertex's Elevation from Heightmap using the Vertex's UV Position
		var temp_vertex_elevation = temp_heightmap_buffer_exists ? buffer_getpixel_r(temp_heightmap_buffer, temp_clamped_vertex_u, temp_clamped_vertex_v) / 255 : 0;
		
		// Set Pathfinding Node's Array Entry from Vertex Data
		pathfinding_node_x_array[temp_pathfinding_vertex_index] = temp_vertex_pos[0];
		pathfinding_node_y_array[temp_pathfinding_vertex_index] = temp_vertex_pos[1];
		pathfinding_node_z_array[temp_pathfinding_vertex_index] = temp_vertex_pos[2];
		
		pathfinding_node_u_array[temp_pathfinding_vertex_index] = temp_clamped_vertex_u;
		pathfinding_node_v_array[temp_pathfinding_vertex_index] = temp_clamped_vertex_v;
		
		pathfinding_node_region_array[temp_pathfinding_vertex_index] = temp_vertex_region;
		
		pathfinding_node_elevation_array[temp_pathfinding_vertex_index] = temp_vertex_elevation;
		
		// Increment Vertex Index
		temp_pathfinding_vertex_index++;
	}
	
	// Initialize Pathfinding Arrays
	var temp_pathfinding_edges = array_create(0);
	
	// Iterate through Pathfinding Icosphere Triangles and assemble Pathfinding Grid
	var temp_pathfinding_triangle_index = 0;
	
	repeat (array_length(temp_pathfinding_geodesic_icosphere.triangles))
	{
		// Retreive Triangle Data
		var temp_pathfinding_triangle = temp_pathfinding_geodesic_icosphere.triangles[temp_pathfinding_triangle_index];
		
		// Index Triangle Edges in Pathfinding Edge Array
		array_push(temp_pathfinding_edges, $"{min(temp_pathfinding_triangle[0], temp_pathfinding_triangle[1])}:{max(temp_pathfinding_triangle[0], temp_pathfinding_triangle[1])}");
		array_push(temp_pathfinding_edges, $"{min(temp_pathfinding_triangle[1], temp_pathfinding_triangle[2])}:{max(temp_pathfinding_triangle[1], temp_pathfinding_triangle[2])}");
		array_push(temp_pathfinding_edges, $"{min(temp_pathfinding_triangle[2], temp_pathfinding_triangle[0])}:{max(temp_pathfinding_triangle[2], temp_pathfinding_triangle[0])}");
		
		// Increment Triangle Index
		temp_pathfinding_triangle_index++;
	}
	
	// Eliminate Duplicate Triangle Edges and Iterate through all Unique Pathfinding Edges
	var temp_pathfinding_unique_edges = array_unique(temp_pathfinding_edges);
	var temp_pathfinding_unique_edges_index = 0;
	
	repeat (array_length(temp_pathfinding_unique_edges))
	{
		// Find Pathfinding Edge Nodes
		var temp_pathfinding_edge_nodes = string_split(temp_pathfinding_unique_edges[temp_pathfinding_unique_edges_index], ":");
		
		// Cast Pathfinding Edge Node Index Strings to Index Integers
		var temp_pathfinding_edge_node_a_index = real(temp_pathfinding_edge_nodes[0]);
		var temp_pathfinding_edge_node_b_index = real(temp_pathfinding_edge_nodes[1]);
		
		// Index Pathfinding Edge in Pathfinding Node Edges Arrays
		array_push(pathfinding_node_edges_array[temp_pathfinding_edge_node_a_index], temp_pathfinding_edge_node_b_index);
		array_push(pathfinding_node_edges_array[temp_pathfinding_edge_node_b_index], temp_pathfinding_edge_node_a_index);
		
		// Increment Pathfinding Unique Edge Index
		temp_pathfinding_unique_edges_index++;
	}
	
	//
	var temp_test = celestial_pathfinding_recursive(id, 50, 400);
	
	for (var i = 0; i < ds_list_size(temp_test); i++)
	{
		show_debug_message(ds_list_find_value(temp_test, i));
	}
	
	ds_list_destroy(temp_test);
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

// Initialize Solar System Variables
solar_system_id = "null";
orbit_parent_instance = noone;

// Initialize Empty Frustum Culling Radius
frustum_culling_radius = -1;