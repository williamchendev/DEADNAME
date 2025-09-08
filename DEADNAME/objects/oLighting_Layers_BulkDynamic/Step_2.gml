/// @description Bulk Dynamic Layer Late Update Event
// Compiles the Bulk Dynamic Layer's Vertex Buffer from its Render Data DS Lists

// Check if Bulk Dynamic Layer needs to recompile its Vertex Buffer
if (!bulk_dynamic_layer_vertex_buffer_recompile)
{
	return;
}

// Disable Bulk Dynamic Layer Vertex Buffer Recompile Toggle
bulk_dynamic_layer_vertex_buffer_recompile = false;

// Destroy and Recreate Vertex Buffer if it already Exists
if (bulk_dynamic_layer_vertex_buffer_exists)
{
	// Delete Previous Vertex Buffer
	vertex_delete_buffer(bulk_dynamic_layer_vertex_buffer);
	bulk_dynamic_layer_vertex_buffer = -1;
	
	// Create New Vertex Buffer
	bulk_dynamic_layer_vertex_buffer = vertex_create_buffer();
}

// Begin Initialize Vertex Buffer
vertex_begin(bulk_dynamic_layer_vertex_buffer, oLightingEngine.lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format);

// Cull old Vertex Buffer Entries if Vertex Buffer is at Maximum Size
if (bulk_dynamic_layer_vertex_entries > bulk_dynamic_layer_vertex_entries_max)
{
	//
	var temp_entries_difference = bulk_dynamic_layer_vertex_entries - bulk_dynamic_layer_vertex_entries_max;
	
	//
	repeat (temp_entries_difference)
	{
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_ax_list, 0);
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_ay_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_bx_list, 0);
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_by_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_cx_list, 0);
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_cy_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_dx_list, 0);
		ds_list_delete(bulk_dynamic_layer_vertex_coordinate_dy_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_image_angle_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_image_xscale_list, 0);
		ds_list_delete(bulk_dynamic_layer_image_yscale_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_normal_strength_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_image_blend_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_image_alpha_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_diffusemap_uvs_list, 0);
		ds_list_delete(bulk_dynamic_layer_normalmap_uvs_list, 0);
		ds_list_delete(bulk_dynamic_layer_metallicroughnessmap_uvs_list, 0);
		ds_list_delete(bulk_dynamic_layer_emissivemap_uvs_list, 0);
		
		ds_list_delete(bulk_dynamic_layer_metallic_list, 0);
		ds_list_delete(bulk_dynamic_layer_roughness_list, 0);
		ds_list_delete(bulk_dynamic_layer_emissive_list, 0);
		ds_list_delete(bulk_dynamic_layer_emissive_multiplier_list, 0);
	}
	
	//
	bulk_dynamic_layer_vertex_entries -= temp_entries_difference;
}

// Iterate through all Vertex Entries and Compile Render Data into completed Bulk Dynamic Layer's Vertex Buffer
var i = 0;

