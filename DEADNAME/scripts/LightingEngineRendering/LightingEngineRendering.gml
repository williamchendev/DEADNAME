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
	
	// Set Shader PBR Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normal_strength_index, normal_strength);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallic_index, metallic ? 1 : -1);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_roughness_index, max(roughness, 0.01));
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissive_index, emissive);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissive_multiplier_index, emissive_multiplier);
	
	// Set Shader Normal Map Toggle and Texture Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_enabled_index, temp_mrt_shader_normal_enabled ? 1 : 0);
	
	if (temp_mrt_shader_normal_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index, normalmap_texture);
		shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index, normalmap_uvs[0], normalmap_uvs[1], normalmap_uvs[2], normalmap_uvs[3]);
	}
	else
	{
		shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index, -1, -1, -1, -1);
	}
	
    // Set Shader Metallic-Roughness Map Toggle and Texture Settings
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_enabled_index, temp_mrt_shader_metallicroughness_enabled ? 1 : 0);
    
    if (temp_mrt_shader_metallicroughness_enabled)
    {
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_texture_index, metallicroughnessmap_texture);
		shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_uv_index, metallicroughnessmap_uvs[0], metallicroughnessmap_uvs[1], metallicroughnessmap_uvs[2], metallicroughnessmap_uvs[3]);
    }
    else
	{
		shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_uv_index, -1, -1, -1, -1);
	}
    
    // Set Shader Bloom Map Toggle and Texture Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_enabled_index, temp_mrt_shader_emissive_enabled ? 1 : 0);
	
	if (temp_mrt_shader_emissive_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_texture_index, emissivemap_texture);
		shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_uv_index, emissivemap_uvs[0], emissivemap_uvs[1], emissivemap_uvs[2], emissivemap_uvs[3]);
	}
	else
	{
		shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_uv_index, -1, -1, -1, -1);
	}
    
    // Set Shader Sprite Scale & Rotation Settings
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index, x_scale, y_scale, 1);
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index, rotation);
    
    // Draw Sprite
    draw_sprite_ext(diffusemap_index, diffusemap_subimage, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}

