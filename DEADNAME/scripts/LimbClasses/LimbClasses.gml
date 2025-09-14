// Limb Animation Settings
global.limb_walk_animation_percent_offset = 0.18;

// Limb Held Item Settings
global.limb_held_item_angle_spread = 90;

// Limb Type Enums
enum LimbType
{
	LeftArm,
	RightArm
}

// Limb Classes
class LimbClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		
	}
	
	static _destructor = function() 
	{
		
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		
	}
}

class LimbArmClass extends LimbClass define
{
	// Init & Destroy Methods
	static _constructor = function() 
	{
		// Limb Unit
		limb_unit = noone;
		
		// Limb Variables
		limb_xscale = 1;  // Facing Direction of Limb's Actor
		
		limb_pivot_ax = 0;  // X coordinate of Shoulder Pivot
		limb_pivot_ay = 0;  // Y coordinate of Shoulder Pivot
		
		limb_pivot_a_angle = 0; // Angle of Shoulder Pivot
		
		limb_pivot_bx = 0;  // X coordinate of Elbow Pivot
		limb_pivot_by = 0;  // Y coordinate of Elbow Pivot
		
		limb_pivot_b_angle = 0;  // Angle of Elbow Pivot
		
		// Held Item Variables
		limb_held_item_exists = false;
		
		limb_held_item_pack_list = ds_list_create();
		
		limb_held_item_sprite_index_list = ds_list_create();
		limb_held_item_image_index_list = ds_list_create();
		limb_held_item_image_angle_list = ds_list_create();
		
		limb_held_item_normal_strength_list = ds_list_create();
		limb_held_item_metallic_list = ds_list_create();
		limb_held_item_roughness_list = ds_list_create();
		limb_held_item_emissive_list = ds_list_create();
		
		limb_held_item_normalmap_spritepack_list = ds_list_create();
		limb_held_item_metallicroughnessmap_spritepack_list = ds_list_create();
		limb_held_item_emissivemap_spritepack_list = ds_list_create();
		
		limb_held_item_x = 0;  // X coordinate of Temporary Hand Pivot
		limb_held_item_y = 0;  // Y coordinate of Temporary Hand Pivot
		
		// Trig Variables
		trig_sine = 0;
		trig_cosine = 1;
		
		anchor_trig_sine = 0;
		anchor_trig_cosine = 1;
		
		// Constructor
		super._constructor();
	}
	
	static _destructor = function() 
	{
		// Cleanup All Limb DS Lists
		ds_list_destroy(limb_held_item_pack_list);
		limb_held_item_pack_list = -1;
		
		ds_list_destroy(limb_held_item_sprite_index_list);
		limb_held_item_sprite_index_list = -1;
		ds_list_destroy(limb_held_item_image_index_list);
		limb_held_item_image_index_list = -1;
		ds_list_destroy(limb_held_item_image_angle_list);
		limb_held_item_image_angle_list = -1;
		
		ds_list_destroy(limb_held_item_normal_strength_list);
		limb_held_item_normal_strength_list = -1;
		ds_list_destroy(limb_held_item_metallic_list);
		limb_held_item_metallic_list = -1;
		ds_list_destroy(limb_held_item_roughness_list);
		limb_held_item_roughness_list = -1;
		ds_list_destroy(limb_held_item_emissive_list);
		limb_held_item_emissive_list = -1;
		
		ds_list_destroy(limb_held_item_normalmap_spritepack_list);
		limb_held_item_normalmap_spritepack_list = -1;
		ds_list_destroy(limb_held_item_metallicroughnessmap_spritepack_list);
		limb_held_item_metallicroughnessmap_spritepack_list = -1;
		ds_list_destroy(limb_held_item_emissivemap_spritepack_list);
		limb_held_item_emissivemap_spritepack_list = -1;
		
		// Destructor
		super._destructor();
	}
	