repeat (bulk_dynamic_layer_vertex_entries)
{
	// Establish Render Data for Bulk Dynamic Layer's Vertex Entry at the given Index
	var temp_vertex_coordinate_ax = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_ax_list, i);
	var temp_vertex_coordinate_ay = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_ay_list, i);
	
	var temp_vertex_coordinate_bx = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_bx_list, i);
	var temp_vertex_coordinate_by = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_by_list, i);
	
	var temp_vertex_coordinate_cx = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_cx_list, i);
	var temp_vertex_coordinate_cy = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_cy_list, i);
	
	var temp_vertex_coordinate_dx = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_dx_list, i);
	var temp_vertex_coordinate_dy = ds_list_find_value(bulk_dynamic_layer_vertex_coordinate_dy_list, i);
	
	var temp_image_angle = ds_list_find_value(bulk_dynamic_layer_image_angle_list, i);
	
	var temp_image_xscale = ds_list_find_value(bulk_dynamic_layer_image_xscale_list, i);
	var temp_image_yscale = ds_list_find_value(bulk_dynamic_layer_image_yscale_list, i);
	
	var temp_normal_strength = ds_list_find_value(bulk_dynamic_layer_normal_strength_list, i);
	
	var temp_image_blend = ds_list_find_value(bulk_dynamic_layer_image_blend_list, i);
	
	var temp_image_alpha = ds_list_find_value(bulk_dynamic_layer_image_alpha_list, i);
	
	var temp_diffusemap_uvs = ds_list_find_value(bulk_dynamic_layer_diffusemap_uvs_list, i);
	var temp_normalmap_uvs = ds_list_find_value(bulk_dynamic_layer_normalmap_uvs_list, i);
	var temp_metallicroughnessmap_uvs = ds_list_find_value(bulk_dynamic_layer_metallicroughnessmap_uvs_list, i);
	var temp_emissivemap_uvs = ds_list_find_value(bulk_dynamic_layer_emissivemap_uvs_list, i);
	
	var temp_metallic = ds_list_find_value(bulk_dynamic_layer_metallic_list, i);
	var temp_roughness = ds_list_find_value(bulk_dynamic_layer_roughness_list, i);
	var temp_emissive = ds_list_find_value(bulk_dynamic_layer_emissive_list, i);
	var temp_emissive_multiplier = ds_list_find_value(bulk_dynamic_layer_emissive_multiplier_list, i);
	
	// Add Vertex Entry's Render Data to Vertex Buffer
	vertex_position_3d(bulk_dynamic_layer_vertex_buffer, temp_vertex_coordinate_ax, temp_vertex_coordinate_ay, temp_image_angle);
	vertex_normal(bulk_dynamic_layer_vertex_buffer, temp_image_xscale, temp_image_yscale, temp_normal_strength);
	vertex_color(bulk_dynamic_layer_vertex_buffer, temp_image_blend, temp_image_alpha);
	vertex_texcoord(bulk_dynamic_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[1]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
	
	vertex_position_3d(bulk_dynamic_layer_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_image_angle);
	vertex_normal(bulk_dynamic_layer_vertex_buffer, temp_image_xscale, temp_image_yscale, temp_normal_strength);
	vertex_color(bulk_dynamic_layer_vertex_buffer, temp_image_blend, temp_image_alpha);
	vertex_texcoord(bulk_dynamic_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
	
	vertex_position_3d(bulk_dynamic_layer_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_image_angle);
	vertex_normal(bulk_dynamic_layer_vertex_buffer, temp_image_xscale, temp_image_yscale, temp_normal_strength);
	vertex_color(bulk_dynamic_layer_vertex_buffer, temp_image_blend, temp_image_alpha);
	vertex_texcoord(bulk_dynamic_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
	
	vertex_position_3d(bulk_dynamic_layer_vertex_buffer, temp_vertex_coordinate_cx, temp_vertex_coordinate_cy, temp_image_angle);
	vertex_normal(bulk_dynamic_layer_vertex_buffer, temp_image_xscale, temp_image_yscale, temp_normal_strength);
	vertex_color(bulk_dynamic_layer_vertex_buffer, temp_image_blend, temp_image_alpha);
	vertex_texcoord(bulk_dynamic_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
	
	vertex_position_3d(bulk_dynamic_layer_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_image_angle);
	vertex_normal(bulk_dynamic_layer_vertex_buffer, temp_image_xscale, temp_image_yscale, temp_normal_strength);
	vertex_color(bulk_dynamic_layer_vertex_buffer, temp_image_blend, temp_image_alpha);
	vertex_texcoord(bulk_dynamic_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
	
	vertex_position_3d(bulk_dynamic_layer_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_image_angle);
	vertex_normal(bulk_dynamic_layer_vertex_buffer, temp_image_xscale, temp_image_yscale, temp_normal_strength);
	vertex_color(bulk_dynamic_layer_vertex_buffer, temp_image_blend, temp_image_alpha);
	vertex_texcoord(bulk_dynamic_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallicroughnessmap_uvs[0], temp_metallicroughnessmap_uvs[1], temp_metallicroughnessmap_uvs[2], temp_metallicroughnessmap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_emissivemap_uvs[0], temp_emissivemap_uvs[1], temp_emissivemap_uvs[2], temp_emissivemap_uvs[3]);
	vertex_float4(bulk_dynamic_layer_vertex_buffer, temp_metallic, temp_roughness, temp_emissive, temp_emissive_multiplier);
	
	// Increment Index
	i++;
}

show_debug_message(bulk_dynamic_layer_vertex_entries);

// Finish Initializing Vertex Buffer
vertex_end(bulk_dynamic_layer_vertex_buffer);
vertex_freeze(bulk_dynamic_layer_vertex_buffer);

// Toggle Vertex Buffer Exists
bulk_dynamic_layer_vertex_buffer_exists = true;