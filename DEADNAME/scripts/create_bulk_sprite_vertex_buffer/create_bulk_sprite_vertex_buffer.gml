/// @function create_bulk_sprite_vertex_buffer(bulk_sprite_object_ds_list);
/// @description Creates a compiled Vertex Buffer with the given DS List of Bulk Static Objects and their PBR Properties
/// @param {ds_list<oLighting_BulkStatic_Object>} bulk_sprite_object_ds_list - The DS List of Bulk Static Objects to compile into a single unbroken Vertex Buffer (This is to save on expensive vertex batch breaks when rendering large amounts of environmental assets in a scene)
function create_bulk_sprite_vertex_buffer(bulk_sprite_object_ds_list) 
{
    // Begin Initialize Vertex Buffer
	var temp_bulk_static_layer_vertex_buffer = vertex_create_buffer();
	vertex_begin(temp_bulk_static_layer_vertex_buffer, oLightingEngine.lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format);
	
    // Iterate through all colliding Bulk Static Objects
	for (var i = 0; i < ds_list_size(bulk_sprite_object_ds_list); i++)
	{
		// Find Bulk Static Object at Index
		var temp_bulk_static_object = ds_list_find_value(bulk_sprite_object_ds_list, i);
	
		// Get Bulk Static Object Sprite Variables
		var temp_diffusemap_uvs = sprite_get_uvs(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index);
		
		var temp_sprite_width = sprite_get_width(temp_bulk_static_object.sprite_index) * temp_diffusemap_uvs[6];
		var temp_sprite_height = sprite_get_height(temp_bulk_static_object.sprite_index) * temp_diffusemap_uvs[7];
					
		var temp_pivot_offset_x = sprite_get_xoffset(temp_bulk_static_object.sprite_index) - temp_diffusemap_uvs[4];
		var temp_pivot_offset_y = sprite_get_yoffset(temp_bulk_static_object.sprite_index) - temp_diffusemap_uvs[5];
		
		var temp_sprite_left = -temp_pivot_offset_x * temp_bulk_static_object.image_xscale;
		var temp_sprite_top = -temp_pivot_offset_y * temp_bulk_static_object.image_yscale;
		var temp_sprite_right = (temp_sprite_width - temp_pivot_offset_x) * temp_bulk_static_object.image_xscale;
		var temp_sprite_bottom = (temp_sprite_height - temp_pivot_offset_y) * temp_bulk_static_object.image_yscale;
		
		// Establish Shader Effect Toggles for Bulk Static Object
		var temp_shader_map_toggles_normal_enabled = temp_bulk_static_object.normal_map != noone;
		var temp_shader_map_toggles_metallicroughness_enabled = temp_bulk_static_object.metallicroughness_map != noone;
		var temp_shader_map_toggles_emissive_enabled = temp_bulk_static_object.emissive_map != noone;
		
		// Establish Base Strength & Shader Effect Toggles
		var temp_metallic = temp_bulk_static_object.metallic ? 1 : 0;
		var temp_roughness = max(temp_bulk_static_object.roughness, 0.01);
		var temp_emissive = temp_bulk_static_object.emissive;
		var temp_emissive_multiplier = temp_bulk_static_object.emissive_multiplier;
		
		// Establish UV Data for Bulk Static Object
		var temp_normalmap_uvs = temp_shader_map_toggles_normal_enabled ? sprite_get_uvs_transformed(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index, temp_bulk_static_object.normal_map, temp_bulk_static_object.image_index) : [ -1, -1, -1, -1 ];
		var temp_metallicroughnessmap_uvs = temp_shader_map_toggles_metallicroughness_enabled ? sprite_get_uvs_transformed(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index, temp_bulk_static_object.metallicroughness_map, temp_bulk_static_object.image_index) : [ -1, -1, -1, -1 ];
		var temp_emissivemap_uvs = temp_shader_map_toggles_emissive_enabled ? sprite_get_uvs_transformed(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index, temp_bulk_static_object.emissive_map, temp_bulk_static_object.image_index) : [ -1, -1, -1, -1 ];
		
		// Set Bulk Static Object Rotation
		rot_prefetch(temp_bulk_static_object.image_angle);
		
		// Establish Vertex Coordinate Data for Bulk Static Object
		var temp_vertex_coordinate_ax = temp_bulk_static_object.x + rot_point_x(temp_sprite_left, temp_sprite_top);
		var temp_vertex_coordinate_ay = temp_bulk_static_object.y + rot_point_y(temp_sprite_left, temp_sprite_top);
		
		var temp_vertex_coordinate_bx = temp_bulk_static_object.x + rot_point_x(temp_sprite_right, temp_sprite_top);
		var temp_vertex_coordinate_by = temp_bulk_static_object.y + rot_point_y(temp_sprite_right, temp_sprite_top);
		
		var temp_vertex_coordinate_cx = temp_bulk_static_object.x + rot_point_x(temp_sprite_right, temp_sprite_bottom);
		var temp_vertex_coordinate_cy = temp_bulk_static_object.y + rot_point_y(temp_sprite_right, temp_sprite_bottom);
		
		var temp_vertex_coordinate_dx = temp_bulk_static_object.x + rot_point_x(temp_sprite_left, temp_sprite_bottom);
		var temp_vertex_coordinate_dy = temp_bulk_static_object.y + rot_point_y(temp_sprite_left, temp_sprite_bottom);
	    
		// Add Bulk Static Object to Vertex Buffer
		vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_ax, temp_vertex_coordinate_ay, temp_bulk_static_object.image_angle);
		vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normal_strength);
		vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
		vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[1]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
		
		vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_bulk_static_object.image_angle);
		vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normal_strength);
		vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
		vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
		
		vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_bulk_static_object.image_angle);
		vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normal_strength);
		vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
		vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
		
		vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_cx, temp_vertex_coordinate_cy, temp_bulk_static_object.image_angle);
		vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normal_strength);
		vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
		vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
		
		vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_bulk_static_object.image_angle);
		vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normal_strength);
		vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
		vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
		
		vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_bulk_static_object.image_angle);
		vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normal_strength);
		vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
		vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
		vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
		
		// Destroy Bulk Static Object
		instance_destroy(temp_bulk_static_object.id);
	}
	
	// Finish Initializing Vertex Buffer
	vertex_end(temp_bulk_static_layer_vertex_buffer);
	vertex_freeze(temp_bulk_static_layer_vertex_buffer);
	
	// Return Vertex Buffer
	return temp_bulk_static_layer_vertex_buffer;
}