	// Limb Properties Methods
	static init_arm = function(init_unit, init_limb_type, init_unit_pack) 
	{
		// Set Limb Unit
		limb_unit = init_unit;
		
		// Set Limb Type
		limb_type = init_limb_type;
		
		switch (init_limb_type)
		{
			case LimbType.LeftArm:
				// Create Properties for Left Arm Limb
				limb_animation_value_offset = 0;
				
				anchor_offset_x = global.unit_packs[init_unit_pack].limb_anchor_left_arm_x;
				anchor_offset_y = global.unit_packs[init_unit_pack].limb_anchor_left_arm_y;
				
				limb_sprite = global.unit_packs[init_unit_pack].ragdoll_arm_left_sprite;
				limb_normalmap = global.unit_packs[init_unit_pack].ragdoll_arm_left_normalmap;
				limb_metallicroughnessmap = global.unit_packs[init_unit_pack].ragdoll_arm_left_metallicroughnessmap;
				limb_emissivemap = global.unit_packs[init_unit_pack].ragdoll_arm_left_emissivemap;
				
				limb_anchor_idle_animation_angle = global.unit_packs[init_unit_pack].limb_left_arm_idle_animation_angle;
				limb_anchor_walk_animation_angle = global.unit_packs[init_unit_pack].limb_left_arm_walk_animation_angle;
				limb_anchor_jump_animation_angle = global.unit_packs[init_unit_pack].limb_left_arm_jump_animation_angle;
				
				limb_walk_animation_ambient_move_width = global.unit_packs[init_unit_pack].limb_left_arm_walk_animation_ambient_move_width;
				limb_walk_animation_ambient_move_height = global.unit_packs[init_unit_pack].limb_left_arm_walk_animation_ambient_move_height;
				break;
			case LimbType.RightArm:
				// Create Properties for Right Arm Limb
				limb_animation_value_offset = 0.5;
				
				anchor_offset_x = global.unit_packs[init_unit_pack].limb_anchor_right_arm_x;
				anchor_offset_y = global.unit_packs[init_unit_pack].limb_anchor_right_arm_y;
				
				limb_sprite = global.unit_packs[init_unit_pack].ragdoll_arm_right_sprite;
				limb_normalmap = global.unit_packs[init_unit_pack].ragdoll_arm_right_normalmap;
				limb_metallicroughnessmap = global.unit_packs[init_unit_pack].ragdoll_arm_right_metallicroughnessmap;
				limb_emissivemap = global.unit_packs[init_unit_pack].ragdoll_arm_right_emissivemap;
				
				limb_anchor_idle_animation_angle = global.unit_packs[init_unit_pack].limb_right_arm_idle_animation_angle;
				limb_anchor_walk_animation_angle = global.unit_packs[init_unit_pack].limb_right_arm_walk_animation_angle;
				limb_anchor_jump_animation_angle = global.unit_packs[init_unit_pack].limb_right_arm_jump_animation_angle;
				
				limb_walk_animation_ambient_move_width = global.unit_packs[init_unit_pack].limb_right_arm_walk_animation_ambient_move_width;
				limb_walk_animation_ambient_move_height = global.unit_packs[init_unit_pack].limb_right_arm_walk_animation_ambient_move_height;
				break;
		}
		
		// Set "Rocking Back and Forth" Idle Ambient Animation Movement Properties
		limb_idle_animation_ambient_move_width = global.unit_packs[init_unit_pack].limb_idle_animation_ambient_move_width;
		
		// Set Ambient Animation Limb Extension During Movement Properties
		limb_length = sprite_get_height(limb_sprite) * 2;
		
		var limb_idle_animation_extension_percent = global.unit_packs[init_unit_pack].limb_idle_animation_extension_percent;
		limb_idle_animation_offset_x = rot_dist_x(limb_length * limb_idle_animation_extension_percent, limb_anchor_idle_animation_angle + 270);
		limb_idle_animation_offset_y = rot_dist_y(limb_length * limb_idle_animation_extension_percent);
		
		var limb_walk_animation_extension_percent = init_limb_type == LimbType.LeftArm ? global.unit_packs[init_unit_pack].limb_left_arm_walk_animation_extension_percent : global.unit_packs[init_unit_pack].limb_right_arm_walk_animation_extension_percent;
		limb_walk_animation_offset_x = rot_dist_x(limb_length * limb_walk_animation_extension_percent, limb_anchor_walk_animation_angle + 270);
		limb_walk_animation_offset_y = rot_dist_y(limb_length * limb_walk_animation_extension_percent);
		
		var limb_jump_animation_extension_percent = global.unit_packs[init_unit_pack].limb_jump_animation_extension_percent;
		limb_jump_animation_offset_x = rot_dist_x(limb_length * limb_jump_animation_extension_percent, limb_anchor_jump_animation_angle + 270);
		limb_jump_animation_offset_y = rot_dist_y(limb_length * limb_jump_animation_extension_percent);
		
		// Set Limb PBR Settings
		limb_normal_strength = global.unit_packs[init_unit_pack].normal_strength;
		limb_metallic = global.unit_packs[init_unit_pack].metallic;
		limb_roughness = global.unit_packs[init_unit_pack].roughness;
		limb_emissive = global.unit_packs[init_unit_pack].emissive;
		limb_emissive_multiplier = 1;
		
		// Set Limb Sprite Packs
		limb_normalmap_spritepack = limb_normalmap == noone ? undefined : spritepack_get_uvs_transformed(limb_sprite, limb_normalmap);
		limb_metallicroughnessmap_spritepack = limb_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(limb_sprite, limb_metallicroughnessmap);
		limb_emissivemap_spritepack = limb_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(limb_sprite, limb_emissivemap);
	}
	
