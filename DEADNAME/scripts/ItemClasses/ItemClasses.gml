//
global.item_displacement_lerp_exponent = 3;

//
class ItemClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		
	}
	
	static _destructor = function()
	{
		
	}
	
	// Init Methods
	static init_item_pack = function(init_item_pack)
	{
		// Set Item Pack
		item_pack = init_item_pack;
		
		// Init Item Unit
		item_unit = noone;
		
		// Init Item Properties
		item_sprite = global.item_packs[init_item_pack].render_data.render_sprite;
		item_normalmap = global.item_packs[init_item_pack].render_data.render_normalmap;
		item_metallicroughnessmap = global.item_packs[init_item_pack].render_data.render_metallicroughnessmap;
		item_emissivemap = global.item_packs[init_item_pack].render_data.render_emissivemap;
		
		// Init Item Sprite Packs
		item_normalmap_spritepack = item_normalmap == noone ? undefined : spritepack_get_uvs_transformed(item_sprite, item_normalmap);
		item_metallicroughnessmap_spritepack = item_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(item_sprite, item_metallicroughnessmap);
		item_emissivemap_spritepack = item_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(item_sprite, item_emissivemap);
		
		// Init Item PBR Settings
		item_normal_strength = 1;
		item_metallic = global.item_packs[init_item_pack].render_data.metallic;
		item_roughness = global.item_packs[init_item_pack].render_data.roughness;
		item_emissive = global.item_packs[init_item_pack].render_data.emissive;
		item_emissive_multiplier = 1;
		
		// Init Item Image Index
		item_image_index = 0;
		
		// Init Item Layer Index
		item_layer_index = -1;
		
		// Init Item Conditions
		item_physics_exist = false;
		
		// Init Item Crosshair Properties
		item_crosshair_snap = 2;
		item_crosshair_length_default = 60;
		
		item_crosshair_length = item_crosshair_length_default;
		item_crosshair_position_x = 0;
		item_crosshair_position_y = 0;
	}
	
	static init_item_physics = function(init_item_x = 0, init_item_y = 0, init_item_angle = undefined)
	{
		// Init Item Physics
		item_physics_exist = true;
		
		// Init Item Position & Angle
		item_x = init_item_x;
		item_y = init_item_y;
		
		item_angle = 0;
		item_old_angle = 0;
		
		if (is_undefined(init_item_angle) and instance_exists(item_unit))
		{
			item_angle = item_unit.draw_xscale < 0 ? 180 : 0;
		}
		
		// Init Item Displacement Position & Lerp Speed
		item_displacement_x = 0;
		item_displacement_y = 0;
		item_displacement_spd = 0;
		item_displacement_value = 0;
		
		// Init Item Scale
		item_xscale = 1;
		item_yscale = 1;
		item_facing_sign = 1;
	}
	
	// Equip Methods
	static equip_item = function(unit_instance)
	{
		// Set Item Unit
		item_unit = unit_instance;
		
		// Reset Item Physics
		init_item_physics();
		
		// Set Unit Item Behaviour
		item_unit.equipment_active = true;
		item_unit.item_equipped = self;
		item_unit.unit_equipment_animation_state = UnitEquipmentAnimationState.Item;
		item_unit.unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
		
		// Reset Unit Item Animation Variables
		item_unit.item_drop_offset_transition_value = 0;
		item_unit.item_inventory_slot_pivot_to_unit_item_position_pivot_transition_value = 0;
	}
	
	static unequip_item = function()
	{
		// Set Unit Item Behaviour
		item_unit.equipment_active = false;
		item_unit.item_equipped = noone;
		item_unit.unit_equipment_animation_state = UnitEquipmentAnimationState.None;
		item_unit.unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
		
		// Reset Item Unit
		item_unit = noone;
	}
	
	static item_take_set_displacement = function(item_x, item_y, item_lerp = 0, item_lerp_spd = 0.2)
	{
		// Set Item Take Displacement
		item_displacement_x = item_x;
		item_displacement_y = item_y;
		item_displacement_spd = item_lerp_spd;
		item_displacement_value = item_lerp;
	}
	
	// Update Methods
	static update_item_physics = function(update_item_x, update_item_y, update_item_angle, update_item_facing_sign = 1)
	{
		// Update Item Position & Angle
		item_x = update_item_x;
		item_y = update_item_y;
		item_angle = update_item_angle;
		
		// Update Item Displacement Lerp Behaviour
		if (item_displacement_value > 0)
		{
			// Decrement Item Displacement by Delta Time and Item Displacement Speed
			item_displacement_value -= frame_delta * item_displacement_spd;
			item_displacement_value = clamp(item_displacement_value, 0, 1);
			
			// Calculate Item Displacement Exponent Value
			var temp_item_displacement_value_exp = power(item_displacement_value, global.item_displacement_lerp_exponent);
			
			// Calculate Item Lerp Position based on Item Displacement Position
			item_x = lerp(item_x, item_displacement_x, temp_item_displacement_value_exp);
			item_y = lerp(item_y, item_displacement_y, temp_item_displacement_value_exp);
		}
		
		// Weapon Facing Sign Direction
		item_facing_sign = update_item_facing_sign;
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Item
		lighting_engine_render_sprite_ext
		(
			item_sprite, 
			item_image_index, 
			item_normalmap_spritepack != undefined ? item_normalmap_spritepack[item_image_index].texture : undefined,
			item_metallicroughnessmap_spritepack != undefined ? item_metallicroughnessmap_spritepack[item_image_index].texture : undefined, 
			item_emissivemap_spritepack != undefined ? item_emissivemap_spritepack[item_image_index].texture : undefined, 
			item_normalmap_spritepack != undefined ? item_normalmap_spritepack[item_image_index].uvs : undefined,
			item_metallicroughnessmap_spritepack != undefined ? item_metallicroughnessmap_spritepack[item_image_index].uvs : undefined,
			item_emissivemap_spritepack != undefined ? item_emissivemap_spritepack[item_image_index].uvs : undefined,
			item_normal_strength,
			item_metallic,
			item_roughness,
			item_emissive,
			item_emissive_multiplier,
			item_x, 
			item_y, 
			item_xscale, 
			item_yscale * item_facing_sign, 
			item_angle, 
			c_white, 
			1
		);
	}
	
	static render_unlit_behaviour = function(x_offset = 0, y_offset = 0) 
	{
		// Draw Item
		draw_sprite_ext(item_sprite, item_image_index, item_x + x_offset, item_y + y_offset, item_xscale, item_yscale * item_facing_sign, item_angle, c_white, 1);
	}
}

