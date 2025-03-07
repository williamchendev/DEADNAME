
function lighting_engine_render_sprite_ext(diffusemap_index, diffusemap_subimage, normalmap_texture, metallicroughnessmap_texture, emissivemap_texture, normalmap_uvs, metallicroughnessmap_uvs, emissivemap_uvs, normal_strength, metallic, roughness, emissive, emissive_multiplier, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    // Toggle Shader Effects: Normal Channel, Specular Channel, & Bloom Channel
	var temp_mrt_shader_normal_enabled = normalmap_texture != undefined;
	var temp_mrt_shader_metallicroughness_enabled = metallicroughnessmap_texture != undefined;
	var temp_mrt_shader_emissive_enabled = emissivemap_texture != undefined;
	
	var temp_normalmap_uvs = temp_mrt_shader_normal_enabled ? normalmap_uvs : [ -1, -1, -1, -1 ];
	var temp_metallicroughnessmap_uvs = temp_mrt_shader_metallicroughness_enabled ? metallicroughnessmap_uvs : [ -1, -1, -1, -1 ];
	var temp_emissivemap_uvs = temp_mrt_shader_emissive_enabled ? emissivemap_uvs : [ -1, -1, -1, -1 ];
	
	// Set Shader PBR Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normal_strength_index, normal_strength);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallic_index, metallic ? 1 : 0);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_roughness_index, max(roughness, 0.01));
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissive_index, emissive);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissive_multiplier_index, emissive_multiplier);
	
	// Set Shader Normal Map Toggle and Texture Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_enabled_index, temp_mrt_shader_normal_enabled ? 1 : 0);
	
	if (temp_mrt_shader_normal_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index, normalmap_texture);
		shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index, temp_normalmap_uvs);
	}
	
    // Set Shader Metallic-Roughness Map Toggle and Texture Settings
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_enabled_index, temp_mrt_shader_metallicroughness_enabled ? 1 : 0);
    
    if (temp_mrt_shader_metallicroughness_enabled)
    {
    	texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_texture_index, metallicroughnessmap_texture);
    	shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_uv_index, temp_metallicroughnessmap_uvs);
    }
    
    // Set Shader Bloom Map Toggle and Texture Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_enabled_index, temp_mrt_shader_emissive_enabled ? 1 : 0);
	
	if (temp_mrt_shader_emissive_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_texture_index, emissivemap_texture);
    	shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_uv_index, temp_emissivemap_uvs);
	}
    
    // Set Shader Sprite Scale & Rotation Settings
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index, x_scale, y_scale, 1);
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index, rotation);
    
    // Draw Sprite
    draw_sprite_ext(diffusemap_index, diffusemap_subimage, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}