/// @function lighting_engine_render_sprite_alpha_filtered(diffusemap_index, diffusemap_subimage, normalmap_texture, metallicroughnessmap_texture, emissivemap_texture, alphafiltermap_texture, normalmap_uvs, metallicroughnessmap_uvs, emissivemap_uvs, alphafiltermap_uvs, alpha_filter, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
/// @description Draws an Alpha Filtered Sprite through the Deferred Lighting Engine's Multi-Render-Target System using a Diffuse/Normal/Metallic/Roughness/Emissive workflow with the given arguments
/// @param {sprite} diffusemap_index - The Rendered Sprite's Diffuse Map as a Sprite Index Asset
/// @param {real} diffusemap_subimage - The Rendered Sprite's Subimage Index
/// @param {?texture} normalmap_texture - The Rendered Sprite's Normal Map as a texture index, can be optionally assigned as undefined to disable rendering a Normal Map (Normal Map by default is tangent with View Vector)
/// @param {?texture} metallicroughnessmap_texture - The Rendered Sprite's MetallicRoughness Map as a texture index, can be optionally assigned as undefined to disable rendering a MetallicRoughness Map (defaults to the metallic and roughness values in the given arguments)
/// @param {?texture} emissivemap_texture - The Rendered Sprite's Emissive Map as a texture index, can be optionally assigned as undefined to disable rendering a Emissive Map (defaults to the emissive values in the given arguments)
/// @param {?texture} alphafiltermap_texture - The Rendered Sprite's Alpha Filtering Map as a texture index, determines the Alpha Filtering Effect as the texture to sample from (Uses the Red Channel on a spectrum from 0 to 1, 0 = Filtered, and 1 = Not-Filtered)
/// @param {?array<real>} normalmap_uvs - The Rendered Sprite's Normal Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {?array<real>} metallicroughnessmap_uvs - The Rendered Sprite's Metallic Roughness Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {?array<real>} emissivemap_uvs - The Rendered Sprite's Emissive Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {?array<real>} alphafiltermap_uvs - The Rendered Sprite's Alpha Filtering Map's transformed texture coordinate UVs, usually are created by utilizing the spritepack_get_uvs_transformed() method
/// @param {real} alpha_filter - The Rendered Sprite's Alpha Filter value between a 0 to 1 range, this value is used to multiply the Alpha Filter effect's strength or even toggle it on or off
/// @param {real} x_pos - The X coordinate within a scene to draw the Rendered Sprite
/// @param {real} y_pos - The Y coordinate within a scene to draw the Rendered Sprite
/// @param {real} x_scale - The horizontal scale to draw the Rendered Sprite
/// @param {real} y_scale - The vertical scale to draw the Rendered Sprite
/// @param {real} rotation - The angle to draw the Rendered Sprite rotated
/// @param {int} color - The color to draw the Rendered Sprite
/// @param {real} alpha - The transparency to draw the Rendered Sprite
function lighting_engine_render_sprite_alpha_filtered(diffusemap_index, diffusemap_subimage, normalmap_texture, metallicroughnessmap_texture, emissivemap_texture, alphafiltermap_texture, normalmap_uvs, metallicroughnessmap_uvs, emissivemap_uvs, alphafiltermap_uvs, alpha_filter, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    // Toggle Shader Effects: Normal Channel, Specular Channel, & Bloom Channel
	var temp_mrt_shader_normal_enabled = normalmap_texture != undefined;
	var temp_mrt_shader_metallicroughness_enabled = metallicroughnessmap_texture != undefined;
	var temp_mrt_shader_emissive_enabled = emissivemap_texture != undefined;
	
	// Set Shader Normal Map Toggle and Texture Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_normalmap_enabled_index, temp_mrt_shader_normal_enabled ? 1 : 0);
	
	if (temp_mrt_shader_normal_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_normalmap_texture_index, normalmap_texture);
		
		if (temp_mrt_shader_normal_enabled)
		{
			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_normalmap_uv_index, normalmap_uvs[0], normalmap_uvs[1], normalmap_uvs[2], normalmap_uvs[3]);
		}
		else
		{
			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_normalmap_uv_index, -1, -1, -1, -1);
		}
	}
	
    // Set Shader Metallic-Roughness Map Toggle and Texture Settings
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_metallicroughnessmap_enabled_index, temp_mrt_shader_metallicroughness_enabled ? 1 : 0);
    
    if (temp_mrt_shader_metallicroughness_enabled)
    {
    	texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_metallicroughnessmap_texture_index, metallicroughnessmap_texture);
		
		if (temp_mrt_shader_metallicroughness_enabled)
		{
			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_metallicroughnessmap_uv_index, metallicroughnessmap_uvs[0], metallicroughnessmap_uvs[1], metallicroughnessmap_uvs[2], metallicroughnessmap_uvs[3]);
		}
		else
		{
			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_metallicroughnessmap_uv_index, -1, -1, -1, -1);
		}
    }
    
    // Set Shader Bloom Map Toggle and Texture Settings
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissivemap_enabled_index, temp_mrt_shader_emissive_enabled ? 1 : 0);
	
	if (temp_mrt_shader_emissive_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissivemap_texture_index, emissivemap_texture);
		
		if (temp_mrt_shader_emissive_enabled)
		{
			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissivemap_uv_index, emissivemap_uvs[0], emissivemap_uvs[1], emissivemap_uvs[2], emissivemap_uvs[3]);
		}
		else
		{
			shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissivemap_uv_index, -1, -1, -1, -1);
		}
	}
	
	// Set Shader Alpha Filter Texture Settings
	texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissivemap_texture_index, alphafiltermap_texture);
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissivemap_uv_index, alphafiltermap_uvs[0], alphafiltermap_uvs[1], alphafiltermap_uvs[2], alphafiltermap_uvs[3]);
    
    // Set Shader Sprite Scale & Rotation Settings
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_vector_scale_index, x_scale, y_scale, 1);
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_vector_angle_index, rotation);
    
    // Set Shader Sprite Alpha Filter Value
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_alpha_filter_index, alpha_filter);
    
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
			case LightingEngineSubLayerType.BulkDynamic:
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
				case LightingEngineObjectType.BulkDynamic_Layer:
					// Draw Bulk Dynamic Layer Vertex Buffer as compiled Textured Primitive
					if (temp_sub_layer_object.bulk_dynamic_layer_vertex_buffer_exists)
					{
						vertex_submit(temp_sub_layer_object.bulk_dynamic_layer_vertex_buffer, pr_trianglelist, temp_sub_layer_object.bulk_dynamic_layer_texture);
					}
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
				case LightingEngineObjectType.Dynamic_Item:
					// Draw Dynamic Object (Item) on Dynamic Layer
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
						
						// Draw Dynamic Object (Item)
						switch (global.item_packs[item_pack].item_type)
						{
							case ItemType.Default:
								// Draw Default Item
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
								break;
							case ItemType.Weapon:
								// Draw Weapon Item
								item_instance.render_behaviour();
								break;
							case ItemType.None:
							default:
								break;
						}
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
						
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_particle_shader_layer_depth_index, temp_sub_layer_depth);
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
				case LightingEngineObjectType.Dynamic_Cloud:
					// Draw Dynamic Cloud on Dynamic Layer
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
						
						// Set & Prepare Dynamic Sprite Alpha Filter Shader
						shader_set(shd_mrt_deferred_lighting_dynamic_sprite_alpha_filter);
						
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_layer_depth_index, temp_sub_layer_depth);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
						
						// Set Dynamic Sprite Alpha Filter Shader PBR Settings
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_normal_strength_index, normal_strength);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_metallic_index, metallic ? 1 : -1);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_roughness_index, max(roughness, 0.01));
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissive_index, emissive);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_alpha_filtered_shader_emissive_multiplier_index, emissive_multiplier);
						
						// Iterate through Dynamic Cloud DS Lists to Draw Dynamic Cloud
						var temp_cloud_index = 0;
						
						repeat (ds_list_size(clouds_image_index_list))
						{
							// Establish Cloud Draw Variables
							var temp_cloud_image_index = ds_list_find_value(clouds_image_index_list, temp_cloud_index);
							var temp_cloud_rotation = ds_list_find_value(clouds_rotation_list, temp_cloud_index);
							var temp_cloud_horizontal_offset = ds_list_find_value(clouds_horizontal_offset_list, temp_cloud_index);
							var temp_cloud_vertical_offset = ds_list_find_value(clouds_vertical_offset_list, temp_cloud_index);
							var temp_cloud_horizontal_scale = ds_list_find_value(clouds_horizontal_scale_list, temp_cloud_index);
							var temp_cloud_vertical_scale = ds_list_find_value(clouds_vertical_scale_list, temp_cloud_index);
							var temp_cloud_alpha = ds_list_find_value(clouds_alpha_list, temp_cloud_index);
							var temp_cloud_alpha_filter = ds_list_find_value(clouds_alpha_filter_list, temp_cloud_index);
							var temp_cloud_color = ds_list_find_value(clouds_color_list, temp_cloud_index);
							
							// Draw Cloud Sprite Alpha Filtered
							lighting_engine_render_sprite_alpha_filtered
							(
								sprite_index,
								temp_cloud_image_index,
								normalmap_spritepack != undefined ? normalmap_spritepack[temp_cloud_image_index].texture : undefined,
								metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[temp_cloud_image_index].texture : undefined,
								emissivemap_spritepack != undefined ? emissivemap_spritepack[temp_cloud_image_index].texture : undefined,
								alphafiltermap_spritepack[temp_cloud_image_index].texture,
								normalmap_spritepack != undefined ? normalmap_spritepack[temp_cloud_image_index].uvs : undefined,
								metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[temp_cloud_image_index].uvs : undefined,
								emissivemap_spritepack != undefined ? emissivemap_spritepack[temp_cloud_image_index].uvs : undefined,
								alphafiltermap_spritepack[temp_cloud_image_index].uvs,
								temp_cloud_alpha_filter * alpha_filter,
								x + temp_cloud_horizontal_offset,
								y + temp_cloud_vertical_offset,
								temp_cloud_horizontal_scale,
								temp_cloud_vertical_scale,
								temp_cloud_rotation,
								temp_cloud_color,
								temp_cloud_alpha
							);
							
							// Increment Cloud Index
							temp_cloud_index++;
						}
						
						// Reset Dynamic Particle Shader
						shader_reset();
						
						// Retore Default Dynamic Sprite Shader
						shader_set(shd_mrt_deferred_lighting_dynamic_sprite);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index, temp_sub_layer_depth);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
					}
					break;
				case LightingEngineObjectType.Dynamic_SmokeTrail:
					// Draw Dynamic Smoke Trail
					with (temp_sub_layer_object)
					{
						// Rendering Enabled Check
						if (!render_enabled)
						{
							break;
						}
						
						// Reset Default Dynamic Sprite Shader
						shader_reset();
						
						// Set & Prepare Dynamic Smoke Trail Shader
						shader_set(shd_mrt_deferred_lighting_dynamic_smoke_trail);
						
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_smoke_trail_shader_layer_depth_index, temp_sub_layer_depth);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_smoke_trail_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
						
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_smoke_trail_shader_metallic_index, metallic ? 1 : 0);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_smoke_trail_shader_roughness_index, max(roughness, 0.01));
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_smoke_trail_shader_emissive_index, emissive);
						shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_smoke_trail_shader_emissive_multiplier_index, emissive_multiplier);
						
						// Draw Smoke Trail Bezier Curve as Triangle Strip Primitive
						draw_primitive_begin(pr_trianglestrip);
						
						// Iterate through Smoke Trail Segments to draw a connected Bezier Curve
						var temp_trail_length = trail_segments * trail_segments_divisions;
						
						for (var i = 0; i < temp_trail_length; i++)
						{
							var temp_trail_segment = i div trail_segments_divisions;
							
							var temp_trail_segment_bezier_weight_h = trail_segment_bezier_weight_h[temp_trail_segment];
							var temp_trail_segment_bezier_weight_v = trail_segment_bezier_weight_v[temp_trail_segment];
							
							var temp_trail_v = (i mod trail_segments_divisions) / trail_segments_divisions;
							
							var temp_trail_pah = lerp(0, temp_trail_segment_bezier_weight_h, temp_trail_v);
							var temp_trail_pbh = lerp(0, trail_segments_divisions, temp_trail_v);
							var temp_trail_pch = lerp(temp_trail_segment_bezier_weight_h, 0, temp_trail_v);
							var temp_trail_pdh = lerp(temp_trail_pah, temp_trail_pbh, temp_trail_v);
							var temp_trail_peh = lerp(temp_trail_pbh, temp_trail_pch, temp_trail_v);
							var temp_trail_ph = lerp(temp_trail_pdh, temp_trail_peh, temp_trail_v);
							
							var temp_trail_pav = lerp(0, temp_trail_segment_bezier_weight_v, temp_trail_v);
							var temp_trail_pbv = lerp(0, trail_segments_divisions, temp_trail_v);
							var temp_trail_pcv = lerp(temp_trail_segment_bezier_weight_v, 0, temp_trail_v);
							var temp_trail_pdv = lerp(temp_trail_pav, temp_trail_pbv, temp_trail_v);
							var temp_trail_pev = lerp(temp_trail_pbv, temp_trail_pcv, temp_trail_v);
							var temp_trail_pv = lerp(temp_trail_pdv, temp_trail_pev, temp_trail_v);
							
							var temp_trail_prev_position_x = temp_trail_segment - 1 > 0 ? trail_segment_position_x[temp_trail_segment - 1] : 0;
							var temp_trail_position_x = lerp(temp_trail_prev_position_x, trail_segment_position_x[temp_trail_segment], temp_trail_v);
							
							var temp_trail_prev_position_y = temp_trail_segment - 1 > 0 ? trail_segment_position_y[temp_trail_segment - 1] : 0;
							var temp_trail_position_y = lerp(temp_trail_prev_position_y, trail_segment_position_y[temp_trail_segment], temp_trail_v);
							
							var temp_trail_prev_thickness = temp_trail_segment - 1 > 0 ? trail_segment_thickness[temp_trail_segment - 1] : 0.5;
							var temp_trail_thickness = lerp(temp_trail_prev_thickness, trail_segment_thickness[temp_trail_segment], temp_trail_v);
							
							var temp_trail_progress = i / max(temp_trail_length * trail_alpha, 1);
							var temp_trail_alpha = 1 - (temp_trail_progress * temp_trail_progress);
							var temp_trail_color = merge_color(trail_start_color, trail_end_color, temp_trail_alpha * trail_color);
							
							var temp_pos_x = x + temp_trail_position_x + (((i * trail_segments_length) + temp_trail_ph) * trail_vector_h) + (temp_trail_pv * trail_vector_v);
							var temp_pos_y = y + temp_trail_position_y + (((i * trail_segments_length) + temp_trail_ph) * -trail_vector_v) + (temp_trail_pv * trail_vector_h);
							
							if (trail_length < 0 or i * trail_segments_length < trail_length)
							{
								draw_vertex_texture_color(temp_pos_x + (temp_trail_thickness * trail_vector_v), temp_pos_y + (temp_trail_thickness * trail_vector_h), temp_trail_progress, 0, temp_trail_color, temp_trail_alpha * trail_alpha);
								draw_vertex_texture_color(temp_pos_x + (-temp_trail_thickness * trail_vector_v), temp_pos_y + (-temp_trail_thickness * trail_vector_h), temp_trail_progress, 1, temp_trail_color, temp_trail_alpha * trail_alpha);
							}
							else
							{
								break;
							}
						}
						
						// End Vertex Creation and Draw Traingle Strip Primitive
						draw_primitive_end();
						
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
					unit_render_behaviour(temp_sub_layer_object);
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