class WeaponClass extends ItemClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		super._constructor();
	}
	
	static _destructor = function() 
	{
		super._destructor();
	}
	
	// Init Methods
	static init_item_pack = function(init_item_pack)
	{
		// Inherited Item Pack Init Behaviour
		super.init_item_pack(init_item_pack);
		
		// Init Weapon Conditions
		weapon_attack_reset = false;
		
		// Init Weapon Crosshair Properties
		weapon_crosshair_snap = 2;
		weapon_crosshair_length_default = 60;
		
		weapon_crosshair_length = weapon_crosshair_length_default;
		weapon_crosshair_position_x = 0;
		weapon_crosshair_position_y = 0;
	}
	
	static init_item_physics = function(init_item_x = 0, init_item_y = 0, init_item_angle = undefined)
	{
		// Inherited Init Item Physics Behaviour
		super.init_item_physics(init_item_x, init_item_y, init_item_angle);
		
		// Init Weapon Recoil
		weapon_horizontal_recoil = 0;
		weapon_vertical_recoil = 0;
		weapon_angle_recoil = 0;
		
		weapon_horizontal_recoil_target = 0;
		weapon_vertical_recoil_target = 0;
		weapon_angle_recoil_target = 0;
	}
	
	// Equip Methods
	static equip_item = function(unit_instance)
	{
		// Set Item Unit
		item_unit = unit_instance;
		
		// Reset Item Physics
		init_item_physics();
		
		// Set Unit Item Behaviour
		item_unit.equipment_active = true;
		item_unit.item_equipped = self;
		item_unit.unit_equipment_animation_state = UnitEquipmentAnimationState.Melee;
		item_unit.unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
	}
	
	static unequip_item = function()
	{
		// Inherited Unequip Behaviour
		super.unequip_item();
	}
	
	static item_take_set_displacement = function(item_x, item_y, item_lerp = 0, item_lerp_spd = 0.2)
	{
		// Set Item Take Displacement
		super.item_take_set_displacement(item_x, item_y, item_lerp, item_lerp_spd);
	}
	
	// Update Methods
	static update_item_physics = function(update_item_x, update_item_y, update_item_angle, update_item_facing_sign = 1)
	{
		// Update Item Position & Angle
		item_x = update_item_x;
		item_y = update_item_y;
		item_angle = update_item_angle;
		
		// Update Item Displacement Lerp Behaviour
		if (item_displacement_value > 0)
		{
			// Decrement Item Displacement by Delta Time and Item Displacement Speed
			item_displacement_value -= frame_delta * item_displacement_spd;
			item_displacement_value = clamp(item_displacement_value, 0, 1);
			
			// Calculate Item Displacement Exponent Value
			var temp_item_displacement_value_exp = power(item_displacement_value, global.item_displacement_lerp_exponent);
			
			// Calculate Item Lerp Position based on Item Displacement Position
			item_x = lerp(item_x, item_displacement_x, temp_item_displacement_value_exp);
			item_y = lerp(item_y, item_displacement_y, temp_item_displacement_value_exp);
		}
		
		// Weapon Facing Sign Direction
		item_facing_sign = update_item_facing_sign;
	}
	
	static update_weapon_behaviour = function()
	{
		
	}
	
	static update_weapon_attack = function(weapon_target = undefined)
	{
		
	}
	
	// Weapon Behaviours
	static reset_weapon = function()
	{
		// Reset Firearm
		weapon_attack_reset = true;
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		lighting_engine_render_sprite_ext
		(
			item_sprite, 
			item_image_index, 
			item_normalmap_spritepack != undefined ? item_normalmap_spritepack[item_image_index].texture : undefined,
			item_metallicroughnessmap_spritepack != undefined ? item_metallicroughnessmap_spritepack[item_image_index].texture : undefined, 
			item_emissivemap_spritepack != undefined ? item_emissivemap_spritepack[item_image_index].texture : undefined, 
			item_normalmap_spritepack != undefined ? item_normalmap_spritepack[item_image_index].uvs : undefined,
			item_metallicroughnessmap_spritepack != undefined ? item_metallicroughnessmap_spritepack[item_image_index].uvs : undefined,
			item_emissivemap_spritepack != undefined ? item_emissivemap_spritepack[item_image_index].uvs : undefined,
			item_normal_strength,
			item_metallic,
			item_roughness,
			item_emissive,
			item_emissive_multiplier,
			item_x, 
			item_y, 
			item_xscale, 
			item_yscale * item_facing_sign, 
			item_angle + (weapon_angle_recoil * item_facing_sign), 
			c_white, 
			1
		);
	}
	
	static render_unlit_behaviour = function(x_offset = 0, y_offset = 0) 
	{
		// Draw Weapon
		draw_sprite_ext(item_sprite, item_image_index, item_x + x_offset, item_y + y_offset, item_xscale, item_yscale * item_facing_sign, item_angle + (weapon_angle_recoil * item_facing_sign), c_white, 1);
	}
	
	static render_cursor_behaviour = function()
	{
		// Draw Weapon's Cursor Crosshair
	}
}

