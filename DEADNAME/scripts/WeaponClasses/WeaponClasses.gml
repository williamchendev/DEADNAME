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
		
		// Init Weapon Properties
		weapon_sprite = global.weapon_packs[init_weapon_pack].weapon_sprite;
		weapon_normalmap = global.weapon_packs[init_weapon_pack].weapon_normalmap;
		
		// Init Weapon Image Index
	    weapon_image_index = 0;
	}
	
	static init_weapon_physics = function(init_weapon_x = 0, init_weapon_y = 0, init_weapon_angle = 0)
	{
		// Init Weapon Position & Angle
	    weapon_x = init_weapon_x;
	    weapon_y = init_weapon_y;
	    weapon_angle = init_weapon_angle;
	    
	    // Init Weapon Scale
	    weapon_xscale = 1;
	    weapon_yscale = 1;
	    weapon_facing_sign = 1;
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
	
	static update_weapon_attack = function()
	{
		
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		draw_sprite_ext(weapon_sprite, weapon_image_index, weapon_x, weapon_y, weapon_xscale, weapon_yscale * weapon_facing_sign, weapon_angle, c_white, 1);
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
	static init_weapon_pack = function(init_weapon_pack, init_firearm_loaded_ammo = 0)
	{
		super.init_weapon_pack(init_weapon_pack);
		
		// Weapon
		firearm_ammo = init_firearm_loaded_ammo;
		
		// Init Weapon Timers
	    firearm_reload_recovery_delay = 0;
	    firearm_cycle_delay = 0;
	}
	
	static init_weapon_physics = function(init_weapon_x = 0, init_weapon_y = 0, init_weapon_angle = 0)
	{
		// Init Weapon Position & Angle
	    super.init_weapon_physics(init_weapon_x, init_weapon_y, init_weapon_angle);
	    
	    // Init Weapon Recoil
	    weapon_horizontal_recoil = 0;
	    weapon_vertical_recoil = 0;
	    weapon_angle_recoil = 0;
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
	}
	
	static update_weapon_behaviour = function(unit_firearm_recoil_recovery_spd, unit_firearm_recoil_angle_recovery_spd)
	{
		// Cycle Weapon
		firearm_cycle_delay = firearm_cycle_delay > 0 ? firearm_cycle_delay - frame_delta : firearm_cycle_delay;
		
		// Recoil Recovery
		if (firearm_reload_recovery_delay > 0)
		{
			firearm_reload_recovery_delay -= frame_delta;
		}
		else
		{
			weapon_horizontal_recoil = lerp(weapon_horizontal_recoil, 0, unit_firearm_recoil_recovery_spd * frame_delta);
			weapon_vertical_recoil = lerp(weapon_vertical_recoil, 0, unit_firearm_recoil_recovery_spd * frame_delta);
			weapon_angle_recoil = lerp(weapon_angle_recoil, 0, unit_firearm_recoil_angle_recovery_spd * frame_delta);
		}
	}
	
	static update_weapon_attack = function()
	{
		// Firing Cycle Incomplete
		if (firearm_cycle_delay > 0)
		{
			// Early Return
			return;
		}
		
		// Firing Angle
		var temp_firing_angle = (weapon_angle + (weapon_angle_recoil * weapon_facing_sign)) mod 360;
		temp_firing_angle = temp_firing_angle < 0 ? temp_firing_angle + 360 : temp_firing_angle;
		
		// Set Weapon Recoil
		var temp_firearm_recoil_horizontal_offset = random_range(global.weapon_packs[weapon_pack].firearm_random_recoil_horizontal_min, global.weapon_packs[weapon_pack].firearm_random_recoil_horizontal_max);
		var temp_firearm_recoil_vertical_offset = random_range(global.weapon_packs[weapon_pack].firearm_random_recoil_vertical_min, global.weapon_packs[weapon_pack].firearm_random_recoil_vertical_max);
		
		rot_prefetch(temp_firing_angle);
		
		weapon_horizontal_recoil += rot_point_x(temp_firearm_recoil_horizontal_offset, temp_firearm_recoil_vertical_offset);
		weapon_horizontal_recoil = clamp(weapon_horizontal_recoil, -global.weapon_packs[weapon_pack].firearm_total_recoil_horizontal, global.weapon_packs[weapon_pack].firearm_total_recoil_horizontal);
		
		weapon_vertical_recoil += rot_point_y(temp_firearm_recoil_horizontal_offset, temp_firearm_recoil_vertical_offset);
		weapon_vertical_recoil = clamp(weapon_vertical_recoil, -global.weapon_packs[weapon_pack].firearm_total_recoil_vertical, global.weapon_packs[weapon_pack].firearm_total_recoil_vertical);
		
		weapon_angle_recoil += random_range(global.weapon_packs[weapon_pack].firearm_random_recoil_angle_min, global.weapon_packs[weapon_pack].firearm_random_recoil_angle_max);
		weapon_angle_recoil = clamp(weapon_angle_recoil, -global.weapon_packs[weapon_pack].firearm_total_recoil_angle, global.weapon_packs[weapon_pack].firearm_total_recoil_angle);
		
		// Set Weapon Timers
		firearm_cycle_delay = global.weapon_packs[weapon_pack].firearm_cycle_delay;
		firearm_reload_recovery_delay = global.weapon_packs[weapon_pack].firearm_reload_recovery_delay;
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		draw_sprite_ext(weapon_sprite, weapon_image_index, weapon_x, weapon_y, weapon_xscale, weapon_yscale * weapon_facing_sign, weapon_angle + (weapon_angle_recoil * weapon_facing_sign), c_white, 1);
	}
}