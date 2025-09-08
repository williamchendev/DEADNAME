/// @function add_dynamic_object_to_bulk_sprite_vertex_buffer(dynamic_object);
/// @description Adds a Dynamic Object's rendering data to a Bulk Dynamic Layer's Rendering DS Lists so it can compile it in the Vertex Buffer it creates every frame it is active
/// @param {Id.Instance<oLighting_Dynamic_Object>} dynamic_object - A Dynamic Object to add to the Bulk Dynamic Layer's Rendering DS Lists (This is to save on expensive vertex batch breaks when rendering large amounts of bulk dynamic assets in a scene)
/// @param {?string} sub_layer_name - The Sub-Layer Name of the Bulk Dynamic Layer to add the Dynamic Object's render data to
function add_dynamic_object_to_bulk_sprite_vertex_buffer(dynamic_object, sub_layer_name = undefined)
{
	// Establish Bulk Dynamic Layer Object
	var temp_bulk_dynamic_layer_object = noone;
	
	// Find Bulk Dynamic Layer from Sub-Layer
	if (is_undefined(sub_layer_name))
	{
		// No comparison of Bulk Dynamic Layer's Sub-Layer Name - Pick first existing Bulk Dynamic Layer Instance
		temp_bulk_dynamic_layer_object = instance_find(oLighting_Layers_BulkDynamic, 0);
	}
	else
	{
		// Iterate through all Bulk Dynamic Layer Objects to compare matching Sub-Layer
		for (var i = 0; i < instance_number(oLighting_Layers_BulkDynamic); ++i;)
		{
			// Find Bulk Dynamic Object Instance to compare
		    var temp_bulk_dynamic_layer_object_compare = instance_find(oLighting_Layers_BulkDynamic, i);
		    
		    // Check for matching Sub-Layer
		    if (temp_bulk_dynamic_layer_object_compare.sub_layer_name == sub_layer_name)
		    {
		    	temp_bulk_dynamic_layer_object = temp_bulk_dynamic_layer_object_compare;
		    	break;
		    }
		}
	}
	
	// Check if Bulk Dynamic Layer Object Exists
	if (!instance_exists(temp_bulk_dynamic_layer_object))
	{
		return;
	}
	
	// Get Bulk Dynamic Layer Object Sprite Variables
	var temp_diffusemap_uvs = sprite_get_uvs(dynamic_object.sprite_index, dynamic_object.image_index);
	
	var temp_sprite_width = sprite_get_width(dynamic_object.sprite_index) * temp_diffusemap_uvs[6];
	var temp_sprite_height = sprite_get_height(dynamic_object.sprite_index) * temp_diffusemap_uvs[7];
				
	var temp_pivot_offset_x = sprite_get_xoffset(dynamic_object.sprite_index) - temp_diffusemap_uvs[4];
	var temp_pivot_offset_y = sprite_get_yoffset(dynamic_object.sprite_index) - temp_diffusemap_uvs[5];
	
	var temp_sprite_left = -temp_pivot_offset_x * dynamic_object.image_xscale;
	var temp_sprite_top = -temp_pivot_offset_y * dynamic_object.image_yscale;
	var temp_sprite_right = (temp_sprite_width - temp_pivot_offset_x) * dynamic_object.image_xscale;
	var temp_sprite_bottom = (temp_sprite_height - temp_pivot_offset_y) * dynamic_object.image_yscale;
	
	// Establish Shader Effect Toggles for Bulk Dynamic Layer Object
	var temp_shader_map_toggles_normal_enabled = dynamic_object.normal_map != noone;
	var temp_shader_map_toggles_metallicroughness_enabled = dynamic_object.metallicroughness_map != noone;
	var temp_shader_map_toggles_emissive_enabled = dynamic_object.emissive_map != noone;
	
	// Establish Base Strength & Shader Effect Toggles
	var temp_metallic = dynamic_object.metallic ? 1 : 0;
	var temp_roughness = max(dynamic_object.roughness, 0.01);
	var temp_emissive = dynamic_object.emissive;
	var temp_emissive_multiplier = dynamic_object.emissive_multiplier;
	
	// Establish UV Data for Bulk Dynamic Layer Object
	var temp_normalmap_uvs = temp_shader_map_toggles_normal_enabled ? sprite_get_uvs_transformed(dynamic_object.sprite_index, dynamic_object.image_index, dynamic_object.normal_map, dynamic_object.image_index) : [ -1, -1, -1, -1 ];
	var temp_metallicroughnessmap_uvs = temp_shader_map_toggles_metallicroughness_enabled ? sprite_get_uvs_transformed(dynamic_object.sprite_index, dynamic_object.image_index, dynamic_object.metallicroughness_map, dynamic_object.image_index) : [ -1, -1, -1, -1 ];
	var temp_emissivemap_uvs = temp_shader_map_toggles_emissive_enabled ? sprite_get_uvs_transformed(dynamic_object.sprite_index, dynamic_object.image_index, dynamic_object.emissive_map, dynamic_object.image_index) : [ -1, -1, -1, -1 ];
	
	// Set Bulk Dynamic Layer Object Rotation
	rot_prefetch(dynamic_object.image_angle);
	
	// Establish Vertex Coordinate Data for Bulk Dynamic Layer Object
	var temp_vertex_coordinate_ax = dynamic_object.x + rot_point_x(temp_sprite_left, temp_sprite_top);
	var temp_vertex_coordinate_ay = dynamic_object.y + rot_point_y(temp_sprite_left, temp_sprite_top);
	
	var temp_vertex_coordinate_bx = dynamic_object.x + rot_point_x(temp_sprite_right, temp_sprite_top);
	var temp_vertex_coordinate_by = dynamic_object.y + rot_point_y(temp_sprite_right, temp_sprite_top);
	
	var temp_vertex_coordinate_cx = dynamic_object.x + rot_point_x(temp_sprite_right, temp_sprite_bottom);
	var temp_vertex_coordinate_cy = dynamic_object.y + rot_point_y(temp_sprite_right, temp_sprite_bottom);
	
	var temp_vertex_coordinate_dx = dynamic_object.x + rot_point_x(temp_sprite_left, temp_sprite_bottom);
	var temp_vertex_coordinate_dy = dynamic_object.y + rot_point_y(temp_sprite_left, temp_sprite_bottom);
	
	// Add Dynamic Object's Render Data to Bulk Dynamic Layer's Render DS Lists
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_ax_list, temp_vertex_coordinate_ax);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_ay_list, temp_vertex_coordinate_ay);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_bx_list, temp_vertex_coordinate_bx);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_by_list, temp_vertex_coordinate_by);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_cx_list, temp_vertex_coordinate_cx);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_cy_list, temp_vertex_coordinate_cy);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_dx_list, temp_vertex_coordinate_dx);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_vertex_coordinate_dy_list, temp_vertex_coordinate_dy);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_image_angle_list, dynamic_object.image_angle);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_image_xscale_list, dynamic_object.image_xscale);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_image_yscale_list, dynamic_object.image_yscale);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_normal_strength_list, dynamic_object.normal_strength);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_image_blend_list, dynamic_object.image_blend);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_image_alpha_list, dynamic_object.image_alpha);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_diffusemap_uvs_list, temp_diffusemap_uvs);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_normalmap_uvs_list, temp_normalmap_uvs);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_metallicroughnessmap_uvs_list, temp_metallicroughnessmap_uvs);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_emissivemap_uvs_list, temp_emissivemap_uvs);
	
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_metallic_list, temp_metallic);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_roughness_list, temp_roughness);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_emissive_list, temp_emissive);
	ds_list_add(temp_bulk_dynamic_layer_object.bulk_dynamic_layer_emissive_multiplier_list, temp_emissive_multiplier);
}