class FirearmClass extends WeaponClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		super._constructor();
	}
	
	static _destructor = function() 
	{
		super._destructor();
	}
	
	// Init Methods
	static init_item_pack = function(init_item_pack, init_firearm_loaded_ammo = -1)
	{
		// Inherited Item Pack Init Behaviour
		super.init_item_pack(init_item_pack);
		
		// Weapon
		firearm_ammo = init_firearm_loaded_ammo < 0 ? global.item_packs[item_pack].weapon_data.firearm_max_ammo_capacity : init_firearm_loaded_ammo;
		firearm_eject_cartridge_num = 0;
		
		// Reload Settings
		firearm_spin_reload = false;
		firearm_spin_reload_spd = global.item_packs[item_pack].weapon_data.firearm_reload_spin_spd;
		firearm_spin_reload_angle = 0;
		
		// Init Weapon Timers
		firearm_recoil_recovery_delay = 0;
		firearm_attack_delay = 0;
		
		// Firearm Muzzle Flare
		firearm_muzzle_flare = noone;
	}
	
	static init_item_physics = function(init_item_x = 0, init_item_y = 0, init_item_angle = undefined)
	{
		// Init Weapon Position & Angle
		super.init_item_physics(init_item_x, init_item_y, init_item_angle);
	}
	
	// Equip Methods
	static equip_item = function(unit_instance)
	{
		// Default Equip Weapon Behaviour
		super.equip_item(unit_instance);
		
		// Set Unit Weapon Behaviour
		unit_instance.unit_equipment_animation_state = UnitEquipmentAnimationState.Firearm;
		
		// Reset Firearm Attack Condition 
		weapon_attack_reset = false;
		
		// Reset Firearm Reload Conditions
		firearm_spin_reload = false;
		firearm_spin_reload_angle = 0;
		
		// Reset Unit Animation Values
		unit_instance.firearm_weapon_primary_hand_pivot_transition_value = 0;
		unit_instance.firearm_weapon_secondary_hand_pivot_transition_value = 0;
	}
	
	static unequip_item = function()
	{
		// Default Unequip Weapon Behaviour
		super.unequip_item();
		
		// Reset Firearm Reload Conditions
		firearm_spin_reload = false;
		firearm_spin_reload_angle = 0;
	}
	
	static item_take_set_displacement = function(item_x, item_y, item_lerp = 0, item_lerp_spd = 0.2)
	{
		// Default Item Set Displacement
		super.item_take_set_displacement(item_x, item_y, item_lerp, item_lerp_spd);
	}
	
	// Update Methods
	static update_item_physics = function(update_item_x, update_item_y, update_item_angle, update_item_facing_sign = 1)
	{
		// Update Item Position & Angle
		item_x = update_item_x;
		item_y = update_item_y;
		item_angle = update_item_angle;
		
		// Update Item Displacement Lerp Behaviour
		if (item_displacement_value > 0)
		{
			// Decrement Item Displacement by Delta Time and Item Displacement Speed
			item_displacement_value -= frame_delta * item_displacement_spd;
			item_displacement_value = clamp(item_displacement_value, 0, 1);
			
			// Calculate Item Displacement Exponent Value
			var temp_item_displacement_value_exp = power(item_displacement_value, global.item_displacement_lerp_exponent);
			
			// Calculate Item Lerp Position based on Item Displacement Position
			item_x = lerp(item_x, item_displacement_x, temp_item_displacement_value_exp);
			item_y = lerp(item_y, item_displacement_y, temp_item_displacement_value_exp);
		}
		
		// Weapon Facing Sign Direction
		item_facing_sign = update_item_facing_sign;
		
		// Firearm Muzzle Flare
		if (instance_exists(firearm_muzzle_flare))
		{
			// Firearm Muzzle Angle
			var temp_firing_angle = (item_angle + (weapon_angle_recoil * item_facing_sign)) mod 360;
			temp_firing_angle = temp_firing_angle < 0 ? temp_firing_angle + 360 : temp_firing_angle;
			
			// Firearm Muzzle Position
			rot_prefetch(temp_firing_angle);
			var temp_firearm_muzzle_horizontal_offset = rot_point_x(global.item_packs[item_pack].weapon_data.firearm_muzzle_x, item_facing_sign * global.item_packs[item_pack].weapon_data.firearm_muzzle_y);
			var temp_firearm_muzzle_vertical_offset = rot_point_y(global.item_packs[item_pack].weapon_data.firearm_muzzle_x, item_facing_sign * global.item_packs[item_pack].weapon_data.firearm_muzzle_y);
			
			// Update Firearm Muzzle Flare Instance's Position & Rotation
			firearm_muzzle_flare.x = item_x + temp_firearm_muzzle_horizontal_offset;
			firearm_muzzle_flare.y = item_y + temp_firearm_muzzle_vertical_offset;
			firearm_muzzle_flare.image_angle = temp_firing_angle;
		}
	}
	
	static update_weapon_behaviour = function(unit_firearm_recoil_recovery_spd = 0.2, unit_firearm_recoil_angle_recovery_spd = 0.1)
	{
		// Cycle Weapon
		firearm_attack_delay = firearm_attack_delay > 0 ? firearm_attack_delay - frame_delta : firearm_attack_delay;
		
		// Recoil Behaviour
		if (firearm_recoil_recovery_delay > 0)
		{
			// Firearm Recoil
			firearm_recoil_recovery_delay -= frame_delta;
			
			// Add Firearm Recoil
			weapon_horizontal_recoil += weapon_horizontal_recoil_target * frame_delta;
			weapon_vertical_recoil += weapon_vertical_recoil_target * frame_delta;
			weapon_angle_recoil += weapon_angle_recoil_target * frame_delta;
			
			// Clamp Firearm Recoil
			weapon_horizontal_recoil = clamp(weapon_horizontal_recoil, -global.item_packs[item_pack].weapon_data.firearm_total_recoil_horizontal, global.item_packs[item_pack].weapon_data.firearm_total_recoil_horizontal);
			weapon_vertical_recoil = clamp(weapon_vertical_recoil, -global.item_packs[item_pack].weapon_data.firearm_total_recoil_vertical, global.item_packs[item_pack].weapon_data.firearm_total_recoil_vertical);
			weapon_angle_recoil = clamp(weapon_angle_recoil, -global.item_packs[item_pack].weapon_data.firearm_total_recoil_angle, global.item_packs[item_pack].weapon_data.firearm_total_recoil_angle);
		}
		else
		{
			// Weapon Recoil Recovery
			weapon_horizontal_recoil = lerp(weapon_horizontal_recoil, 0, unit_firearm_recoil_recovery_spd * frame_delta);
			weapon_vertical_recoil = lerp(weapon_vertical_recoil, 0, unit_firearm_recoil_recovery_spd * frame_delta);
			weapon_angle_recoil = lerp(weapon_angle_recoil, 0, unit_firearm_recoil_angle_recovery_spd * frame_delta);
		}
		
		// Player Unit's Weapon Crosshair Cursor Position
		if (instance_exists(item_unit) and item_unit.player_input)
		{
			// Calculate Weapon Rotation
			var temp_firing_angle = (item_angle + (weapon_angle_recoil * item_facing_sign)) mod 360;
			temp_firing_angle = temp_firing_angle < 0 ? temp_firing_angle + 360 : temp_firing_angle;
			
			// Weapon Rotation Behaviour
			rot_prefetch(temp_firing_angle);
			
			var temp_firearm_muzzle_position_x = item_x + rot_point_x(global.item_packs[item_pack].weapon_data.firearm_muzzle_x, item_facing_sign * global.item_packs[item_pack].weapon_data.firearm_muzzle_y);
			var temp_firearm_muzzle_position_y = item_y + rot_point_y(global.item_packs[item_pack].weapon_data.firearm_muzzle_x, item_facing_sign * global.item_packs[item_pack].weapon_data.firearm_muzzle_y);
			
			// Unit Aiming Behaviour
			var temp_weapon_unit_is_reloading = item_unit.unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload;
			
			if (!temp_weapon_unit_is_reloading)
			{
				// Set Default Crosshair Length from Firearm Muzzle Position
				var temp_weapon_crosshair_length_target = weapon_crosshair_length_default;
				
				// Check if Unit is Aiming Firearm
				if (item_unit.weapon_aim)
				{
					// Calculate Target Crosshair Length from Firearm Muzzle to Player Cursor
					temp_weapon_crosshair_length_target = point_distance(temp_firearm_muzzle_position_x, temp_firearm_muzzle_position_y, GameManager.cursor_x + LightingEngine.render_x, GameManager.cursor_y + LightingEngine.render_y);
					
					// Check if Player Cursor is behind Firearm's Muzzle
					if (point_distance(item_x, item_y, GameManager.cursor_x + LightingEngine.render_x, GameManager.cursor_y + LightingEngine.render_y) < point_distance(0, 0, global.item_packs[item_pack].weapon_data.firearm_muzzle_x, global.item_packs[item_pack].weapon_data.firearm_muzzle_y))
					{
						// Clamp Crosshair Length to 0
						temp_weapon_crosshair_length_target = 0;
					}
				}
				
				// Lerp Crosshair Length from Muzzle to Target Crosshair Length based on Unit's Weapon Angle Aim Speed
				weapon_crosshair_length = lerp(weapon_crosshair_length, temp_weapon_crosshair_length_target, item_unit.firearm_aiming_angle_transition_spd * frame_delta);
			}
			
			// Calculate Firearm Crosshair Position
			var temp_weapon_crosshair_position_x = temp_firearm_muzzle_position_x + rot_point_x(weapon_crosshair_length, 0);
			var temp_weapon_crosshair_position_y = temp_firearm_muzzle_position_y + rot_point_y(weapon_crosshair_length, 0);
			
			// Firearm Crosshair Position Snap
			var temp_weapon_crosshair_snap = firearm_recoil_recovery_delay <= 0 and weapon_angle_recoil < 0.5 and !temp_weapon_unit_is_reloading and temp_weapon_crosshair_length_target > 0;
			var temp_weapon_crosshair_distance = point_distance(GameManager.cursor_x + LightingEngine.render_x, GameManager.cursor_y + LightingEngine.render_y, temp_weapon_crosshair_position_x, temp_weapon_crosshair_position_y) < weapon_crosshair_snap;
			
			if (item_unit.weapon_aim and temp_weapon_crosshair_snap and temp_weapon_crosshair_distance)
			{
				// Snap Weapon Crosshair Position to Player Cursor
				weapon_crosshair_position_x = GameManager.cursor_x + LightingEngine.render_x;
				weapon_crosshair_position_y = GameManager.cursor_y + LightingEngine.render_y;
			}
			else
			{
				// Calculate Weapon Crosshair Position based on Firearm's Rotation and Weapon Crosshair Length
				weapon_crosshair_position_x = temp_weapon_crosshair_position_x;
				weapon_crosshair_position_y = temp_weapon_crosshair_position_y;
			}
		}
	}
	
	static update_weapon_attack = function(weapon_target = undefined)
	{
		// Invalid Weapon Attack Behaviour
		if (!weapon_attack_reset)
		{
			// Weapon Input Reset Incomplete
			return false;
		}
		else if (item_displacement_value > 0)
		{
			// Firearm is Displaced
			return false;
		}
		else if (firearm_attack_delay > 0)
		{
			// Firing Cycle Incomplete
			return false;
		}
		else if (firearm_ammo <= 0)
		{
			// Firearm Ammo Exhuasted
			return false;
		}
		
		// Deplete Ammo
		var temp_firearm_shots_fired = 1;
		firearm_ammo -= temp_firearm_shots_fired;
		firearm_eject_cartridge_num = temp_firearm_shots_fired;
		
		// Firing Angle
		var temp_firing_angle = (item_angle + (weapon_angle_recoil * item_facing_sign)) mod 360;
		temp_firing_angle = temp_firing_angle < 0 ? temp_firing_angle + 360 : temp_firing_angle;
		
		// Set Firearm Recoil Targets
		var temp_firearm_recoil_horizontal_offset = -random_range(global.item_packs[item_pack].weapon_data.firearm_random_recoil_horizontal_min, global.item_packs[item_pack].weapon_data.firearm_random_recoil_horizontal_max);
		var temp_firearm_recoil_vertical_offset = random_range(global.item_packs[item_pack].weapon_data.firearm_random_recoil_vertical_min, global.item_packs[item_pack].weapon_data.firearm_random_recoil_vertical_max);
		
		rot_prefetch(item_facing_sign != -1 ? 360 - ((temp_firing_angle + 180) mod 360) : temp_firing_angle);
		weapon_horizontal_recoil_target = rot_point_x(temp_firearm_recoil_horizontal_offset, temp_firearm_recoil_vertical_offset);
		weapon_vertical_recoil_target = -rot_point_y(temp_firearm_recoil_horizontal_offset, temp_firearm_recoil_vertical_offset);
		
		weapon_angle_recoil_target = random_range(global.item_packs[item_pack].weapon_data.firearm_random_recoil_angle_min, global.item_packs[item_pack].weapon_data.firearm_random_recoil_angle_max);
		
		// Firearm Muzzle Position
		rot_prefetch(temp_firing_angle);
		var temp_firearm_muzzle_horizontal_offset = rot_point_x(global.item_packs[item_pack].weapon_data.firearm_muzzle_x, item_facing_sign * global.item_packs[item_pack].weapon_data.firearm_muzzle_y);
		var temp_firearm_muzzle_vertical_offset = rot_point_y(global.item_packs[item_pack].weapon_data.firearm_muzzle_x, item_facing_sign * global.item_packs[item_pack].weapon_data.firearm_muzzle_y);
		
		// Attack Weapon Target
		var temp_firearm_attack_success = random(1.0) < global.item_packs[item_pack].weapon_data.firearm_attack_hit_percentage and !is_undefined(weapon_target) and instance_exists(weapon_target);
		
		var temp_firearm_attack_hit = false;
		var temp_firearm_attack_contact = false;
		var temp_firearm_attack_distance = 0;
		
		if (temp_firearm_attack_success)
		{
			// Calculate Squad Luck Damage
			var temp_weapon_target_squad_luck_exists = false;
			
			if (weapon_target.squad_id != SquadIDNull)
			{
				// Find Weapon Target Squad
				var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, weapon_target.squad_id);
				
				// Check if Squad Exists
				if (temp_squad_index != -1)
				{
					// Calculate Squad Luck
					var temp_squad_luck = ds_list_find_value(GameManager.squad_behaviour_director.squad_luck_list, temp_squad_index);
					
					// Check if Squad Luck has not been broken
					if (temp_squad_luck > 0)
					{
						// Set Squad Luck to absorb Weapon Luck Damage
						temp_weapon_target_squad_luck_exists = true;
						ds_list_set(GameManager.squad_behaviour_director.squad_luck_list, temp_squad_index, max(temp_squad_luck - global.item_packs[item_pack].weapon_data.firearm_attack_luck_damage, 0));
					}
				}
			}
			
			// Calculate Weapon Target Luck Damage
			if (!temp_weapon_target_squad_luck_exists)
			{
				// Check if Weapon Target Unit is Lucky
				if (weapon_target.unit_luck > 0)
				{
					// Calculate Unit's Luck Damage
					weapon_target.unit_luck = max(weapon_target.unit_luck - global.item_packs[item_pack].weapon_data.firearm_attack_luck_damage, 0);
				}
				else
				{
					// Weapon Target has depleted their Unit and Squad Luck values - Firearm Attack successfully hits Weapon Target
					temp_firearm_attack_hit = true;
				}
			}
		}
		
		if (instance_exists(item_unit) and item_unit.player_input)
		{
			// Player Asymmetry - All Player Attacks always hit their Combat Target
			temp_firearm_attack_hit = !is_undefined(weapon_target) and instance_exists(weapon_target);
		}
		
		if (temp_firearm_attack_hit)
		{
			// Calculate Firearm Attack as Hit Shot
			for (var i = 0; i <= global.item_packs[item_pack].weapon_data.firearm_attack_distance; i++)
			{
				// Update Firearm's Attack Distance
				temp_firearm_attack_distance = i;
				
				// Update Firearm's Projectile Impact Position
				var temp_firearm_projectile_impact_x = item_x + temp_firearm_muzzle_horizontal_offset + rot_point_x(i, 0);
				var temp_firearm_projectile_impact_y = item_y + temp_firearm_muzzle_vertical_offset + rot_point_y(i, 0);
				
				// Check if Firearm's Projectile has made Contact with Weapon Target
				if (instance_position(temp_firearm_projectile_impact_x, temp_firearm_projectile_impact_y, weapon_target))
				{
					// Update Unit Combat Attack Impulse Properties
					weapon_target.combat_attack_impulse_power = global.item_packs[item_pack].weapon_data.firearm_attack_impulse_power;
					weapon_target.combat_attack_impulse_position_x = temp_firearm_projectile_impact_x;
					weapon_target.combat_attack_impulse_position_y = temp_firearm_projectile_impact_y;
					weapon_target.combat_attack_impulse_horizontal_vector = trig_cosine;
					weapon_target.combat_attack_impulse_vertical_vector = trig_sine;
					
					// Update Unit Health
					weapon_target.unit_health -= global.item_packs[item_pack].weapon_data.firearm_attack_damage;
					
					// Firearm Projectile Contact has been made
					temp_firearm_attack_contact = true;
					break;
				}
			}
		}
		else
		{
			// Calculate Firearm Attack as Missed Shot
			for (var i = 0; i <= global.item_packs[item_pack].weapon_data.firearm_attack_distance; i++)
			{
				// Update Firearm's Attack Distance
				temp_firearm_attack_distance = i;
				
				// Update Firearm's Projectile Impact Position
				var temp_firearm_projectile_impact_x = item_x + temp_firearm_muzzle_horizontal_offset + rot_point_x(i, 0);
				var temp_firearm_projectile_impact_y = item_y + temp_firearm_muzzle_vertical_offset + rot_point_y(i, 0);
				
				// Check if Firearm's Projectile has made Contact with Physics Solid
				if (instance_position(temp_firearm_projectile_impact_x, temp_firearm_projectile_impact_y, oSolid))
				{
					// Firearm Projectile Contact has been made
					temp_firearm_attack_contact = true;
					break;
				}
			}
		}
		
		// Impact Hitmarker
		var temp_hitmarker_x = item_x + temp_firearm_muzzle_horizontal_offset + rot_point_x(temp_firearm_attack_distance, 0);
		var temp_hitmarker_y = item_y + temp_firearm_muzzle_vertical_offset + rot_point_y(temp_firearm_attack_distance, 0);
		
		if (temp_firearm_attack_contact or !point_in_rectangle(temp_hitmarker_x, temp_hitmarker_y, LightingEngine.render_x, LightingEngine.render_y, LightingEngine.render_x + GameManager.game_width, LightingEngine.render_y + GameManager.game_height))
		{
			instance_create_depth(temp_hitmarker_x, temp_hitmarker_y, 0, oImpact_Hitmarker, { hitmarker_contact: temp_firearm_attack_contact, trail_angle: (temp_firing_angle + 540) mod 360, trail_distance: temp_firearm_attack_distance });
		}
		
		// Firing Effect
		fire_firearm(item_x + temp_firearm_muzzle_horizontal_offset, item_y + temp_firearm_muzzle_vertical_offset, temp_firing_angle, temp_firearm_attack_distance);
		
		// Set Firearm Timers
		firearm_attack_delay = global.item_packs[item_pack].weapon_data.firearm_attack_delay;
		firearm_recoil_recovery_delay = global.item_packs[item_pack].weapon_data.firearm_recoil_recovery_delay;
		
		// Reset Firearm Attack Condition
		switch (global.item_packs[item_pack].weapon_data.weapon_type)
		{
			case WeaponType.DefaultFirearm:
				weapon_attack_reset = firearm_ammo <= 0 ? false : weapon_attack_reset;
				break;
			case WeaponType.BoltActionFirearm:
				weapon_attack_reset = false;
				break;
			default:
				weapon_attack_reset = false;
			    break;
		}
		
		// Firing Success
		return true;
	}
	
	// Firearm Behaviours
	static fire_firearm = function(muzzle_x, muzzle_y, attack_direction, attack_distance)
	{
		// Firearm Sub Layer Index
		var temp_firearm_sub_layer_index = instance_exists(item_unit) ? lighting_engine_find_object_index(item_unit) + 1 : item_layer_index;
		
		// Firearm Smoke Trail
		if (global.item_packs[item_pack].weapon_data.firearm_smoke_trail_object != noone)
		{
			// Create Firearm Smoke Trail Instance
			var temp_firearm_smoke_trail_object_var_struct = 
			{ 
				image_angle: attack_direction, 
				sub_layer_index: temp_firearm_sub_layer_index, 
				trail_length: attack_distance 
			};
			
			instance_create_depth(muzzle_x, muzzle_y, 0, global.item_packs[item_pack].weapon_data.firearm_smoke_trail_object, temp_firearm_smoke_trail_object_var_struct);
		}
		
		// Firearm Muzzle Smoke
		if (global.item_packs[item_pack].weapon_data.firearm_muzzle_smoke_object != noone)
		{
			// Create Firearm Muzzle Smoke Var Struct
			var temp_firearm_muzzle_smoke_object_var_struct = 
			{
				image_angle: attack_direction, 
				sub_layer_index: temp_firearm_sub_layer_index 
			};
			
			// Create Random Amount of Muzzle Smoke Clouds
			var temp_firearm_muzzle_smoke_count = irandom_range(global.item_packs[item_pack].weapon_data.firearm_muzzle_smoke_min, global.item_packs[item_pack].weapon_data.firearm_muzzle_smoke_max);
			
			// Create Smoke Clouds
			for (var temp_firearm_muzzle_smoke_index = 0; temp_firearm_muzzle_smoke_index < temp_firearm_muzzle_smoke_count; temp_firearm_muzzle_smoke_index++)
			{
				instance_create_depth(muzzle_x, muzzle_y, 0, global.item_packs[item_pack].weapon_data.firearm_muzzle_smoke_object, temp_firearm_muzzle_smoke_object_var_struct);
			}
		}
		
		// Muzzle Flare
		if (global.item_packs[item_pack].weapon_data.firearm_muzzle_flare_object != noone)
		{
			// Destroy existing Firearm Muzzle Flare to replace with new Fresh Muzzle Flare Instance
			if (instance_exists(firearm_muzzle_flare))
			{
				instance_destroy(firearm_muzzle_flare);
			}
			
			// Create Muzzle Flare Instance
			firearm_muzzle_flare = instance_create_depth(muzzle_x, muzzle_y, 0, global.item_packs[item_pack].weapon_data.firearm_muzzle_flare_object);
		}
	}
	
	static reload_firearm = function(reload_rounds_count = undefined)
	{
		// DEBUG
		firearm_ammo = is_undefined(reload_rounds_count) ? global.item_packs[item_pack].weapon_data.firearm_max_ammo_capacity : clamp(firearm_ammo + reload_rounds_count, 0, global.item_packs[item_pack].weapon_data.firearm_max_ammo_capacity);
	}
	
	static close_firearm_chamber = function()
	{
		// Close Firearm Chamber
		item_image_index = 0;
	}
	
	static open_firearm_chamber = function()
	{
		// Open Firearm Chamber
		item_image_index = 1;
		
		// Firearm Eject Spent Ammunition Cartridge Behaviour
		if (firearm_eject_cartridge_num > 0)
		{
			// Eject Spent Ammunition Cartridges
			for (var i = 0; i < firearm_eject_cartridge_num; i++)
			{
				
			}
			
			// Reset Spent Ammunition Cartridge Counter
			firearm_eject_cartridge_num = 0;
		}
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		lighting_engine_render_sprite_ext
		(
			item_sprite, 
			item_image_index, 
			item_normalmap_spritepack != undefined ? item_normalmap_spritepack[item_image_index].texture : undefined,
			item_metallicroughnessmap_spritepack != undefined ? item_metallicroughnessmap_spritepack[item_image_index].texture : undefined, 
			item_emissivemap_spritepack != undefined ? item_emissivemap_spritepack[item_image_index].texture : undefined, 
			item_normalmap_spritepack != undefined ? item_normalmap_spritepack[item_image_index].uvs : undefined,
			item_metallicroughnessmap_spritepack != undefined ? item_metallicroughnessmap_spritepack[item_image_index].uvs : undefined,
			item_emissivemap_spritepack != undefined ? item_emissivemap_spritepack[item_image_index].uvs : undefined,
			item_normal_strength,
			item_metallic,
			item_roughness,
			item_emissive,
			item_emissive_multiplier,
			item_x, 
			item_y, 
			item_xscale, 
			item_yscale * item_facing_sign, 
			item_angle + ((weapon_angle_recoil + firearm_spin_reload_angle) * item_facing_sign), 
			c_white, 
			1
		);
	}
	
	static render_unlit_behaviour = function(x_offset = 0, y_offset = 0) 
	{
		// Draw Weapon
		draw_sprite_ext(item_sprite, item_image_index, item_x + x_offset, item_y + y_offset, item_xscale, item_yscale * item_facing_sign, item_angle + ((weapon_angle_recoil + firearm_spin_reload_angle) * item_facing_sign), c_white, 1);
	}
	
	static render_cursor_behaviour = function()
	{
		// Draw Weapon's Cursor Crosshair
		var temp_player_attack_eligible = firearm_recoil_recovery_delay <= 0 and firearm_ammo > 0 and item_unit.unit_equipment_animation_state != UnitEquipmentAnimationState.FirearmReload;
		draw_sprite(sUI_CursorCrosshairIcons, temp_player_attack_eligible ? 0 : 2, weapon_crosshair_position_x - LightingEngine.render_x, weapon_crosshair_position_y - LightingEngine.render_y);
	}
}