	// Update Methods
	static update_pivot = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale, anchor_angle)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = anchor_offset_y * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y, anchor_angle);
		limb_pivot_ay = anchor_y + rot_point_y(temp_anchor_offset_x, temp_anchor_offset_y);
	}
	
	static update_target = function(target_x, target_y)
	{
		// Update Target
		limb_target_x = target_x;
		limb_target_y = target_y;
		
		// Calculate Movement
		calculate_limb_movement();
	}
	
	static update_idle_animation = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale, animation_percentage)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Idle Animation
		var limb_animation_value = (animation_percentage + limb_animation_value_offset) mod 1;
		var temp_idle_animation_offset_x = rot_dist_x(limb_idle_animation_ambient_move_width * limb_xscale, 360 - (limb_animation_value * 360));
		
		// Update Trig Values
		trig_sine = anchor_trig_sine;
		trig_cosine = anchor_trig_cosine;
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = (anchor_offset_y - (animation_percentage < 0.5)) * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y);
		limb_pivot_ay = anchor_y + rot_point_y(temp_anchor_offset_x, temp_anchor_offset_y);
		
		// Update Target
		var temp_target_offset_x = temp_anchor_offset_x + temp_idle_animation_offset_x + (limb_idle_animation_offset_x * limb_xscale);
		var temp_target_offset_y = temp_anchor_offset_y + (limb_idle_animation_offset_y * anchor_yscale);
		
		limb_target_x = anchor_x + rot_point_x(temp_target_offset_x, temp_target_offset_y);
		limb_target_y = anchor_y + rot_point_y(temp_target_offset_x, temp_target_offset_y);
		
		// Calculate Movement
		calculate_limb_movement();
	}
	
	static update_walk_animation = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale, animation_percentage, walk_animation_percentage)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Walk Animation
		var limb_animation_value = (walk_animation_percentage + global.limb_walk_animation_percent_offset + limb_animation_value_offset) mod 1;
		
		rot_prefetch(360 - (limb_animation_value * 360));
		var temp_idle_animation_offset_x = rot_dist_x(limb_walk_animation_ambient_move_width * limb_xscale);
		var temp_idle_animation_offset_y = rot_dist_y(limb_walk_animation_ambient_move_height);
		
		// Update Trig Values
		trig_sine = anchor_trig_sine;
		trig_cosine = anchor_trig_cosine;
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = (anchor_offset_y - (animation_percentage > 0.5)) * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y);
		limb_pivot_ay = anchor_y + rot_point_y(temp_anchor_offset_x, temp_anchor_offset_y);
		
		// Update Target
		var temp_target_offset_x = temp_anchor_offset_x + temp_idle_animation_offset_x + (limb_walk_animation_offset_x * limb_xscale);
		var temp_target_offset_y = temp_anchor_offset_y + temp_idle_animation_offset_y + (limb_walk_animation_offset_y * anchor_yscale);
		
		limb_target_x = anchor_x + rot_point_x(temp_target_offset_x, temp_target_offset_y);
		limb_target_y = anchor_y + rot_point_y(temp_target_offset_x, temp_target_offset_y);
		
		// Calculate Movement
		calculate_limb_movement();
	}
	
	static update_jump_animation = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Trig Values
		trig_sine = anchor_trig_sine;
		trig_cosine = anchor_trig_cosine;
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = anchor_offset_y * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y);
		limb_pivot_ay = anchor_y + rot_point_y(temp_anchor_offset_x, temp_anchor_offset_y);
		
		// Update Target
		var temp_target_offset_x = temp_anchor_offset_x + (limb_jump_animation_offset_x * anchor_xscale);
		var temp_target_offset_y = temp_anchor_offset_y + (limb_jump_animation_offset_y * anchor_yscale);
		
		limb_target_x = anchor_x + rot_point_x(temp_target_offset_x, temp_target_offset_y);
		limb_target_y = anchor_y + rot_point_y(temp_target_offset_x, temp_target_offset_y);
		
		// Calculate Movement
		calculate_limb_movement();
	}
	
	static calculate_limb_movement = function()
	{
		// Limb Direction, Distance, & Extension Percent
		var temp_limb_direction = point_direction(limb_pivot_ax, limb_pivot_ay, limb_target_x, limb_target_y);
		var temp_limb_distance = point_distance(limb_pivot_ax, limb_pivot_ay, limb_target_x, limb_target_y);
		var temp_limb_extension_percent = 1 - (clamp(temp_limb_distance, 0, limb_length) / limb_length);
		
		limb_pivot_a_angle = temp_limb_direction + (-90 * temp_limb_extension_percent * limb_xscale);
		
		rot_prefetch(limb_pivot_a_angle);
		limb_pivot_bx = limb_pivot_ax + rot_dist_x(limb_length / 2);
		limb_pivot_by = limb_pivot_ay + rot_dist_y(limb_length / 2);
		
		limb_pivot_b_angle = temp_limb_direction + (90 * temp_limb_extension_percent * limb_xscale);
		
		// Held Item Position
		if (limb_held_item_exists)
		{
			rot_prefetch(limb_pivot_b_angle);
			limb_held_item_x = limb_pivot_bx + rot_dist_x((limb_length / 2) - 2);
			limb_held_item_y = limb_pivot_by + rot_dist_y((limb_length / 2) - 2);
		}
	}
	
	// Item Methods
	static add_held_item = function(item_pack, item_image_index = 0)
	{
		// Check if Item Pack exists and is Valid
		if (item_pack == ItemPack.None or item_pack < 0)
		{
			return;
		}
		
		// Establish Held Item Data Render Textures
		var temp_held_item_diffusemap = global.item_packs[item_pack].held_item_data.render_sprite;
		var temp_held_item_normalmap = global.item_packs[item_pack].held_item_data.render_normalmap;
		var temp_held_item_metallicroughnessmap = global.item_packs[item_pack].held_item_data.render_metallicroughnessmap;
		var temp_held_item_emissivemap = global.item_packs[item_pack].held_item_data.render_emissivemap;
		
		// Add Held Item to Held Item DS Lists
		ds_list_add(limb_held_item_pack_list, item_pack);
		
		ds_list_add(limb_held_item_sprite_index_list, temp_held_item_diffusemap);
		ds_list_add(limb_held_item_image_index_list, item_image_index);
		ds_list_add(limb_held_item_image_angle_list, 0);
		
		ds_list_add(limb_held_item_normal_strength_list, global.item_packs[item_pack].held_item_data.normal_strength);
		ds_list_add(limb_held_item_metallic_list, global.item_packs[item_pack].held_item_data.metallic);
		ds_list_add(limb_held_item_roughness_list, global.item_packs[item_pack].held_item_data.roughness);
		ds_list_add(limb_held_item_emissive_list, global.item_packs[item_pack].held_item_data.emissive);
		
		ds_list_add(limb_held_item_normalmap_spritepack_list, temp_held_item_normalmap == noone ? undefined : spritepack_get_uvs_transformed(temp_held_item_diffusemap, temp_held_item_normalmap));
		ds_list_add(limb_held_item_metallicroughnessmap_spritepack_list, temp_held_item_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(temp_held_item_diffusemap, temp_held_item_metallicroughnessmap));
		ds_list_add(limb_held_item_emissivemap_spritepack_list, temp_held_item_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(temp_held_item_diffusemap, temp_held_item_emissivemap));
		
		// Realign Limb's Held Items Angles
		for (var i = 0; i < ds_list_size(limb_held_item_pack_list); i++)
		{
			// Set each Limb Held Item to spread their angles across the range of the Limb's Hand
			ds_list_set(limb_held_item_image_angle_list, i, ds_list_size(limb_held_item_pack_list) > 1 ? (i * (global.limb_held_item_angle_spread / ds_list_size(limb_held_item_pack_list))) : 0);
		}
		
		// Toggle Held Item Exists
		limb_held_item_exists = true;
	}
	
	static drop_held_item = function(item_pack = -1)
	{
		// Check if Item Pack is Valid
		if (item_pack == ItemPack.None)
		{
			return;
		}
		
		// Establish Random Drop Held Item Index
		var temp_drop_held_item_index = irandom(ds_list_size(limb_held_item_pack_list) - 1);
		
		// Find the Drop Held Item's Index if given a valid Item Pack to remove
		if (item_pack != -1)
		{
			// Establish Found Matching Item Pack Boolean
			var temp_found_matching_item_pack = false;
			
			// Iterate through Limb's Held Items
			for (var i = 0; i < ds_list_size(limb_held_item_pack_list); i++)
			{
				// Compare if Limb's Held Item's Item Pack matches the given Item Pack to remove
				if (ds_list_find_value(limb_held_item_pack_list, i) == item_pack)
				{
					// Item Pack matches - Set to remove Held Item at this Held Item Index
					temp_drop_held_item_index = i;
					temp_found_matching_item_pack = true;
					
					// Break from Held Item Search Loop
					break;
				}
			}
			
			// Check if Limb contains a Held Item with the given Item Pack
			if (!temp_found_matching_item_pack)
			{
				return;
			}
		}
		
		// Find the Limb Held Item's Item Pack
		var temp_drop_item_pack = ds_list_find_value(limb_held_item_pack_list, temp_drop_held_item_index);
		
		// Create Dropped Item Instance
		if (global.item_packs[temp_drop_item_pack].held_item_data.held_item_object != noone)
		{
			// Find Dropped Item Sub-Layer Index
			var temp_drop_item_sub_layer_index = instance_exists(limb_unit) ? lighting_engine_find_object_index(limb_unit) + 1 : -1;
			
			// Create Dropped Item Instance Struct
			var temp_drop_item_object_var_struct = 
			{ 
				image_angle: 0, 
				sub_layer_index: temp_drop_item_sub_layer_index
			};
			
			// Instantiate Dropped Item Instance
			var temp_drop_item_instance = instance_create_depth(limb_held_item_x, limb_held_item_y, 0, global.item_packs[temp_drop_item_pack].held_item_data.held_item_object, temp_drop_item_object_var_struct);
			
			// Establish Physics Forces
			var temp_drop_item_horizontal_force = random_range(-1, 3) * (instance_exists(limb_unit) ? limb_unit.draw_xscale : limb_xscale);
			var temp_drop_item_vertical_force = random_range(-2, -3);
			
			// Apply Physics Forces to Dropped Item Instance
			with (temp_drop_item_instance)
			{
				physics_apply_impulse(x, y, temp_drop_item_horizontal_force, temp_drop_item_vertical_force);
				physics_apply_angular_impulse(random_range(-1, 1));
			}
		}
		
		// Remove Dropped Item from Held Item DS Lists
		remove_held_item(temp_drop_held_item_index);
	}
	
	static drop_all_held_items = function()
	{
		// Find Dropped Item Sub-Layer Index
		var temp_drop_item_sub_layer_index = instance_exists(limb_unit) ? lighting_engine_find_object_index(limb_unit) + 1 : -1;
		
		// Iterate through all of the Limb's Held Items to drop each Held Item
		for (var i = 0; i < ds_list_size(limb_held_item_pack_list); i++)
		{
			// Find the Limb Held Item's Item Pack
			var temp_drop_item_pack = ds_list_find_value(limb_held_item_pack_list, i);
			
			// Create Dropped Item Instance
			if (global.item_packs[temp_drop_item_pack].held_item_data.held_item_object != noone)
			{
				// Create Dropped Item Instance Struct
				var temp_drop_item_object_var_struct = 
				{ 
					image_angle: 0, 
					sub_layer_index: temp_drop_item_sub_layer_index
				};
				
				// Instantiate Dropped Item Instance
				var temp_drop_item_instance = instance_create_depth(limb_held_item_x, limb_held_item_y, 0, global.item_packs[temp_drop_item_pack].held_item_data.held_item_object, temp_drop_item_object_var_struct);
				
				// Establish Physics Forces
				var temp_drop_item_horizontal_force = random_range(-1, 3) * (instance_exists(limb_unit) ? limb_unit.draw_xscale : limb_xscale);
				var temp_drop_item_vertical_force = random_range(-2, -1);
				
				// Apply Physics Forces to Dropped Item Instance
				with (temp_drop_item_instance)
				{
					physics_apply_impulse(x, y, temp_drop_item_horizontal_force, temp_drop_item_vertical_force);
					physics_apply_angular_impulse(random_range(-1, 1));
				}
			}
		}
		
		// Clear all Held Item DS Lists
		remove_all_held_items();
	}
	
	static remove_held_item = function(held_item_index = -1)
	{
		// Establish Remove Held Item Index
		var temp_remove_held_item_index = held_item_index;
		
		// Check if Held Item Index exists in the valid Held Item DS List Index Range
		if (held_item_index == -1)
		{
			temp_remove_held_item_index = irandom(ds_list_size(limb_held_item_pack_list) - 1);
		}
		else if (held_item_index < 0 or held_item_index >= ds_list_size(limb_held_item_pack_list))
		{
			return;
		}
		
		// Remove Held Item from Held Item DS List
		ds_list_delete(limb_held_item_pack_list, temp_remove_held_item_index);
		
		ds_list_delete(limb_held_item_sprite_index_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_image_index_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_image_angle_list, temp_remove_held_item_index);
		
		ds_list_delete(limb_held_item_normal_strength_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_metallic_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_roughness_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_emissive_list, temp_remove_held_item_index);
		
		ds_list_delete(limb_held_item_normalmap_spritepack_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_metallicroughnessmap_spritepack_list, temp_remove_held_item_index);
		ds_list_delete(limb_held_item_emissivemap_spritepack_list, temp_remove_held_item_index);
		
		// Realign Limb's Held Items Angles
		for (var i = 0; i < ds_list_size(limb_held_item_pack_list); i++)
		{
			// Set each Limb Held Item to spread their angles across the range of the Limb's Hand
			ds_list_set(limb_held_item_image_angle_list, i, ds_list_size(limb_held_item_pack_list) > 1 ? (i * (global.limb_held_item_angle_spread / ds_list_size(limb_held_item_pack_list))) : 0);
		}
		
		// Toggle Held Item Exists
		limb_held_item_exists = ds_list_size(limb_held_item_pack_list) > 0;
	}
	
	static remove_all_held_items = function()
	{
		// Clear all Held Item DS Lists
		ds_list_clear(limb_held_item_pack_list);
		
		ds_list_clear(limb_held_item_sprite_index_list);
		ds_list_clear(limb_held_item_image_index_list);
		ds_list_clear(limb_held_item_image_angle_list);
		
		ds_list_clear(limb_held_item_normal_strength_list);
		ds_list_clear(limb_held_item_metallic_list);
		ds_list_clear(limb_held_item_roughness_list);
		ds_list_clear(limb_held_item_emissive_list);
		
		ds_list_clear(limb_held_item_normalmap_spritepack_list);
		ds_list_clear(limb_held_item_metallicroughnessmap_spritepack_list);
		ds_list_clear(limb_held_item_emissivemap_spritepack_list);
		
		// Toggle Held Item does not exist
		limb_held_item_exists = false;
	}
	
	// Render Methods
	static render_behaviour = function()
	{
		// Draw Arm
		if (!limb_held_item_exists)
		{
			lighting_engine_render_sprite_ext
			(
				limb_sprite, 
				0, 
				limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[0].texture : undefined,
				limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[0].texture : undefined, 
				limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[0].texture : undefined, 
				limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[0].uvs : undefined,
				limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[0].uvs : undefined,
				limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[0].uvs : undefined,
				limb_normal_strength,
				limb_metallic,
				limb_roughness,
				limb_emissive,
				limb_emissive_multiplier,
				limb_pivot_ax, 
				limb_pivot_ay, 
				limb_xscale, 
				1, 
				limb_pivot_a_angle + 90, 
				c_white, 
				1
			);
			
			lighting_engine_render_sprite_ext
			(
				limb_sprite, 
				1, 
				limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[1].texture : undefined,
				limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[1].texture : undefined, 
				limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[1].texture : undefined, 
				limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[1].uvs : undefined,
				limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[1].uvs : undefined,
				limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[1].uvs : undefined,
				limb_normal_strength,
				limb_metallic,
				limb_roughness,
				limb_emissive,
				limb_emissive_multiplier,
				limb_pivot_bx, 
				limb_pivot_by, 
				limb_xscale, 
				1, 
				limb_pivot_b_angle + 90, 
				c_white, 
				1
			);
			return;
		}
		
		// Establish Held Item Index
		var temp_held_item_index = 0;
		
		// Draw Arm with Held Item
		switch (limb_type)
		{
			case LimbType.LeftArm:
				// Draw Held Item(s)
				repeat (ds_list_size(limb_held_item_pack_list))
				{
					// Establish Held Item Render Data
					var temp_held_item_sprite_index = ds_list_find_value(limb_held_item_sprite_index_list, temp_held_item_index);
					var temp_held_item_image_index = ds_list_find_value(limb_held_item_image_index_list, temp_held_item_index);
					
					var temp_held_item_normal_strength = ds_list_find_value(limb_held_item_normal_strength_list, temp_held_item_index);
					var temp_held_item_metallic = ds_list_find_value(limb_held_item_metallic_list, temp_held_item_index);
					var temp_held_item_roughness = ds_list_find_value(limb_held_item_roughness_list, temp_held_item_index);
					var temp_held_item_emissive = ds_list_find_value(limb_held_item_emissive_list, temp_held_item_index);
					
					var temp_held_item_normalmap_spritepack = ds_list_find_value(limb_held_item_normalmap_spritepack_list, temp_held_item_index);
					var temp_held_item_metallicroughnessmap_spritepack = ds_list_find_value(limb_held_item_metallicroughnessmap_spritepack_list, temp_held_item_index);
					var temp_held_item_emissivemap_spritepack = ds_list_find_value(limb_held_item_emissivemap_spritepack_list, temp_held_item_index);
					
					var temp_held_item_image_angle = ds_list_find_value(limb_held_item_image_angle_list, temp_held_item_index);
					
					// Draw Held Item Sprite
					lighting_engine_render_sprite_ext
					(
						temp_held_item_sprite_index,
						temp_held_item_image_index,
						temp_held_item_normalmap_spritepack != undefined ? temp_held_item_normalmap_spritepack[temp_held_item_image_index].texture : undefined,
						temp_held_item_metallicroughnessmap_spritepack != undefined ? temp_held_item_metallicroughnessmap_spritepack[temp_held_item_image_index].texture : undefined,
						temp_held_item_emissivemap_spritepack != undefined ? temp_held_item_emissivemap_spritepack[temp_held_item_image_index].texture : undefined,
						temp_held_item_normalmap_spritepack != undefined ? temp_held_item_normalmap_spritepack[temp_held_item_image_index].uvs : undefined,
						temp_held_item_metallicroughnessmap_spritepack != undefined ? temp_held_item_metallicroughnessmap_spritepack[temp_held_item_image_index].uvs : undefined,
						temp_held_item_emissivemap_spritepack != undefined ? temp_held_item_emissivemap_spritepack[temp_held_item_image_index].uvs : undefined,
						temp_held_item_normal_strength,
						temp_held_item_metallic,
						temp_held_item_roughness,
						temp_held_item_emissive,
						limb_emissive_multiplier,
						limb_held_item_x, 
						limb_held_item_y,
						limb_xscale, 
						1,
						limb_pivot_b_angle + (limb_xscale < 0 ? 180 : 0) + (temp_held_item_image_angle * limb_xscale),
						c_white, 
						1
					);
					
					// Increment Held Item Index
					temp_held_item_index++;
				}
				
				// Draw Limb
				lighting_engine_render_sprite_ext
				(
					limb_sprite, 
					0, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[0].texture : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[0].texture : undefined, 
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[0].texture : undefined, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[0].uvs : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[0].uvs : undefined,
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[0].uvs : undefined,
					limb_normal_strength,
					limb_metallic,
					limb_roughness,
					limb_emissive,
					limb_emissive_multiplier,
					limb_pivot_ax, 
					limb_pivot_ay, 
					limb_xscale, 
					1, 
					limb_pivot_a_angle + 90, 
					c_white, 
					1
				);
				
				lighting_engine_render_sprite_ext
				(
					limb_sprite, 
					1, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[1].texture : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[1].texture : undefined, 
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[1].texture : undefined, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[1].uvs : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[1].uvs : undefined,
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[1].uvs : undefined,
					limb_normal_strength,
					limb_metallic,
					limb_roughness,
					limb_emissive,
					limb_emissive_multiplier,
					limb_pivot_bx, 
					limb_pivot_by, 
					limb_xscale, 
					1, 
					limb_pivot_b_angle + 90, 
					c_white, 
					1
				);
				break;
			case LimbType.RightArm:
				// Draw Limb
				lighting_engine_render_sprite_ext
				(
					limb_sprite, 
					0, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[0].texture : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[0].texture : undefined, 
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[0].texture : undefined, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[0].uvs : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[0].uvs : undefined,
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[0].uvs : undefined,
					limb_normal_strength,
					limb_metallic,
					limb_roughness,
					limb_emissive,
					limb_emissive_multiplier,
					limb_pivot_ax, 
					limb_pivot_ay, 
					limb_xscale, 
					1, 
					limb_pivot_a_angle + 90, 
					c_white, 
					1
				);
				
				lighting_engine_render_sprite_ext
				(
					limb_sprite, 
					1, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[1].texture : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[1].texture : undefined, 
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[1].texture : undefined, 
					limb_normalmap_spritepack != undefined ? limb_normalmap_spritepack[1].uvs : undefined,
					limb_metallicroughnessmap_spritepack != undefined ? limb_metallicroughnessmap_spritepack[1].uvs : undefined,
					limb_emissivemap_spritepack != undefined ? limb_emissivemap_spritepack[1].uvs : undefined,
					limb_normal_strength,
					limb_metallic,
					limb_roughness,
					limb_emissive,
					limb_emissive_multiplier,
					limb_pivot_bx, 
					limb_pivot_by, 
					limb_xscale, 
					1, 
					limb_pivot_b_angle + 90, 
					c_white, 
					1
				);
				
				// Draw Held Item(s)
				repeat (ds_list_size(limb_held_item_pack_list))
				{
					// Establish Held Item Render Data
					var temp_held_item_sprite_index = ds_list_find_value(limb_held_item_sprite_index_list, temp_held_item_index);
					var temp_held_item_image_index = ds_list_find_value(limb_held_item_image_index_list, temp_held_item_index);
					
					var temp_held_item_normal_strength = ds_list_find_value(limb_held_item_normal_strength_list, temp_held_item_index);
					var temp_held_item_metallic = ds_list_find_value(limb_held_item_metallic_list, temp_held_item_index);
					var temp_held_item_roughness = ds_list_find_value(limb_held_item_roughness_list, temp_held_item_index);
					var temp_held_item_emissive = ds_list_find_value(limb_held_item_emissive_list, temp_held_item_index);
					
					var temp_held_item_normalmap_spritepack = ds_list_find_value(limb_held_item_normalmap_spritepack_list, temp_held_item_index);
					var temp_held_item_metallicroughnessmap_spritepack = ds_list_find_value(limb_held_item_metallicroughnessmap_spritepack_list, temp_held_item_index);
					var temp_held_item_emissivemap_spritepack = ds_list_find_value(limb_held_item_emissivemap_spritepack_list, temp_held_item_index);
					
					var temp_held_item_image_angle = ds_list_find_value(limb_held_item_image_angle_list, temp_held_item_index);
					
					// Draw Held Item Sprite
					lighting_engine_render_sprite_ext
					(
						temp_held_item_sprite_index,
						temp_held_item_image_index,
						temp_held_item_normalmap_spritepack != undefined ? temp_held_item_normalmap_spritepack[temp_held_item_image_index].texture : undefined,
						temp_held_item_metallicroughnessmap_spritepack != undefined ? temp_held_item_metallicroughnessmap_spritepack[temp_held_item_image_index].texture : undefined,
						temp_held_item_emissivemap_spritepack != undefined ? temp_held_item_emissivemap_spritepack[temp_held_item_image_index].texture : undefined,
						temp_held_item_normalmap_spritepack != undefined ? temp_held_item_normalmap_spritepack[temp_held_item_image_index].uvs : undefined,
						temp_held_item_metallicroughnessmap_spritepack != undefined ? temp_held_item_metallicroughnessmap_spritepack[temp_held_item_image_index].uvs : undefined,
						temp_held_item_emissivemap_spritepack != undefined ? temp_held_item_emissivemap_spritepack[temp_held_item_image_index].uvs : undefined,
						temp_held_item_normal_strength,
						temp_held_item_metallic,
						temp_held_item_roughness,
						temp_held_item_emissive,
						limb_emissive_multiplier,
						limb_held_item_x, 
						limb_held_item_y,
						limb_xscale, 
						1,
						limb_pivot_b_angle + (limb_xscale < 0 ? 180 : 0) + (temp_held_item_image_angle * limb_xscale),
						c_white, 
						1
					);
					
					// Increment Held Item Index
					temp_held_item_index++;
				}
				break;
			default:
				break;
		}
	}
	
	static render_unlit_behaviour = function(x_offset = 0, y_offset = 0)
	{
		// Draw Arm
		if (!limb_held_item_exists)
		{
			draw_sprite_ext(limb_sprite, 0, limb_pivot_ax + x_offset, limb_pivot_ay + y_offset, limb_xscale, 1, limb_pivot_a_angle + 90, c_white, 1);
			draw_sprite_ext(limb_sprite, 1, limb_pivot_bx + x_offset, limb_pivot_by + y_offset, limb_xscale, 1, limb_pivot_b_angle + 90, c_white, 1);
			return;
		}
		
		// Establish Held Item Index
		var temp_held_item_index = 0;
		
		// Draw Arm with Held Item
		switch (limb_type)
		{
			case LimbType.LeftArm:
				// Draw Held Item(s)
				repeat (ds_list_size(limb_held_item_pack_list))
				{
					// Establish Held Item Render Data
					var temp_held_item_sprite_index = ds_list_find_value(limb_held_item_sprite_index_list, temp_held_item_index);
					var temp_held_item_image_index = ds_list_find_value(limb_held_item_image_index_list, temp_held_item_index);
					
					var temp_held_item_image_angle = ds_list_find_value(limb_held_item_image_angle_list, temp_held_item_index);
					
					// Draw Held Item Sprite
					draw_sprite_ext
					(
						temp_held_item_sprite_index,
						temp_held_item_image_index,
						limb_held_item_x + x_offset, 
						limb_held_item_y + y_offset,
						limb_xscale, 
						1,
						limb_pivot_b_angle + (limb_xscale < 0 ? 180 : 0) + (temp_held_item_image_angle * limb_xscale),
						c_white, 
						1
					);
					
					// Increment Held Item Index
					temp_held_item_index++;
				}
				
				// Draw Limb
				draw_sprite_ext(limb_sprite, 0, limb_pivot_ax + x_offset, limb_pivot_ay + y_offset, limb_xscale, 1, limb_pivot_a_angle + 90, c_white, 1);
				draw_sprite_ext(limb_sprite, 1, limb_pivot_bx + x_offset, limb_pivot_by + y_offset, limb_xscale, 1, limb_pivot_b_angle + 90, c_white, 1);
				break;
			case LimbType.RightArm:
				// Draw Limb
				draw_sprite_ext(limb_sprite, 0, limb_pivot_ax + x_offset, limb_pivot_ay + y_offset, limb_xscale, 1, limb_pivot_a_angle + 90, c_white, 1);
				draw_sprite_ext(limb_sprite, 1, limb_pivot_bx + x_offset, limb_pivot_by + y_offset, limb_xscale, 1, limb_pivot_b_angle + 90, c_white, 1);
				
				// Draw Held Item(s)
				repeat (ds_list_size(limb_held_item_pack_list))
				{
					// Establish Held Item Render Data
					var temp_held_item_sprite_index = ds_list_find_value(limb_held_item_sprite_index_list, temp_held_item_index);
					var temp_held_item_image_index = ds_list_find_value(limb_held_item_image_index_list, temp_held_item_index);
					
					var temp_held_item_image_angle = ds_list_find_value(limb_held_item_image_angle_list, temp_held_item_index);
					
					// Draw Held Item Sprite
					draw_sprite_ext
					(
						temp_held_item_sprite_index,
						temp_held_item_image_index,
						limb_held_item_x + x_offset, 
						limb_held_item_y + y_offset,
						limb_xscale, 
						1,
						limb_pivot_b_angle + (limb_xscale < 0 ? 180 : 0) + (temp_held_item_image_angle * limb_xscale),
						c_white, 
						1
					);
					
					// Increment Held Item Index
					temp_held_item_index++;
				}
				break;
			default:
				break;
		}
	}
}
