/// @function lighting_engine_render_sprite_ext(diffusemap_index, diffusemap_subimage, normalmap_texture, metallicroughnessmap_texture, emissivemap_texture, normalmap_uvs, metallicroughnessmap_uvs, emissivemap_uvs, normal_strength, metallic, roughness, emissive, emissive_multiplier, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
/// @description Draws a Sprite through the Deferred Lighting Engine's Multi-Render-Target System using a Diffuse/Normal/Metallic/Roughness/Emissive workflow with the given arguments
/// @param {sprite} diffusemap_index - The Rendered Sprite's Diffuse Map as a Sprite Index Asset
/// @param {real} diffusemap_subimage - The Rendered Sprite's Subimage Index
/// @param {?texture} normalmap_texture - The Rendered Sprite's Normal Map as a texture index, can be optionally assigned as undefined to disable rendering a Normal Map (Normal Map by default is tangent with View Vector)
/// @param {?texture} metallicroughnessmap_texture - The Rendered Sprite's MetallicRoughness Map as a texture index, can be optionally assigned as undefined to disable rendering a MetallicRoughness Map (defaults to the metallic and roughness values in the given arguments)
/// @param {?texture} emissivemap_texture - The Rendered Sprite's Emissive Map as a texture index, can be optionally assigned as undefined to disable rendering a Emissive Map (defaults to the emissive values in the given arguments)
/// @param {?array<real>} normalmap_uvs - The Rendered Sprite's Normal Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {?array<real>} metallicroughnessmap_uvs - The Rendered Sprite's Metallic Roughness Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {?array<real>} emissivemap_uvs - The Rendered Sprite's Emissive Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {real} normal_strength - The value to interpolate the given Normal Map towards being tangent with the View Vector on a 0 to 1 range, 0 is completely tangent with the View Vector, 1 is the unchanged value of the given Normal Map
/// @param {bool} metallic - Boolean toggle to draw the Rendered Sprite's material as Metallic (true) or Dielectric (false)
/// @param {real} roughness - The Rendered Sprite's roughness value between a 0 to 1 range, determining how much light gets reflected off or even gets trapped in micro-facets within the material
/// @param {real} emissive - The Rendered Sprite's emissive (Bloom) base value between a 0 to 1 range, determines how much light bleed (and blur) of the material's base diffuse color is rendered
/// @param {real} emissive_multiplier - The Rendered Sprite's emissive (Bloom) modifier value between a 0 to 1 range, this value is used to modify an emissive material's bloom effect's strength or even toggle it on or off
/// @param {real} x_pos - The X coordinate within a scene to draw the Rendered Sprite
/// @param {real} y_pos - The Y coordinate within a scene to draw the Rendered Sprite
/// @param {real} x_scale - The horizontal scale to draw the Rendered Sprite
/// @param {real} y_scale - The vertical scale to draw the Rendered Sprite
/// @param {real} rotation - The angle to draw the Rendered Sprite rotated
/// @param {int} color - The color to draw the Rendered Sprite
/// @param {real} alpha - The transparency to draw the Rendered Sprite
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

/// @function lighting_engine_render_layer(render_layer_type);
/// @description Draws the Lighting Engine's Render Layers through the Deferred Lighting Engine's Multi-Render-Target System using a Diffuse/Normal/Metallic/Roughness/Emissive workflow
/// @param {int<LightingEngineRenderLayerType>} render_layer_type - The Render Layer to draw (Back/Mid/Front)
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
						// Rendering Enabled Check
						if (!render_enabled)
						{
							break;
						}
						
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
						// Rendering Enabled Check
						if (!render_enabled)
						{
							break;
						}
						
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
						// Rendering Enabled Check
						if (!render_enabled)
						{
							break;
						}
						
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

/// @function lighting_engine_render_clear_surfaces();
/// @description Clears all surfaces used by the Game's Rendering System - Mostly used when changing the Game Scene Type, Game Window's Resolution, or Ending the Game
function lighting_engine_render_clear_surfaces()
{
	// Free Surfaces
	surface_free(LightingEngine.background_surface);
	
	surface_free(LightingEngine.diffuse_back_color_surface);
	surface_free(LightingEngine.diffuse_mid_color_surface);
	surface_free(LightingEngine.diffuse_front_color_surface);
	surface_free(LightingEngine.diffuse_aggregate_color_surface);
	
	surface_free(LightingEngine.pbr_lighting_back_color_surface);
	surface_free(LightingEngine.pbr_lighting_mid_color_surface);
	surface_free(LightingEngine.pbr_lighting_front_color_surface);
	
	surface_free(LightingEngine.shadowmap_surface);
	surface_free(LightingEngine.normalmap_vector_surface);
	
	surface_free(LightingEngine.layered_prb_metalrough_emissive_depth_surface);
	surface_free(LightingEngine.background_prb_metalrough_emissive_depth_surface);
	surface_free(LightingEngine.aggregate_prb_metalrough_emissive_depth_surface);
	
	surface_free(LightingEngine.bloom_effect_surface);
	surface_free(LightingEngine.distortion_horizontal_effect_surface);
	surface_free(LightingEngine.distortion_vertical_effect_surface);
	
	surface_free(LightingEngine.post_processing_surface);
	surface_free(LightingEngine.final_render_surface);
	
	surface_free(LightingEngine.ui_surface);
	
	// Free Debug Surface
	if (global.debug_surface_enabled)
	{
		surface_free(LightingEngine.debug_surface);
	}
}
