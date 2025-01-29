/// @description Create Bulk Static Groups
// Performs a Collision Check with all intersecting Bulk Static Objects and organizes them into Vertex Buffers

// Index all Bulk Static Objects in Vertex Buffer
var temp_bulk_static_objects_list = ds_list_create();
var temp_bulk_static_objects_count = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oLightingEngine_BulkStatic_Object, false, true, temp_bulk_static_objects_list, false);

if (temp_bulk_static_objects_count > 0)
{
	// Create DS Map List of Layers
	var temp_bulk_static_layers_map = ds_map_create();
	
	// Organize Bulk Static Objects into Layers
	for (var i = 0; i < ds_list_size(temp_bulk_static_objects_list); i++)
	{
		// Find Bulk Static Object at Index
		var temp_bulk_static_object = ds_list_find_value(temp_bulk_static_objects_list, i);
		var temp_bulk_static_object_layer = temp_bulk_static_object.sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(temp_bulk_static_object.layer) : temp_bulk_static_object.sub_layer_name;
		
		// Find Layer List & Create Layer List if Layer List does not exist
		var temp_bulk_static_layer_list = ds_map_find_value(temp_bulk_static_layers_map, temp_bulk_static_object_layer);
		
		if (is_undefined(temp_bulk_static_layer_list))
		{
			// Add Layer List to Layers DS Map
			temp_bulk_static_layer_list = ds_list_create();
			ds_map_add_list(temp_bulk_static_layers_map, temp_bulk_static_object_layer, temp_bulk_static_layer_list);
		}
		
		// Add Bulk Static Object to Bulk Static Group's Layer DS List
		ds_list_add(temp_bulk_static_layer_list, temp_bulk_static_object);
	}
	
	// Iterate through DS Map Layer Lists containing all Bulk Static Objects
	for (var temp_bulk_static_layers_map_key = ds_map_find_first(temp_bulk_static_layers_map); !is_undefined(temp_bulk_static_layers_map_key); temp_bulk_static_layers_map_key = ds_map_find_next(temp_bulk_static_layers_map, temp_bulk_static_layers_map_key)) 
	{
		// Find Layers List from DS Map
		var temp_bulk_static_layers_list_value = ds_map_find_value(temp_bulk_static_layers_map, temp_bulk_static_layers_map_key);
		
		// Sort Layers List
		ds_list_sort(temp_bulk_static_layers_list_value, true);
		
		// Create Vertex Buffer 
		if (!is_undefined(temp_bulk_static_layers_list_value))
		{
			// Vertex Buffer Texture
			var temp_bulk_static_layer_texture = -1;
			
			// Begin Initialize Vertex Buffer
			var temp_bulk_static_layer_vertex_buffer = vertex_create_buffer();
			vertex_begin(temp_bulk_static_layer_vertex_buffer, oLightingEngine.lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format);
			
			// Iterate through all colliding Bulk Static Objects
			for (var i = 0; i < ds_list_size(temp_bulk_static_layers_list_value); i++)
			{
				// Find Bulk Static Object at Index
				var temp_bulk_static_object = ds_list_find_value(temp_bulk_static_layers_list_value, i);
			
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
				
				// Establish UV Data for Bulk Static Object
				var temp_normalmap_uvs = sprite_get_uvs_transformed(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index, temp_bulk_static_object.normalmap_texture, temp_bulk_static_object.image_index);
				var temp_specularmap_uvs = sprite_get_uvs_transformed(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index, temp_bulk_static_object.specularmap_texture, temp_bulk_static_object.image_index);
							
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
				vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normalmap_strength);
				vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
				vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[1]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1], temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
				
				vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_bulk_static_object.image_angle);
				vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normalmap_strength);
				vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
				vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1], temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
				
				vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_bulk_static_object.image_angle);
				vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normalmap_strength);
				vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
				vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1], temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
				
				vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_cx, temp_vertex_coordinate_cy, temp_bulk_static_object.image_angle);
				vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normalmap_strength);
				vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
				vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1], temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
				
				vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_bulk_static_object.image_angle);
				vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normalmap_strength);
				vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
				vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1], temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
				
				vertex_position_3d(temp_bulk_static_layer_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_bulk_static_object.image_angle);
				vertex_normal(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.normalmap_strength);
				vertex_color(temp_bulk_static_layer_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
				vertex_texcoord(temp_bulk_static_layer_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1], temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
				vertex_float4(temp_bulk_static_layer_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1], temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
				
				// Set Bulk Static Group Texture
				temp_bulk_static_layer_texture = sprite_get_texture(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index);
				
				// Destroy Bulk Static Object
				instance_destroy(temp_bulk_static_object.id);
			}
			
			// Finish Initializing Vertex Buffer
			vertex_end(temp_bulk_static_layer_vertex_buffer);
			vertex_freeze(temp_bulk_static_layer_vertex_buffer);
			
			// Index Layer's Texture and Vertex Buffer in Bulk Static Region Vertex Buffers DS Map
			ds_map_add(bulk_static_region_texture_map, temp_bulk_static_layers_map_key, temp_bulk_static_layer_texture);
			ds_map_add(bulk_static_region_vertex_buffer_map, temp_bulk_static_layers_map_key, temp_bulk_static_layer_vertex_buffer);
			
			// Add Bulk Static Region to Lighting Engine Layers
			var temp_successfully_added_bulk_static_region_layer = lighting_engine_add_object(id, LightingEngineObjectType.BulkStatic_Region, temp_bulk_static_layers_map_key);
			
			// Debug Flag - Unsuccessfully added Bulk Static Group to Lighting Engine Sub Layer
			if (!temp_successfully_added_bulk_static_region_layer)
			{
				show_debug_message($"Debug Warning! - Unsuccessfully added Bulk Static Region to Lighting Engine Sub Layer with name \"{temp_bulk_static_layers_map_key}\"");
			}
		}
	}
	
	// Delete DS Map Layers List
	ds_map_destroy(temp_bulk_static_layers_map);
	temp_bulk_static_layers_map = -1;
}