function lighting_engine_render_layer(render_layer_type)
{
	// Establish Empty Render Layer Variables
	var temp_render_layer_sub_layer_name_list = undefined;
	var temp_render_layer_sub_layer_depth_list = undefined;
	var temp_render_layer_sub_layer_type_list = undefined;
	var temp_render_layer_sub_layer_object_list = undefined;
	var temp_render_layer_sub_layer_object_type_list = undefined;
	
	// Assign Render Layer Variables from given Render Layer Type
	switch (render_layer_type)
	{
		case LightingEngineRenderLayerType.Back:
			temp_render_layer_sub_layer_name_list = LightingEngine.lighting_engine_back_layer_sub_layer_name_list;
			temp_render_layer_sub_layer_depth_list = LightingEngine.lighting_engine_back_layer_sub_layer_depth_list;
			temp_render_layer_sub_layer_type_list = LightingEngine.lighting_engine_back_layer_sub_layer_type_list;
			temp_render_layer_sub_layer_object_list = LightingEngine.lighting_engine_back_layer_sub_layer_object_list;
			temp_render_layer_sub_layer_object_type_list = LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list;
			break;
		case LightingEngineRenderLayerType.Front:
			temp_render_layer_sub_layer_name_list = LightingEngine.lighting_engine_front_layer_sub_layer_name_list;
			temp_render_layer_sub_layer_depth_list = LightingEngine.lighting_engine_front_layer_sub_layer_depth_list;
			temp_render_layer_sub_layer_type_list = LightingEngine.lighting_engine_front_layer_sub_layer_type_list;
			temp_render_layer_sub_layer_object_list = LightingEngine.lighting_engine_front_layer_sub_layer_object_list;
			temp_render_layer_sub_layer_object_type_list = LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list;
			break;
		case LightingEngineRenderLayerType.Mid:
		default:
			temp_render_layer_sub_layer_name_list = LightingEngine.lighting_engine_mid_layer_sub_layer_name_list;
			temp_render_layer_sub_layer_depth_list = LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list;
			temp_render_layer_sub_layer_type_list = LightingEngine.lighting_engine_mid_layer_sub_layer_type_list;
			temp_render_layer_sub_layer_object_list = LightingEngine.lighting_engine_mid_layer_sub_layer_object_list;
			temp_render_layer_sub_layer_object_type_list = LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list;
			break;
	}
	
	// Iterate through Render Layer's Sub Layers
	var temp_sub_layer_index = 0;
	
	repeat (ds_list_size(temp_render_layer_sub_layer_name_list))
	{
		// Get Render Layer Name, Depth, and Type
		var temp_sub_layer_name = ds_list_find_value(temp_render_layer_sub_layer_name_list, temp_sub_layer_index);
		var temp_sub_layer_depth = ds_list_find_value(temp_render_layer_sub_layer_depth_list, temp_sub_layer_index);
		var temp_sub_layer_type = ds_list_find_value(temp_render_layer_sub_layer_type_list, temp_sub_layer_index);
		
		// Get Render Layer Object and Object Type DS Lists
		var temp_sub_layer_object_list = ds_list_find_value(temp_render_layer_sub_layer_object_list, temp_sub_layer_index);
		var temp_sub_layer_object_type_list = ds_list_find_value(temp_render_layer_sub_layer_object_type_list, temp_sub_layer_index);
		
		// Set Lighting Engine Layer Depth
		LightingEngine.lighting_engine_sub_layer_depth = temp_sub_layer_depth;
		
		// Set Shader Properties based on Sub Layer Type
		switch (temp_sub_layer_type)
		{
			case LightingEngineSubLayerType.BulkStatic:
				// MRT Bulk Static Sprite Layer
				shader_set(shd_mrt_deferred_lighting_bulk_static_sprite);
				
				// Set Sub Layer Depth
				shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_bulk_static_sprite_shader_layer_depth_index, temp_sub_layer_depth);
				
				// Set Camera Offset
				shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_bulk_static_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
				break;
			case LightingEngineSubLayerType.Dynamic:
			default:
				// MRT Dynamic Sprite Layer
				shader_set(shd_mrt_deferred_lighting_dynamic_sprite);
				
				// Set Sub Layer Depth
    			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index, temp_sub_layer_depth);
    			
    			// Set Camera Offset
				shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
				break;
		}
		
		// Iterate through Sub Layer's Objects List
		var temp_sub_layer_object_index = 0;
	
		repeat (ds_list_size(temp_sub_layer_object_type_list))
		{
			// Get Sub Layer Object and Object Type
			var temp_sub_layer_object = ds_list_find_value(temp_sub_layer_object_list, temp_sub_layer_object_index);
			var temp_sub_layer_object_type = ds_list_find_value(temp_sub_layer_object_type_list, temp_sub_layer_object_index);
			
			// Draw Object based on Object Type
			switch (temp_sub_layer_object_type)
			{
				case LightingEngineObjectType.BulkStatic_Region:
					// Draw Bulk Static Region Vertex Buffer on Bulk Static Layer
					with (temp_sub_layer_object)
					{
						if (region_render_enabled)
						{
							vertex_submit(ds_map_find_value(bulk_static_region_vertex_buffer_map, temp_sub_layer_name), pr_trianglelist, ds_map_find_value(bulk_static_region_texture_map, temp_sub_layer_name));
						}
					}
					break;
				case LightingEngineObjectType.BulkStatic_Layer:
					// Draw Bulk Static Layer Vertex Buffer with Texture from Sub-Layer Vertex Buffer and Texture Struct
					vertex_submit(temp_sub_layer_object.bulk_static_vertex_buffer, pr_trianglelist, temp_sub_layer_object.bulk_static_texture);
					break;
				case LightingEngineObjectType.Dynamic_Basic:
					// Draw Dynamic Object (Basic) on Dynamic Layer
					with (temp_sub_layer_object)
					{
						// Region Culling Check
						if (region_culled)
						{
							// Find Region Culling Instance
							var temp_region = ds_map_find_value(LightingEngine.lighting_engine_culling_regions_map, region_culling_id);
							
							// Check if Region Culling Instance is Indexed
							if (!is_undefined(temp_region))
							{
								// Check if Region is being Culled
								if (!temp_region.region_render_enabled)
								{
									// Region Render Disabled - Skip Drawing Object
									break;
								}
							}
						}
						
						// Draw Dynamic Object (Basic)
						lighting_engine_render_sprite_ext
						(
							sprite_index,
							image_index,
							normalmap_spritepack != undefined ? normalmap_spritepack[image_index].texture : undefined,
							metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[image_index].texture : undefined,
							emissivemap_spritepack != undefined ? emissivemap_spritepack[image_index].texture : undefined,
							normalmap_spritepack != undefined ? normalmap_spritepack[image_index].uvs : undefined,
							metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[image_index].uvs : undefined,
							emissivemap_spritepack != undefined ? emissivemap_spritepack[image_index].uvs : undefined,
							normal_strength,
							metallic,
							roughness,
							emissive,
							emissive_multiplier,
							x,
							y,
							image_xscale,
							image_yscale,
							image_angle,
							image_blend,
							image_alpha
						);
					}
					break;
				case LightingEngineObjectType.Dynamic_Particle:
					// Draw Dynamic Particle System
					with (temp_sub_layer_object)
					{
						// Region Culling Check
						if (region_culled)
						{
							// Find Region Culling Instance
							var temp_region = ds_map_find_value(LightingEngine.lighting_engine_culling_regions_map, region_culling_id);
							
							// Check if Region Culling Instance is Indexed
							if (!is_undefined(temp_region))
							{
								// Check if Region is being Culled
								if (!temp_region.region_render_enabled)
								{
									// Region Render Disabled - Skip Drawing Object
									break;
								}
							}
						}
						
						// Reset Default Dynamic Sprite Shader
						shader_reset();
						
						// Set & Prepare Dynamic Particle Shader
						shader_set(shd_mrt_deferred_lighting_particle_system);
						
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_camera_offset_index, temp_sub_layer_depth);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
						
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_metallic_index, metallic ? 1 : 0);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_roughness_index, max(roughness, 0.01));
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_emissive_index, emissive);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_emissive_multiplier_index, emissive_multiplier);
						
						// Draw Particle System
						part_system_drawit(temp_sub_layer_object.dynamic_particle_system);
						
						// Reset Dynamic Particle Shader
						shader_reset();
						
						// Retore Default Dynamic Sprite Shader
						shader_set(shd_mrt_deferred_lighting_dynamic_sprite);
		    			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index, temp_sub_layer_depth);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
					}
					break;
				case LightingEngineObjectType.Dynamic_Unit:
					// Draw Unit on Dynamic Layer
					with (temp_sub_layer_object)
					{
						// Draw Secondary Arm rendered behind Unit Body
						limb_secondary_arm.render_behaviour();
					
						// Draw Unit Body
						lighting_engine_render_sprite_ext
						(
							sprite_index,
							image_index,
							normalmap_spritepack != undefined ? normalmap_spritepack[image_index].texture : undefined,
							metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[image_index].texture : undefined,
							emissivemap_spritepack != undefined ? emissivemap_spritepack[image_index].texture : undefined,
							normalmap_spritepack != undefined ? normalmap_spritepack[image_index].uvs : undefined,
							metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[image_index].uvs : undefined,
							emissivemap_spritepack != undefined ? emissivemap_spritepack[image_index].uvs : undefined,
							normal_strength,
							metallic,
							roughness,
							emissive,
							emissive_multiplier,
							x,
							y + ground_contact_vertical_offset,
							draw_xscale,
							draw_yscale,
							image_angle + draw_angle_value,
							image_blend,
							image_alpha
						);
						
						// Draw Unit's Weapon (if equipped)
						if (weapon_active)
						{
							weapon_equipped.render_behaviour();
						}
						
						// Draw Primary Arm rendered in front Unit Body
						limb_primary_arm.render_behaviour();
					}
					break;
				default:
					break;
			}
			
			// Increment Object
			temp_sub_layer_object_index++;
		}
		
		// Reset Shader Properties
		shader_reset();
		
		// Increment Sub Layer Index
		temp_sub_layer_index++;
	}
}