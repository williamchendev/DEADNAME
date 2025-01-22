/// @description Create Bulk Static Groups
// Performs a Collision Check with all intersecting Bulk Static Objects and organizes them into Vertex Buffers

// Index all Bulk Static Objects in Vertex Buffer
var temp_bulk_static_objects_list = ds_list_create();
var temp_bulk_static_objects_count = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oLightingEngine_BulkStatic_Object, false, true, temp_bulk_static_objects_list, true);

if (temp_bulk_static_objects_count > 0)
{
	// Begin Initialize Vertex Buffer
	vertex_begin(bulk_static_group_vertex_buffer, oLightingEngine.lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format);
	
	// Iterate through all colliding Bulk Static Objects
	for (var i = ds_list_size(temp_bulk_static_objects_list) - 1; i >= 0; i--)
	{
		// Find Bulk Static Object at Index
		var temp_bulk_static_object = ds_list_find_value(temp_bulk_static_objects_list, i);
		
		// Check if Bulk Static Object shares Bulk Static Group's Layer
		if (temp_bulk_static_object.layer == layer)
		{
			// Get Bulk Static Object Sprite Variables
			var temp_sprite_width = sprite_get_width(temp_bulk_static_object.sprite_index);
			var temp_sprite_height = sprite_get_height(temp_bulk_static_object.sprite_index);
						
			var temp_pivot_offset_x = sprite_get_xoffset(temp_bulk_static_object.sprite_index);
			var temp_pivot_offset_y = sprite_get_yoffset(temp_bulk_static_object.sprite_index);
						
			var temp_sprite_left = -temp_pivot_offset_x * temp_bulk_static_object.image_xscale;
			var temp_sprite_top = -temp_pivot_offset_y * temp_bulk_static_object.image_yscale;
			var temp_sprite_right = (temp_sprite_width - temp_pivot_offset_x) * temp_bulk_static_object.image_xscale;
			var temp_sprite_bottom = (temp_sprite_height - temp_pivot_offset_y) * temp_bulk_static_object.image_yscale;
						
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
			
			// Establish UV Data for Bulk Static Object
			var temp_diffusemap_uvs = sprite_get_uvs(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index);
			var temp_normalmap_uvs = sprite_get_uvs(temp_bulk_static_object.normalmap_texture, temp_bulk_static_object.image_index);
			var temp_specularmap_uvs = sprite_get_uvs(temp_bulk_static_object.specularmap_texture, temp_bulk_static_object.image_index);
			
			// Add Bulk Static Object to Vertex Buffer
			vertex_position_3d(bulk_static_group_vertex_buffer, temp_vertex_coordinate_ax, temp_vertex_coordinate_ay, temp_bulk_static_object.image_angle);
			vertex_normal(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.image_zscale);
			vertex_color(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[1]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[1]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[1]);
			
			vertex_position_3d(bulk_static_group_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_bulk_static_object.image_angle);
			vertex_normal(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.image_zscale);
			vertex_color(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_normalmap_uvs[2], temp_normalmap_uvs[1]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_specularmap_uvs[2], temp_specularmap_uvs[1]);
			
			vertex_position_3d(bulk_static_group_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_bulk_static_object.image_angle);
			vertex_normal(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.image_zscale);
			vertex_color(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[3]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[3]);
			
			vertex_position_3d(bulk_static_group_vertex_buffer, temp_vertex_coordinate_cx, temp_vertex_coordinate_cy, temp_bulk_static_object.image_angle);
			vertex_normal(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.image_zscale);
			vertex_color(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[3]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_normalmap_uvs[2], temp_normalmap_uvs[3]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_specularmap_uvs[2], temp_specularmap_uvs[3]);
			
			vertex_position_3d(bulk_static_group_vertex_buffer, temp_vertex_coordinate_dx, temp_vertex_coordinate_dy, temp_bulk_static_object.image_angle);
			vertex_normal(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.image_zscale);
			vertex_color(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_diffusemap_uvs[0], temp_diffusemap_uvs[3]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_normalmap_uvs[0], temp_normalmap_uvs[3]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_specularmap_uvs[0], temp_specularmap_uvs[3]);
			
			vertex_position_3d(bulk_static_group_vertex_buffer, temp_vertex_coordinate_bx, temp_vertex_coordinate_by, temp_bulk_static_object.image_angle);
			vertex_normal(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_xscale, temp_bulk_static_object.image_yscale, temp_bulk_static_object.image_zscale);
			vertex_color(bulk_static_group_vertex_buffer, temp_bulk_static_object.image_blend, temp_bulk_static_object.image_alpha);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_diffusemap_uvs[2], temp_diffusemap_uvs[1]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_normalmap_uvs[2], temp_normalmap_uvs[1]);
			vertex_texcoord(bulk_static_group_vertex_buffer, temp_specularmap_uvs[2], temp_specularmap_uvs[1]);
			
			// Set Bulk Static Group Texture
			bulk_static_group_texture = sprite_get_texture(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index);
			
			// Destroy Bulk Static Object
			instance_destroy(temp_bulk_static_object.id);
		}
	}
	
	// Finish Initializing Vertex Buffer
	vertex_end(bulk_static_group_vertex_buffer);
	vertex_freeze(bulk_static_group_vertex_buffer);
	
	// Add Object to Lighting Engine Sub Layer
	var temp_layer_name = layer_get_name(layer);
	var temp_successfully_added_bulk_static_group = LightingEngine.add_object(id, LightingEngineObjectType.BulkStatic_Group, temp_layer_name);
	
	// Debug Flag - Unsuccessfully added Bulk Static Group to Lighting Engine Sub Layer
	if (!temp_successfully_added_bulk_static_group)
	{
		show_debug_message($"Debug Warning! - Unsuccessfully added Bulk Static Group to Lighting Engine Sub Layer with name \"{temp_layer_name}\"");
	}
}
else
{
	vertex_delete_buffer(bulk_static_group_vertex_buffer);
	bulk_static_group_vertex_buffer = -1;
}
