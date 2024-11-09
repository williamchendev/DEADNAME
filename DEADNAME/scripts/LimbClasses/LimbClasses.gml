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
	// Variables
	limb_target_x = 0;
	limb_target_y = 0;
	
	limb_sprite = noone;
	
	limb_length = 0;
	limb_compress = 0.3;
	
	// Init & Destroy Methods
	static _constructor = function() 
	{
		super._constructor();
	}
	
	static _destructor = function() 
	{
		super._destructor();
	}
	
	// Limb Properties Methods
	static init_arm = function(limb_sprite_index, limb_normal_sprite_index, limb_anchor_offset_x, limb_anchor_offset_y) 
	{
		anchor_offset_x = limb_anchor_offset_x;
		anchor_offset_y = limb_anchor_offset_y;
		
		limb_sprite = limb_sprite_index;
		limb_normals = limb_normal_sprite_index;
	}
	
	// Update Methods
	static update_pivot = function(anchor_x, anchor_y, anchor_angle)
	{
		limb_pivot_x = anchor_x + rot_point_x(anchor_offset_x, anchor_offset_y, anchor_angle);
		limb_pivot_y = anchor_y + rot_point_y(anchor_offset_x, anchor_offset_y);
	}
	
	// Render Methods
	static render_behaviour = function()
	{
		draw_circle(limb_pivot_x, limb_pivot_y, 4, false);
		super.render_behaviour();
	}
}