/// @description Unit Player Input Event
// Performs the Unit Instance's Player Input Behaviour

// Check if Unit has Player Input Enabled
if (player_input) 
{
	// DEBUG
	GameManager.player_unit = id;
	
	// Preset Player Controls
	input_left = keyboard_check(GameManager.left_check);
	input_right = keyboard_check(GameManager.right_check);

	input_drop_down = keyboard_check_pressed(GameManager.down_check);
	
	input_jump_hold = keyboard_check(GameManager.jump_check);
	input_double_jump = keyboard_check_pressed(GameManager.jump_check);
	
	input_attack = mouse_check_button(mb_left);
	input_aim = mouse_check_button(mb_right);
	
	input_reload = keyboard_check_pressed(GameManager.reload_check);
	input_drop = keyboard_check_pressed(GameManager.drop_check);
	
	input_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
	input_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
	
	// Player Unit Inventory Controls
	var temp_unit_inventory_index = inventory_index;
	
	if (mouse_wheel_up())
	{
		// Mouse Scroll Up - Increment Inventory Slot Right
		temp_unit_inventory_index++;
		temp_unit_inventory_index = clamp(temp_unit_inventory_index, -1, array_length(inventory_slots) - 1);
		
		// Reset Player Inventory UI Transparency and Fade Timer
		player_inventory_ui_alpha = 1;
		player_inventory_ui_fade_timer = player_inventory_ui_fade_delay;
	}
	else if (mouse_wheel_down())
	{
		// Mouse Scroll Down - Increment Inventory Slot Left
		temp_unit_inventory_index--;
		temp_unit_inventory_index = clamp(temp_unit_inventory_index, -1, array_length(inventory_slots) - 1);
		
		// Reset Player Inventory UI Transparency and Fade Timer
		player_inventory_ui_alpha = 1;
		player_inventory_ui_fade_timer = player_inventory_ui_fade_delay;
	}
	
	if (temp_unit_inventory_index != inventory_index)
	{
		// Detected Inventory Slot Change - Perform Inventory Equipped Item Swap
		unit_inventory_change_slot(id, temp_unit_inventory_index);
	}
	
	// Player Unit Inventory UI Fade
	if (player_inventory_ui_alpha > 0)
	{
		// Decrement Inventory Fade Timer
		player_inventory_ui_fade_timer -= frame_delta;
		player_inventory_ui_fade_timer = player_inventory_ui_fade_timer < 0 ? 0 : player_inventory_ui_fade_timer;
		
		// Check Player Inventory Item Usage
		if (input_aim)
		{
			// Initiate Unit Inventory UI Fade Decay when Player Unit uses Item
			player_inventory_ui_fade_timer = 0;
		}
		else if (input_reload and unit_equipment_animation_state == UnitEquipmentAnimationState.Thrown)
		{
			// Initiate Unit Inventory UI Fade Decay when Player Unit Activates a Grenade Fuze
			player_inventory_ui_fade_timer = 0;
		}
		
		// Player Unit Inventory UI Fade Decay Behaviour
		if (player_inventory_ui_fade_timer <= 0)
		{
			// Calculate Inventory UI Fade Decay
			player_inventory_ui_alpha *= power(player_inventory_ui_alpha_decay, frame_delta);
			player_inventory_ui_alpha = clamp(player_inventory_ui_alpha < 0.05 ? 0 : player_inventory_ui_alpha, 0, 1);
		}
	}
	
	// Player Unit Combat Targeting
	combat_target = undefined;
	
	if (equipment_active and (input_attack or input_aim))
	{
		// Calculate Direction Player is Aiming their Weapon
		rot_prefetch(point_direction(item_equipped.item_x, item_equipped.item_y, input_cursor_x, input_cursor_y));
		var temp_player_input_combat_target_x = item_equipped.item_x + rot_dist_x(sight_ignore_radius);
		var temp_player_input_combat_target_y = item_equipped.item_y + rot_dist_y(sight_ignore_radius);
		
		// Create List of Possible Unit Combat Targets for Faction Hostility Comparison
		var temp_player_input_combat_target_list = ds_list_create();
		var temp_player_input_combat_targets_exist = collision_line_list(item_equipped.item_x, item_equipped.item_y, temp_player_input_combat_target_x, temp_player_input_combat_target_y, oUnit, false, true, temp_player_input_combat_target_list, true);
		
		if (temp_player_input_combat_targets_exist)
		{
			// Iterate through all Unit Instances in Possible Combat Target List
			for (var temp_player_input_combat_target_index = 0; temp_player_input_combat_target_index < ds_list_size(temp_player_input_combat_target_list); temp_player_input_combat_target_index++)
			{
				// Find Possible Combat Target Unit Instance
				var temp_player_input_combat_target = ds_list_find_value(temp_player_input_combat_target_list, temp_player_input_combat_target_index);
				
				// Compare Faction Hostility between Player Input Unit and Possible Combat Target Unit
				if (GameManager.squad_behaviour_director.faction_get_realtionship(faction_id, temp_player_input_combat_target.faction_id) == FactionRelationship.Hostile)
				{
					// Faction Relationship is Hostile - Select this Unit Instance as Combat Target and Early Return
					combat_target = temp_player_input_combat_target;
					break;
				}
			}
		}
		
		// Destroy and Clear unused Combat Targets DS List
		ds_list_destroy(temp_player_input_combat_target_list);
		temp_player_input_combat_target_list = -1;
	}
	
	// Player Unit Camera Follow Behaviour
	var temp_camera_lerp_spd = 0.05;
	var temp_camera_target_x = x - (GameManager.game_width * 0.5) + (x_velocity * 32);
	var temp_camera_target_y = y - (GameManager.game_height * 0.7) + (y_velocity * 32);
	
	if (equipment_active and input_aim)
	{
		if (global.item_packs[item_equipped.item_pack].item_type == ItemType.Weapon)
		{
			temp_camera_lerp_spd = 0.08;
			temp_camera_target_x += (clamp(GameManager.cursor_x, 0, GameManager.game_width) - (GameManager.game_width * 0.5)) * 0.5;
			temp_camera_target_y += (clamp(GameManager.cursor_y, 0, GameManager.game_height) - (GameManager.game_height * 0.5)) * 0.6;
		}
	}
	
	var temp_render_position_x = lerp(LightingEngine.render_x, temp_camera_target_x, frame_delta * temp_camera_lerp_spd);
	var temp_render_position_y = lerp(LightingEngine.render_y, temp_camera_target_y, frame_delta * temp_camera_lerp_spd);
	
	LightingEngine.render_position(temp_render_position_x, temp_render_position_y);
}