/// @function lighting_engine_render_unlit_layer();
/// @description Draws the Lighting Engine's Unlit Layer
function lighting_engine_render_unlit_layer()
{
	// Set Unlit Layer's MRT Surface Targets
	surface_set_target_ext(0, LightingEngine.post_processing_surface);
	surface_set_target_ext(1, LightingEngine.diffuse_aggregate_color_surface);
	surface_set_target_ext(2, LightingEngine.aggregate_prb_metalrough_emissive_depth_surface);
	
	// Enable Unlit Sprite Shader
	shader_set(shd_mrt_unlit_sprite);
	
	// Set Unlit Sprite Shader's Camera Offset & Surface Size
	shader_set_uniform_f(LightingEngine.mrt_unlit_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
	shader_set_uniform_f(LightingEngine.mrt_unlit_sprite_shader_surface_size_index, GameManager.game_width + (LightingEngine.render_border * 2), GameManager.game_height + (LightingEngine.render_border * 2));
	
	// Set Unlit Sprite Shader's PBR Detail Map Texture
	texture_set_stage(LightingEngine.mrt_unlit_sprite_shader_prb_metalrough_emissive_depth_texture_index, surface_get_texture(LightingEngine.layered_prb_metalrough_emissive_depth_surface));
	
	// Iterate through Lighting Engine's Unlit Layer Object List
	var temp_unlit_object_index = 0;
	
	repeat (ds_list_size(LightingEngine.lighting_engine_unlit_layer_object_list))
	{
		// Find Unlit Object's Properties
		var temp_unlit_object_instance = ds_list_find_value(LightingEngine.lighting_engine_unlit_layer_object_list, temp_unlit_object_index);
		var temp_unlit_object_type = ds_list_find_value(LightingEngine.lighting_engine_unlit_layer_object_type_list, temp_unlit_object_index);
		var temp_unlit_object_depth = ds_list_find_value(LightingEngine.lighting_engine_unlit_layer_object_depth_list, temp_unlit_object_index);
		
		// Set Unlit Sprite Shader's Object Depth
		shader_set_uniform_f(LightingEngine.mrt_unlit_sprite_shader_layer_depth_index, temp_unlit_object_depth);
		
		// Unlit Object Rendering Behaviour
		switch (temp_unlit_object_type)
		{
			case LightingEngineUnlitObjectType.Hitmarker:
				// Hitmarker Unlit Object Render Behaviour
				with (temp_unlit_object_instance)
				{
					// Check if Hitmarker Impact made Impact
					if (hitmarker_contact)
					{
						// Calculate Hitmarker & Trail Scale
						var temp_hitmarker_sprite_scale = ((1 - trail_multiplier) * hitmarker_sprite_multiplier) + (1 - hitmarker_sprite_multiplier);
						var temp_trail_sprite_scale = (trail_multiplier * trail_sprite_multiplier) + (1 - trail_sprite_multiplier);
						
						// Draw Hitmarker Impact Drop Shadow
						draw_sprite_ext(hitmarker_sprite, hitmarker_image_index, x + hitmarker_dropshadow_horizontal_offset, y + hitmarker_dropshadow_vertical_offset, temp_hitmarker_sprite_scale, temp_hitmarker_sprite_scale, hitmarker_image_angle, c_black, 1);
						draw_sprite_ext(trail_sprite, trail_image_index, x + hitmarker_dropshadow_horizontal_offset, y + hitmarker_dropshadow_vertical_offset, temp_trail_sprite_scale * temp_hitmarker_sprite_scale, temp_hitmarker_sprite_scale, trail_angle, c_black, 1);
						
						// Draw Hitmarker Impact
						draw_sprite_ext(hitmarker_sprite, hitmarker_image_index, x, y, temp_hitmarker_sprite_scale, temp_hitmarker_sprite_scale, hitmarker_image_angle, c_white, 1);
						draw_sprite_ext(trail_sprite, trail_image_index, x, y, temp_trail_sprite_scale * temp_hitmarker_sprite_scale, temp_hitmarker_sprite_scale, trail_angle, c_white, 1);
						
						// Draw Hitmarker Trail
						draw_sprite_ext(sImpact_Trail_Pixel, 0, x, y, trail_distance * trail_multiplier * trail_length_multiplier, trail_thickness, trail_angle, c_white, 1);
					}
					else
					{
						// Draw Hitmarker Trail (Missed Impact - Slightly Transparent)
						draw_sprite_ext(sImpact_Trail_Pixel, 0, x, y, trail_distance * trail_multiplier * trail_length_multiplier, trail_thickness, trail_angle, c_white, 0.35);
					}
				}
				break;
			case LightingEngineUnlitObjectType.Empty:
			default:
				// Empty Unlit Object Type - Skip Object Render
				break;
		}
		
		// Increment Unlit Object Index
		temp_unlit_object_index++;
	}
	
	// Reset Surface & Shader
	surface_reset_target();
	shader_reset();
}

/// @function lighting_engine_render_ui_layer();
/// @description Draws the Lighting Engine's UI Layer
function lighting_engine_render_ui_layer()
{
	// Set Lighting Engine's UI Surface as Surface Target
	surface_set_target(LightingEngine.ui_surface);
	
	// Iterate through Lighting Engine's UI Layer Object List
	var temp_ui_object_index = 0;
	
	repeat (ds_list_size(LightingEngine.lighting_engine_ui_layer_object_list))
	{
		// Find UI Object's Properties
		var temp_ui_object_instance = ds_list_find_value(LightingEngine.lighting_engine_ui_layer_object_list, temp_ui_object_index);
		var temp_ui_object_type = ds_list_find_value(LightingEngine.lighting_engine_ui_layer_object_type_list, temp_ui_object_index);
		var temp_ui_object_depth = ds_list_find_value(LightingEngine.lighting_engine_ui_layer_object_depth_list, temp_ui_object_index);
		
		// UI Object Rendering Behaviour
		switch (temp_ui_object_type)
		{
			case LightingEngineUIObjectType.Interaction:
				// Interaction UI Object Render Behaviour
				if (!temp_ui_object_instance.interaction_hover)
				{
					// Interaction is not selected - Skip Rendering
					break;
				}
				
				// Reset Surface Target
				surface_reset_target();
				
				// Set Effect Surface Target and Clear Effect Surface
				surface_set_target(LightingEngine.fx_surface);
				draw_clear_alpha(c_black, 0);
				
				// Reset Color and Transparency
				draw_set_alpha(1);
				draw_set_color(c_black);
				
				// Draw Interaction's Object Unlit with Outline
				with (temp_ui_object_instance.interaction_object)
				{
					// Compare Interaction Object's Type for correct Unlit Rendering Behaviour
					if (object_index == oUnit or object_is_ancestor(object_index, oUnit))
					{
						// Render Unit Instance Unlit
						unit_unlit_render_behaviour(id, -LightingEngine.render_x, -LightingEngine.render_y);
					}
					else
					{
						// Render Default Interaction Object Instance Unlit
						draw_sprite_ext(sprite_index, image_index, x - LightingEngine.render_x, y - LightingEngine.render_y, image_xscale, image_yscale, image_angle, c_white, 1);
					}
				}
				
				// Reset Surface Target
				surface_reset_target();
				
				// Set Surface Target to UI Surface
				surface_set_target(LightingEngine.ui_surface);
				
				// Set Pixel Outline Effect Shader
				shader_set(shd_pixel_outline);
				
				// Set Pixel Outline Effect Shader's Properties 
				shader_set_uniform_f(LightingEngine.pixel_outline_render_shader_surface_size_index, GameManager.game_width, GameManager.game_height);
				shader_set_uniform_f(LightingEngine.pixel_outline_render_shader_outline_size_index, 1);
				
				// Draw Effect Surface to UI Surface with the Pixel Outline Effect Enabled
				draw_surface_ext(LightingEngine.fx_surface, 0, 0, 1, 1, 0, c_black, image_alpha);
				
				// Reset Shader
				shader_reset();
				
				// Interaction Menu Render Behaviour
				if (temp_ui_object_instance.interaction_selected)
				{
					with (temp_ui_object_instance)
					{
						// Establish Interaction Menu's Position & Text Position
						var temp_interact_menu_x = round(x - LightingEngine.render_x);
						var temp_interact_menu_y = round(y - LightingEngine.render_y);
						
						var temp_interact_menu_text_x = temp_interact_menu_x + interaction_text_horizontal_offset;
						var temp_interact_menu_text_y = temp_interact_menu_y + interaction_text_vertical_offset;
						
						// Establish Interaction Menu's Colors
						var temp_interaction_text_contrast_color = merge_color(interaction_text_color, c_black, interaction_text_contrast_amount);
						var temp_interaction_inverse_text_contrast_color = merge_color(interaction_text_color, c_black, 1 - interaction_text_contrast_amount);
						
						// Draw Interaction Menu's Black Background for the List of Options
						draw_rectangle(temp_interact_menu_x, temp_interact_menu_y + interaction_option_height + 1, temp_interact_menu_x + interact_menu_width, temp_interact_menu_y + interact_menu_height, false);
						
						// Set Interaction Menu's Transparent Title Background Color and Transparency
						draw_set_alpha(0.55);
						draw_set_color(interaction_text_color);
						
						// Draw Interaction Menu's Transparent Title Background
						draw_rectangle(temp_interact_menu_x, temp_interact_menu_y, temp_interact_menu_x + interact_menu_width, temp_interact_menu_y + interaction_option_height, false);
						
						// Set Interaction Menu's Title Underline Color and Transparency
						draw_set_alpha(1);
						draw_set_color(c_black);
						
						// Draw Interaction Menu's Title Underline
						draw_line(temp_interact_menu_x + interaction_text_horizontal_offset - 2, temp_interact_menu_text_y + 12, temp_interact_menu_x + interact_menu_width - interaction_text_horizontal_offset, temp_interact_menu_text_y + 12);
						
						// Set Interaction Menu's Title Text Font
						draw_set_font(GameManager.ui_inspection_text_font);
						
						// Set Interaction Menu's Title Text Alignment
						draw_set_halign(fa_left);
						draw_set_valign(fa_top);
						
						// Draw Interaction Menu's Title
						draw_text_outline(temp_interact_menu_text_x, temp_interact_menu_text_y, interaction_object_name);
						
						// Set Interaction Option Text Font
						draw_set_font(interact_menu_option_font);
						
						// Set Interaction Options List Text Drop Shadow Color
						draw_set_color(temp_interaction_text_contrast_color);
						
						// Draw Interaction Options List Text Drop Shadow
						for (var temp_interact_menu_option_index = 0; temp_interact_menu_option_index < array_length(interact_options); temp_interact_menu_option_index++)
						{
							// Establish Interaction Option's Text Drop Shadow Position Variables
							var temp_interact_menu_option_shadow_x = temp_interact_menu_text_x + interaction_option_text_horizontal_offset;
							var temp_interact_menu_option_shadow_y = temp_interact_menu_text_y + interaction_option_text_vertical_offset + ((temp_interact_menu_option_index + 1) * interaction_option_height);
							
							// Draw Interaction Option's Text Drop Shadow
							draw_text(temp_interact_menu_option_shadow_x, temp_interact_menu_option_shadow_y + 1, interact_options[temp_interact_menu_option_index].option_name);
							draw_text(temp_interact_menu_option_shadow_x + 1, temp_interact_menu_option_shadow_y + 1, interact_options[temp_interact_menu_option_index].option_name);
						}
						
						// Set Interaction Options List Text Color
						draw_set_color(interaction_text_color);
						
						// Draw Interaction Options List Text
						for (var temp_interact_menu_option_index = 0; temp_interact_menu_option_index < array_length(interact_options); temp_interact_menu_option_index++)
						{
							// Establish Interaction Option's Text Position Variables
							var temp_interact_menu_option_x = temp_interact_menu_text_x + interaction_option_text_horizontal_offset;
							var temp_interact_menu_option_y = temp_interact_menu_text_y + interaction_option_text_vertical_offset + ((temp_interact_menu_option_index + 1) * interaction_option_height);
							
							// Draw Interaction Option's Text
							draw_text(temp_interact_menu_option_x, temp_interact_menu_option_y, interact_options[temp_interact_menu_option_index].option_name);
						}
						
						// Interaction Option Selection Highlighted Render Behaviour
						if (interaction_option_index != -1)
						{
							// Draw Interaction Menu Option Selected
							var temp_interact_option_vertical_offset = (interaction_option_index + 1) * interaction_option_height;
							draw_rectangle(temp_interact_menu_x, temp_interact_menu_y + temp_interact_option_vertical_offset + 1, temp_interact_menu_x + interact_menu_width, temp_interact_menu_y + temp_interact_option_vertical_offset + interaction_option_height, false);
							
							// Establish Triangle Position Variables
							var temp_tri_x = temp_interact_menu_x + interaction_option_triangle_horizontal_offset;
							var temp_tri_y = temp_interact_menu_y + interaction_option_triangle_vertical_offset + (interaction_option_height * 0.5);
							
							// Establish Interaction Option's Text Position Variables
							var temp_interact_option_selected_text_x = temp_interact_menu_text_x + interaction_option_text_horizontal_offset + interaction_option_triangle_horizontal_offset;
							var temp_interact_option_selected_text_y = temp_interact_menu_text_y + interaction_option_text_vertical_offset + ((interaction_option_index + 1) * interaction_option_height);
							
							// Set Select Triangle & Select Interaction Option's Text Contrast Drop Shadow Color
							draw_set_color(temp_interaction_inverse_text_contrast_color);
							
							// Draw Interaction Option's Text Contrast Drop Shadow
							draw_text(temp_interact_option_selected_text_x, temp_interact_option_selected_text_y + 1, interact_options[interaction_option_index].option_name);
							draw_text(temp_interact_option_selected_text_x + 1, temp_interact_option_selected_text_y + 1, interact_options[interaction_option_index].option_name);
							
							// Draw Triangle's Contrast Drop Shadow
							draw_triangle(temp_tri_x + tri_x_1 + 1, temp_tri_y + tri_y_1 + 1, temp_tri_x + tri_x_2 + 1, temp_tri_y + tri_y_2 + 1, temp_tri_x + tri_x_3 + 1, temp_tri_y + tri_y_3 + 1, false);
							
							// Set Select Triangle & Select Interaction Option's Text Color
							draw_set_color(c_black);
							
							// Draw Interaction Option's Text
							draw_text(temp_interact_option_selected_text_x, temp_interact_option_selected_text_y, interact_options[interaction_option_index].option_name);
							
							// Draw Triangle
							draw_triangle(temp_tri_x + tri_x_1, temp_tri_y + tri_y_1, temp_tri_x + tri_x_2, temp_tri_y + tri_y_2, temp_tri_x + tri_x_3, temp_tri_y + tri_y_3, false);
						}
					}
				}
				break;
			case LightingEngineUIObjectType.Dialogue:
				// Dialogue Box UI Object Render Behaviour
				with (temp_ui_object_instance)
				{
					// Reset Surface Target
					surface_reset_target();
					
					// Set Effect Surface Target and Clear Effect Surface
					surface_set_target(LightingEngine.fx_surface);
					draw_clear_alpha(c_black, 0);
					
					// Draw Dialogue Box Tail Bezier Curve
					bezier_curve_draw(dialogue_tail_instance);
					
					// Set Dialogue Font and Alignment
					draw_set_font(dialogue_font);
					draw_set_halign(fa_center);
					draw_set_valign(fa_middle);
					
					// Create Dialogue Box's Display Text Sub-String
					var temp_dialogue_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
					
					// Find Dialogue Box's Width and Height
					var temp_dialogue_text_width = (max(string_width_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width), string_width("ABCDE")) + dialogue_box_horizontal_padding) * 0.5;
					var temp_dialogue_text_height = max(string_height_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width), string_height("ABCDE")) + dialogue_box_vertical_padding;
					
					// Find Dialogue Box's Position
					var temp_x = round(x - LightingEngine.render_x);
					var temp_y = round(y - LightingEngine.render_y);
					
					var temp_text_x = temp_x + dialogue_font_horizontal_offset;
					var temp_text_y = temp_y + dialogue_font_vertical_offset - (temp_dialogue_text_height * 0.5) - dialogue_breath_padding;
					
					// Set Dialogue Box Transparency and Color
					draw_set_alpha(1);
					draw_set_color(dialogue_box_color);
					
					// Draw Dialogue Box's Tail
					if (dialogue_tail)
					{
						draw_sprite_ext(dialogue_tail_sprite, 0, temp_x, temp_y + dialogue_box_breath_value - dialogue_breath_padding, image_xscale, image_yscale, 0, dialogue_box_color, 1);
					}
					
					// Draw Dialogue Box's Round Rectangle Background
					draw_roundrect(temp_x - temp_dialogue_text_width - dialogue_box_breath_value, temp_y - temp_dialogue_text_height - dialogue_box_breath_value - dialogue_breath_padding, temp_x + temp_dialogue_text_width + dialogue_box_breath_value, temp_y + dialogue_box_breath_value - dialogue_breath_padding, false);
					
					// Draw Dialogue Text's Contrast Drop Shadow
					draw_set_color(merge_color(dialogue_text_color, c_black, dialogue_text_contrast_amount));
					draw_text_ext(temp_text_x, temp_text_y + 1, temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width);
					draw_text_ext(temp_text_x + 1, temp_text_y + 1, temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width);
					
					// Draw Dialogue Text
					draw_set_color(dialogue_text_color);
					draw_text_ext(temp_text_x, temp_text_y, temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width);
					
					// Draw Dialogue Box Continue Triangle
					if (dialogue_triangle)
					{
						// Triangle Variables
						var temp_tri_x = temp_x + temp_dialogue_text_width + dialogue_triangle_offset + dialogue_box_breath_value;
						var temp_tri_y = temp_y + dialogue_triangle_offset + dialogue_box_breath_value - dialogue_breath_padding;
						
						// Draw Triangle's Contrast Drop Shadow
						draw_set_color(c_gray);
						draw_triangle(temp_tri_x + tri_x_1 + 1, temp_tri_y + tri_y_1 + 1, temp_tri_x + tri_x_2 + 1, temp_tri_y + tri_y_2 + 1, temp_tri_x + tri_x_3 + 1, temp_tri_y + tri_y_3 + 1, false);
						
						// Draw Triangle
						draw_set_color(c_white);
						draw_triangle(temp_tri_x + tri_x_1, temp_tri_y + tri_y_1, temp_tri_x + tri_x_2, temp_tri_y + tri_y_2, temp_tri_x + tri_x_3, temp_tri_y + tri_y_3, false);
					}
					
					// Reset Surface Target
					surface_reset_target();
					
					// Set Surface Target to UI Surface
					surface_set_target(LightingEngine.ui_surface);
					
					// Draw Completed Dialogue Box, Text, Tail, and (possibly) Continue Triangle to UI Surface with Dialogue Box Transparency
					draw_surface_ext(LightingEngine.fx_surface, 0, 0, 1, 1, 0, c_white, image_alpha * image_alpha);
				}
				break;
			case LightingEngineUIObjectType.Empty:
			default:
				// Empty UI Object Type - Skip Object Render
				break;
		}
		
		// Increment UI Object Index
		temp_ui_object_index++;
	}
	
	// Reset Surface
	surface_reset_target();
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
	
	surface_free(LightingEngine.fx_surface);
	surface_free(LightingEngine.ui_surface);
	
	// Free Debug Surface
	if (global.debug_surface_enabled)
	{
		surface_free(LightingEngine.debug_surface);
	}
}
