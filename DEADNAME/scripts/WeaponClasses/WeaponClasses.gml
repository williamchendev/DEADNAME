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
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		draw_sprite_ext(weapon_sprite, 0, weapon_x, weapon_y, weapon_xscale, weapon_yscale * weapon_facing_sign, weapon_angle, c_white, 1);
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
	static init_weapon_pack = function(init_weapon_pack)
	{
		super.init_weapon_pack(init_weapon_pack);
		
		// Weapon Anchor Pivots
		weapon_hand_position_trigger_x = global.weapon_packs[init_weapon_pack].weapon_hand_position_trigger_x;
		weapon_hand_position_trigger_y = global.weapon_packs[init_weapon_pack].weapon_hand_position_trigger_y;
		
		weapon_hand_position_offhand_x = global.weapon_packs[init_weapon_pack].weapon_hand_position_offhand_x;
		weapon_hand_position_offhand_y = global.weapon_packs[init_weapon_pack].weapon_hand_position_offhand_y;
	}
	
	static init_weapon_physics = function(init_weapon_x = 0, init_weapon_y = 0, init_weapon_angle = 0)
	{
		// Init Weapon Position & Angle
	    super.init_weapon_physics(init_weapon_x, init_weapon_y, init_weapon_angle);
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
	
	// Render Methods
	static render_behaviour = function() 
	{
		// Draw Weapon
		draw_sprite_ext(weapon_sprite, 0, weapon_x, weapon_y, weapon_xscale, weapon_yscale * weapon_facing_sign, weapon_angle, c_white, 1);
	}
}