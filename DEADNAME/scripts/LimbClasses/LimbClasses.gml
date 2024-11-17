//
enum LimbType
{
	LeftArm,
	RightArm
}

//
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
		// Variables
		limb_xscale = 1;
		
		limb_pivot_ax = 0;
		limb_pivot_ay = 0;
		
		limb_pivot_a_angle = 0;
		
		limb_pivot_bx = 0;
		limb_pivot_by = 0;
		
		limb_pivot_b_angle = 0;
		
		// Constructor
		super._constructor();
	}
	
	static _destructor = function() 
	{
		// Destructor
		super._destructor();
	}
	
	// Limb Properties Methods
	static init_arm = function(limb_type, unit_pack) 
	{
		//
		switch (limb_type)
		{
			case LimbType.LeftArm:
				limb_animation_value_offset = 0;
				
				anchor_offset_x = global.unit_packs[unit_pack].limb_anchor_left_arm_x;
				anchor_offset_y = global.unit_packs[unit_pack].limb_anchor_left_arm_y;
				
				limb_sprite = global.unit_packs[unit_pack].ragdoll_arm_left_sprite;
				limb_normals = global.unit_packs[unit_pack].ragdoll_arm_left_normalmap;
				
				limb_anchor_idle_animation_angle = global.unit_packs[unit_pack].limb_left_arm_idle_animation_angle;
				limb_anchor_walk_animation_angle = global.unit_packs[unit_pack].limb_left_arm_walk_animation_angle;
				limb_anchor_jump_animation_angle = global.unit_packs[unit_pack].limb_left_arm_jump_animation_angle;
				
				var limb_walk_animation_extension_percent = global.unit_packs[unit_pack].limb_left_arm_walk_animation_extension_percent;
				limb_walk_animation_ambient_move_width = global.unit_packs[unit_pack].limb_left_arm_walk_animation_ambient_move_width;
				limb_walk_animation_ambient_move_height = global.unit_packs[unit_pack].limb_left_arm_walk_animation_ambient_move_height;
				break;
			case LimbType.RightArm:
				limb_animation_value_offset = 0.5;
				
				anchor_offset_x = global.unit_packs[unit_pack].limb_anchor_right_arm_x;
				anchor_offset_y = global.unit_packs[unit_pack].limb_anchor_right_arm_y;
				
				limb_sprite = global.unit_packs[unit_pack].ragdoll_arm_right_sprite;
				limb_normals = global.unit_packs[unit_pack].ragdoll_arm_right_normalmap;
				
				limb_anchor_idle_animation_angle = global.unit_packs[unit_pack].limb_right_arm_idle_animation_angle;
				limb_anchor_walk_animation_angle = global.unit_packs[unit_pack].limb_right_arm_walk_animation_angle;
				limb_anchor_jump_animation_angle = global.unit_packs[unit_pack].limb_right_arm_jump_animation_angle;
				
				var limb_walk_animation_extension_percent = global.unit_packs[unit_pack].limb_right_arm_walk_animation_extension_percent;
				limb_walk_animation_ambient_move_width = global.unit_packs[unit_pack].limb_right_arm_walk_animation_ambient_move_width;
				limb_walk_animation_ambient_move_height = global.unit_packs[unit_pack].limb_right_arm_walk_animation_ambient_move_height;
				break;
		}
		
		//
		var limb_idle_animation_extension_percent = global.unit_packs[unit_pack].limb_idle_animation_extension_percent;
		limb_idle_animation_ambient_move_width = global.unit_packs[unit_pack].limb_idle_animation_ambient_move_width;
		
		limb_jump_animation_extension_percent = global.unit_packs[unit_pack].limb_jump_animation_extension_percent;
		
		//
		limb_length = sprite_get_height(limb_sprite) * 2;
				
		limb_idle_animation_offset_x = lengthdir_x(limb_length * limb_idle_animation_extension_percent, limb_anchor_idle_animation_angle + 270);
		limb_idle_animation_offset_y = lengthdir_y(limb_length * limb_idle_animation_extension_percent, limb_anchor_idle_animation_angle + 270);
		
		limb_walk_animation_offset_x = lengthdir_x(limb_length * limb_walk_animation_extension_percent, limb_anchor_walk_animation_angle + 270);
		limb_walk_animation_offset_y = lengthdir_y(limb_length * limb_walk_animation_extension_percent, limb_anchor_walk_animation_angle + 270);
		
		limb_jump_animation_offset_x = lengthdir_x(limb_length * limb_jump_animation_extension_percent, limb_anchor_jump_animation_angle + 270);
		limb_jump_animation_offset_y = lengthdir_y(limb_length * limb_jump_animation_extension_percent, limb_anchor_jump_animation_angle + 270);
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
	
	static update_idle_animation = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale, anchor_angle, animation_percentage)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Idle Animation
		var limb_animation_value = (animation_percentage + limb_animation_value_offset) mod 1;
		var temp_idle_animation_offset_x = lengthdir_x(limb_idle_animation_ambient_move_width * limb_xscale, 360 - (limb_animation_value * 360));
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = (anchor_offset_y - (animation_percentage < 0.5)) * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y, anchor_angle);
		limb_pivot_ay = anchor_y + rot_point_y(temp_anchor_offset_x, temp_anchor_offset_y);
		
		// Update Target
		var temp_target_offset_x = temp_anchor_offset_x + temp_idle_animation_offset_x + (limb_idle_animation_offset_x * limb_xscale);
		var temp_target_offset_y = temp_anchor_offset_y + (limb_idle_animation_offset_y * anchor_yscale);
		
		limb_target_x = anchor_x + rot_point_x(temp_target_offset_x, temp_target_offset_y);
		limb_target_y = anchor_y + rot_point_y(temp_target_offset_x, temp_target_offset_y);
		
		// Calculate Movement
		calculate_limb_movement();
	}
	
	static update_walk_animation = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale, anchor_angle, animation_percentage, walk_animation_percentage)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Walk Animation
		var limb_animation_value = (walk_animation_percentage + global.limb_walk_animation_percent_offset + limb_animation_value_offset) mod 1;
		
		var temp_idle_animation_offset_x = lengthdir_x(limb_walk_animation_ambient_move_width * limb_xscale, 360 - (limb_animation_value * 360));
		var temp_idle_animation_offset_y = lengthdir_y(limb_walk_animation_ambient_move_height, 360 - (limb_animation_value * 360));
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = (anchor_offset_y - (animation_percentage > 0.5)) * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y, anchor_angle);
		limb_pivot_ay = anchor_y + rot_point_y(temp_anchor_offset_x, temp_anchor_offset_y);
		
		// Update Target
		var temp_target_offset_x = temp_anchor_offset_x + temp_idle_animation_offset_x + (limb_walk_animation_offset_x * limb_xscale);
		var temp_target_offset_y = temp_anchor_offset_y + temp_idle_animation_offset_y + (limb_walk_animation_offset_y * anchor_yscale);
		
		limb_target_x = anchor_x + rot_point_x(temp_target_offset_x, temp_target_offset_y);
		limb_target_y = anchor_y + rot_point_y(temp_target_offset_x, temp_target_offset_y);
		
		// Calculate Movement
		calculate_limb_movement();
	}
	
	static update_jump_animation = function(anchor_x, anchor_y, anchor_xscale, anchor_yscale, anchor_angle)
	{
		// Update Scale
		limb_xscale = sign(anchor_xscale);
		
		// Update Pivot
		var temp_anchor_offset_x = anchor_offset_x * anchor_xscale;
		var temp_anchor_offset_y = anchor_offset_y * anchor_yscale;
		
		limb_pivot_ax = anchor_x + rot_point_x(temp_anchor_offset_x, temp_anchor_offset_y, anchor_angle);
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
		
		limb_pivot_bx = limb_pivot_ax + lengthdir_x(limb_length / 2, limb_pivot_a_angle);
		limb_pivot_by = limb_pivot_ay + lengthdir_y(limb_length / 2, limb_pivot_a_angle);
		
		limb_pivot_b_angle = temp_limb_direction + (90 * temp_limb_extension_percent * limb_xscale);
	}
	
	// Render Methods
	static render_behaviour = function()
	{
		draw_sprite_ext(limb_sprite, 0, limb_pivot_ax, limb_pivot_ay, limb_xscale, 1, limb_pivot_a_angle + 90, c_white, 1);
		draw_sprite_ext(limb_sprite, 1, limb_pivot_bx, limb_pivot_by, limb_xscale, 1, limb_pivot_b_angle + 90, c_white, 1);
		super.render_behaviour();
	}
}

global.limb_walk_animation_percent_offset = 0.18;