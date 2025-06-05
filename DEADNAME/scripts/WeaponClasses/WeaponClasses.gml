class WeaponClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		
	}
	
	static _destructor = function() 
	{
		
	}
	
	// Init Methods
	static init_weapon_pack = function(init_weapon_pack)
	{
		// Set Weapon Pack
		weapon_pack = init_weapon_pack;
		
		// Init Weapon Unit
		weapon_unit = noone;
		
		// Init Weapon Properties
		weapon_sprite = global.weapon_packs[init_weapon_pack].weapon_sprite;
		weapon_normalmap = global.weapon_packs[init_weapon_pack].weapon_normalmap;
		weapon_metallicroughnessmap = global.weapon_packs[init_weapon_pack].weapon_metallicroughnessmap;
		weapon_emissivemap = global.weapon_packs[init_weapon_pack].weapon_emissivemap;
		
		// Init Weapon Sprite Packs
		weapon_normalmap_spritepack = weapon_normalmap == noone ? undefined : spritepack_get_uvs_transformed(weapon_sprite, weapon_normalmap);
		weapon_metallicroughnessmap_spritepack = weapon_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(weapon_sprite, weapon_metallicroughnessmap);
		weapon_emissivemap_spritepack = weapon_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(weapon_sprite, weapon_emissivemap);
		
		// Init Weapon PBR Settings
		weapon_normal_strength = 1;
		weapon_metallic = global.weapon_packs[init_weapon_pack].metallic;
		weapon_roughness = global.weapon_packs[init_weapon_pack].roughness;
		weapon_emissive = global.weapon_packs[init_weapon_pack].emissive;
		weapon_emissive_multiplier = 1;
		
		// Init Weapon Image Index
	    weapon_image_index = 0;
	}
	
	static init_weapon_physics = function(init_weapon_x = 0, init_weapon_y = 0, init_weapon_angle = 0)
	{
		// Init Weapon Position & Angle
	    weapon_x = init_weapon_x;
	    weapon_y = init_weapon_y;
	    weapon_angle = init_weapon_angle;
	    weapon_old_angle = init_weapon_angle;
	    
	    // Init Weapon Scale
	    weapon_xscale = 1;
	    weapon_yscale = 1;
	    weapon_facing_sign = 1;
	}
	
	// Equip Methods
	static equip_weapon = function(unit_instance)
	{
		// Reset Weapon Physics
		init_weapon_physics();
		
		// Set Weapon Unit
		weapon_unit = unit_instance;
		
		// Set Unit Weapon Behaviour
		unit_instance.weapon_active = true;
		unit_instance.weapon_equipped = self;
		unit_instance.unit_equipment_animation_state = UnitEquipmentAnimationState.Melee;
		unit_instance.unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
	}
	
	static unequip_weapon = function()
	{
		// Set Unit Weapon Behaviour
		unit_instance.weapon_active = false;
		unit_instance.weapon_equipped = noone;
		unit_instance.unit_equipment_animation_state = UnitEquipmentAnimationState.None;
		unit_instance.unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
	}
	
	// Update Methods
	static update_weapon_physics = function(update_weapon_x, update_weapon_y, update_weapon_angle)
	{
		// Update Weapon Position & Angle
		weapon_x = update_weapon_x;
		weapon_y = update_weapon_y;
		weapon_angle = update_weapon_angle;
	}
	
	static update_weapon_behaviour = function()
	{
		
	}
	
	static update_weapon_attack = function(weapon_target = undefined)
	{
		
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		lighting_engine_render_sprite_ext
		(
			weapon_sprite, 
			weapon_image_index, 
			weapon_normalmap_spritepack != undefined ? weapon_normalmap_spritepack[weapon_image_index].texture : undefined,
			weapon_metallicroughnessmap_spritepack != undefined ? weapon_metallicroughnessmap_spritepack[weapon_image_index].texture : undefined, 
			weapon_emissivemap_spritepack != undefined ? weapon_emissivemap_spritepack[weapon_image_index].texture : undefined, 
			weapon_normalmap_spritepack != undefined ? weapon_normalmap_spritepack[weapon_image_index].uvs : undefined,
			weapon_metallicroughnessmap_spritepack != undefined ? weapon_metallicroughnessmap_spritepack[weapon_image_index].uvs : undefined,
			weapon_emissivemap_spritepack != undefined ? weapon_emissivemap_spritepack[weapon_image_index].uvs : undefined,
			weapon_normal_strength,
			weapon_metallic,
			weapon_roughness,
			weapon_emissive,
			weapon_emissive_multiplier,
			weapon_x, 
			weapon_y, 
			weapon_xscale, 
			weapon_yscale * weapon_facing_sign, 
			weapon_angle + (weapon_angle_recoil * weapon_facing_sign), 
			c_white, 
			1
		);
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
	static init_weapon_pack = function(init_weapon_pack, init_firearm_loaded_ammo = -1)
	{
		super.init_weapon_pack(init_weapon_pack);
		
		// Weapon
		firearm_ammo = init_firearm_loaded_ammo < 0 ? global.weapon_packs[init_weapon_pack].firearm_max_ammo_capacity : init_firearm_loaded_ammo;
		firearm_eject_cartridge_num = 0;
		
		// Init Weapon Timers
	    firearm_recoil_recovery_delay = 0;
	    firearm_attack_delay = 0;
	    
	    // Firearm Muzzle Flare
	    firearm_muzzle_flare = noone;
	}
	
	static init_weapon_physics = function(init_weapon_x = 0, init_weapon_y = 0, init_weapon_angle = 0)
	{
		// Init Weapon Position & Angle
	    super.init_weapon_physics(init_weapon_x, init_weapon_y, init_weapon_angle);
	    
	    // Init Weapon Recoil
	    weapon_horizontal_recoil = 0;
	    weapon_vertical_recoil = 0;
	    weapon_angle_recoil = 0;
	    
	    weapon_horizontal_recoil_target = 0;
	    weapon_vertical_recoil_target = 0;
	    weapon_angle_recoil_target = 0;
	}
	
	// Equip Methods
	static equip_weapon = function(unit_instance)
	{
		// Default Equip Weapon Behaviour
		super.equip_weapon(unit_instance);
		
		// Set Unit Weapon Behaviour
		unit_instance.unit_equipment_animation_state = UnitEquipmentAnimationState.Firearm;
	}
	
	static unequip_weapon = function()
	{
		// Default Unequip Weapon Behaviour
		super.unequip_weapon();
	}
	
	// Update Methods
	static update_weapon_physics = function(update_weapon_x, update_weapon_y, update_weapon_angle, update_weapon_facing_sign = 1)
	{
		// Update Weapon Position & Angle
		weapon_x = update_weapon_x;
		weapon_y = update_weapon_y;
		weapon_angle = update_weapon_angle;
		
		// Weapon Facing Sign Direction
		weapon_facing_sign = update_weapon_facing_sign;
		
		// Firearm Muzzle Flare
		if (instance_exists(firearm_muzzle_flare))
		{
			// Firearm Muzzle Angle
			var temp_firing_angle = (weapon_angle + (weapon_angle_recoil * weapon_facing_sign)) mod 360;
			temp_firing_angle = temp_firing_angle < 0 ? temp_firing_angle + 360 : temp_firing_angle;
			
			// Firearm Muzzle Position
			rot_prefetch(temp_firing_angle);
			var temp_firearm_muzzle_horizontal_offset = rot_point_x(global.weapon_packs[weapon_pack].firearm_muzzle_x, weapon_facing_sign * global.weapon_packs[weapon_pack].firearm_muzzle_y);
			var temp_firearm_muzzle_vertical_offset = rot_point_y(global.weapon_packs[weapon_pack].firearm_muzzle_x, weapon_facing_sign * global.weapon_packs[weapon_pack].firearm_muzzle_y);
			
			// Update Firearm Muzzle Flare Instance's Position & Rotation
			firearm_muzzle_flare.x = weapon_x + temp_firearm_muzzle_horizontal_offset;
			firearm_muzzle_flare.y = weapon_y + temp_firearm_muzzle_vertical_offset;
			firearm_muzzle_flare.image_angle = temp_firing_angle;
		}
	}
	
	static update_weapon_behaviour = function(unit_firearm_recoil_recovery_spd, unit_firearm_recoil_angle_recovery_spd)
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
			weapon_horizontal_recoil = clamp(weapon_horizontal_recoil, -global.weapon_packs[weapon_pack].firearm_total_recoil_horizontal, global.weapon_packs[weapon_pack].firearm_total_recoil_horizontal);
			weapon_vertical_recoil = clamp(weapon_vertical_recoil, -global.weapon_packs[weapon_pack].firearm_total_recoil_vertical, global.weapon_packs[weapon_pack].firearm_total_recoil_vertical);
			weapon_angle_recoil = clamp(weapon_angle_recoil, -global.weapon_packs[weapon_pack].firearm_total_recoil_angle, global.weapon_packs[weapon_pack].firearm_total_recoil_angle);
		}
		else
		{
			// Weapon Recoil Recovery
			weapon_horizontal_recoil = lerp(weapon_horizontal_recoil, 0, unit_firearm_recoil_recovery_spd * frame_delta);
			weapon_vertical_recoil = lerp(weapon_vertical_recoil, 0, unit_firearm_recoil_recovery_spd * frame_delta);
			weapon_angle_recoil = lerp(weapon_angle_recoil, 0, unit_firearm_recoil_angle_recovery_spd * frame_delta);
		}
	}
	
	static update_weapon_attack = function(weapon_target = undefined)
	{
		// Invalid Weapon Attack Behaviour
		if (firearm_attack_delay > 0)
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
		var temp_firing_angle = (weapon_angle + (weapon_angle_recoil * weapon_facing_sign)) mod 360;
		temp_firing_angle = temp_firing_angle < 0 ? temp_firing_angle + 360 : temp_firing_angle;
		
		// Set Firearm Recoil Targets
		var temp_firearm_recoil_horizontal_offset = -random_range(global.weapon_packs[weapon_pack].firearm_random_recoil_horizontal_min, global.weapon_packs[weapon_pack].firearm_random_recoil_horizontal_max);
		var temp_firearm_recoil_vertical_offset = random_range(global.weapon_packs[weapon_pack].firearm_random_recoil_vertical_min, global.weapon_packs[weapon_pack].firearm_random_recoil_vertical_max);
		
		rot_prefetch(weapon_facing_sign != -1 ? 360 - ((temp_firing_angle + 180) mod 360) : temp_firing_angle);
		weapon_horizontal_recoil_target = rot_point_x(temp_firearm_recoil_horizontal_offset, temp_firearm_recoil_vertical_offset);
		weapon_vertical_recoil_target = -rot_point_y(temp_firearm_recoil_horizontal_offset, temp_firearm_recoil_vertical_offset);
		
		weapon_angle_recoil_target = random_range(global.weapon_packs[weapon_pack].firearm_random_recoil_angle_min, global.weapon_packs[weapon_pack].firearm_random_recoil_angle_max);
		
		// Firearm Muzzle Position
		rot_prefetch(temp_firing_angle);
		var temp_firearm_muzzle_horizontal_offset = rot_point_x(global.weapon_packs[weapon_pack].firearm_muzzle_x, weapon_facing_sign * global.weapon_packs[weapon_pack].firearm_muzzle_y);
		var temp_firearm_muzzle_vertical_offset = rot_point_y(global.weapon_packs[weapon_pack].firearm_muzzle_x, weapon_facing_sign * global.weapon_packs[weapon_pack].firearm_muzzle_y);
		
		// Attack Weapon Target
		var temp_firearm_attack_success = random(1.0) < global.weapon_packs[weapon_pack].firearm_attack_hit_percentage and !is_undefined(weapon_target) and instance_exists(weapon_target);
		
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
						ds_list_set(GameManager.squad_behaviour_director.squad_luck_list, temp_squad_index, max(temp_squad_luck - global.weapon_packs[weapon_pack].firearm_attack_luck_damage, 0));
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
					weapon_target.unit_luck = max(weapon_target.unit_luck - global.weapon_packs[weapon_pack].firearm_attack_luck_damage, 0);
				}
				else
				{
					// Weapon Target has depleted their Unit and Squad Luck values - Firearm Attack successfully hits Weapon Target
					temp_firearm_attack_hit = true;
				}
			}
		}
		
		if (temp_firearm_attack_hit)
		{
			// Calculate Firearm Attack as Hit Shot
			for (var i = 0; i <= global.weapon_packs[weapon_pack].firearm_attack_distance; i++)
			{
				// Update Firearm's Attack Distance
				temp_firearm_attack_distance = i;
				
				// Update Firearm's Projectile Impact Position
				var temp_firearm_projectile_impact_x = weapon_x + temp_firearm_muzzle_horizontal_offset + rot_point_x(i, 0);
				var temp_firearm_projectile_impact_y = weapon_y + temp_firearm_muzzle_vertical_offset + rot_point_y(i, 0);
				
				// Check if Firearm's Projectile has made Contact with Weapon Target
				if (instance_position(temp_firearm_projectile_impact_x, temp_firearm_projectile_impact_y, weapon_target))
				{
					// Update Unit Combat Attack Impulse Properties
					weapon_target.combat_attack_impulse_power = global.weapon_packs[weapon_pack].firearm_attack_impulse_power;
					weapon_target.combat_attack_impulse_position_x = temp_firearm_projectile_impact_x;
					weapon_target.combat_attack_impulse_position_y = temp_firearm_projectile_impact_y;
					weapon_target.combat_attack_impulse_horizontal_vector = trig_cosine;
					weapon_target.combat_attack_impulse_vertical_vector = trig_sine;
					
					// Update Unit Health
					weapon_target.unit_health -= global.weapon_packs[weapon_pack].firearm_attack_damage;
					
					// Firearm Projectile Contact has been made
					temp_firearm_attack_contact = true;
					break;
				}
			}
		}
		else
		{
			// Calculate Firearm Attack as Missed Shot
			for (var i = 0; i <= global.weapon_packs[weapon_pack].firearm_attack_distance; i++)
			{
				// Update Firearm's Attack Distance
				temp_firearm_attack_distance = i;
				
				// Update Firearm's Projectile Impact Position
				var temp_firearm_projectile_impact_x = weapon_x + temp_firearm_muzzle_horizontal_offset + rot_point_x(i, 0);
				var temp_firearm_projectile_impact_y = weapon_y + temp_firearm_muzzle_vertical_offset + rot_point_y(i, 0);
				
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
		var temp_hitmarker_x = weapon_x + temp_firearm_muzzle_horizontal_offset + rot_point_x(temp_firearm_attack_distance, 0);
		var temp_hitmarker_y = weapon_y + temp_firearm_muzzle_vertical_offset + rot_point_y(temp_firearm_attack_distance, 0);
		
		if (temp_firearm_attack_contact or !point_in_rectangle(temp_hitmarker_x, temp_hitmarker_y, LightingEngine.render_x, LightingEngine.render_y, LightingEngine.render_x + GameManager.game_width, LightingEngine.render_y + GameManager.game_height))
		{
			instance_create_depth(temp_hitmarker_x, temp_hitmarker_y, 0, oImpact_Hitmarker, { hitmarker_contact: temp_firearm_attack_contact, trail_angle: (temp_firing_angle + 540) mod 360, trail_distance: temp_firearm_attack_distance });
		}
		
		// Firing Effect
		fire_firearm(weapon_x + temp_firearm_muzzle_horizontal_offset, weapon_y + temp_firearm_muzzle_vertical_offset, temp_firing_angle, temp_firearm_attack_distance);
		
		// Set Firearm Timers
		firearm_attack_delay = global.weapon_packs[weapon_pack].firearm_attack_delay;
		firearm_recoil_recovery_delay = global.weapon_packs[weapon_pack].firearm_recoil_recovery_delay;
		
		// Firing Success
		return true;
	}
	
	// Firearm Behaviours
	static fire_firearm = function(muzzle_x, muzzle_y, attack_direction, attack_distance)
	{
		// Firearm Sub Layer Index
		var temp_firearm_sub_layer_index = instance_exists(weapon_unit) ? lighting_engine_find_object_index(weapon_unit) + 1 : -1;
		
		// Firearm Smoke Trail
		if (global.weapon_packs[weapon_pack].firearm_smoke_trail_object != noone)
		{
			// Create Firearm Smoke Trail Instance
			instance_create_depth(muzzle_x, muzzle_y, 0, global.weapon_packs[weapon_pack].firearm_smoke_trail_object, { image_angle: attack_direction, sub_layer_index: temp_firearm_sub_layer_index, trail_length: attack_distance });
		}
		
		// Firearm Muzzle Smoke
		if (global.weapon_packs[weapon_pack].firearm_muzzle_smoke_object != noone)
		{
			// Create Random Amount of Muzzle Smoke Clouds
			var temp_firearm_muzzle_smoke_count = irandom_range(global.weapon_packs[weapon_pack].firearm_muzzle_smoke_min, global.weapon_packs[weapon_pack].firearm_muzzle_smoke_max);
		
			// Create Smoke Clouds
			for (var temp_firearm_muzzle_smoke_index = 0; temp_firearm_muzzle_smoke_index < temp_firearm_muzzle_smoke_count; temp_firearm_muzzle_smoke_index++)
			{
				instance_create_depth(muzzle_x, muzzle_y, 0, global.weapon_packs[weapon_pack].firearm_muzzle_smoke_object, { image_angle: attack_direction, sub_layer_index: temp_firearm_sub_layer_index });
			}
		}
		
		// Muzzle Flare
		if (global.weapon_packs[weapon_pack].firearm_muzzle_flare_object != noone)
		{
			// Destroy existing Firearm Muzzle Flare to replace with new Fresh Muzzle Flare Instance
			if (instance_exists(firearm_muzzle_flare))
			{
				instance_destroy(firearm_muzzle_flare);
			}
			
			// Create Muzzle Flare Instance
			firearm_muzzle_flare = instance_create_depth(muzzle_x, muzzle_y, 0, global.weapon_packs[weapon_pack].firearm_muzzle_flare_object);
		}
	}
	
	static reload_firearm = function(reload_rounds_count = undefined)
	{
		// DEBUG
		firearm_ammo = is_undefined(reload_rounds_count) ? global.weapon_packs[weapon_pack].firearm_max_ammo_capacity : clamp(firearm_ammo + reload_rounds_count, 0, global.weapon_packs[weapon_pack].firearm_max_ammo_capacity);
	}
	
	static close_firearm_chamber = function()
	{
		// Close Firearm Chamber
		weapon_image_index = 0;
	}
	
	static open_firearm_chamber = function()
	{
		// Open Firearm Chamber
		weapon_image_index = 1;
		
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
			weapon_sprite, 
			weapon_image_index, 
			weapon_normalmap_spritepack != undefined ? weapon_normalmap_spritepack[weapon_image_index].texture : undefined,
			weapon_metallicroughnessmap_spritepack != undefined ? weapon_metallicroughnessmap_spritepack[weapon_image_index].texture : undefined, 
			weapon_emissivemap_spritepack != undefined ? weapon_emissivemap_spritepack[weapon_image_index].texture : undefined, 
			weapon_normalmap_spritepack != undefined ? weapon_normalmap_spritepack[weapon_image_index].uvs : undefined,
			weapon_metallicroughnessmap_spritepack != undefined ? weapon_metallicroughnessmap_spritepack[weapon_image_index].uvs : undefined,
			weapon_emissivemap_spritepack != undefined ? weapon_emissivemap_spritepack[weapon_image_index].uvs : undefined,
			weapon_normal_strength,
			weapon_metallic,
			weapon_roughness,
			weapon_emissive,
			weapon_emissive_multiplier,
			weapon_x, 
			weapon_y, 
			weapon_xscale, 
			weapon_yscale * weapon_facing_sign, 
			weapon_angle + (weapon_angle_recoil * weapon_facing_sign), 
			c_white, 
			1
		);
	}
}
