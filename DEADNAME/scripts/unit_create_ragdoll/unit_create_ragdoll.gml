/// unit_create_ragdoll(x,y,image_xscale,depth,limb_sprites, head_offset, arm_offset, leg_offset);
/// @description Creates a Ragdoll Physics Object from given variables
/// @param {oUnit} x The x position of the ragdoll to create (center bottom of ragdoll)
/// @returns {struct} An array of the limb objects in the ragdoll object
function unit_create_ragdoll(unit_instance) 
{
	// Establish Variables
	var temp_arms_left_sprite = global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_sprite;
	var temp_arms_right_sprite = global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_sprite;
	var temp_chest_top_sprite = global.unit_packs[unit_instance.unit_pack].ragdoll_chest_top_sprite;
	var temp_chest_bot_sprite = global.unit_packs[unit_instance.unit_pack].ragdoll_chest_bot_sprite;
	var temp_legs_left_sprite = global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_sprite;
	var temp_legs_right_sprite = global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_sprite;

	var head_offset = 0;
	var arm_offset = 0;
	var leg_offset = 0;

	// Instantiate Limb Variables
	var temp_arm_bbox_height = (sprite_get_bbox_bottom(temp_arms_left_sprite) - sprite_get_yoffset(temp_arms_left_sprite));
	var temp_leg_bbox_height = (sprite_get_bbox_bottom(temp_legs_left_sprite) - sprite_get_yoffset(temp_legs_left_sprite));
	var temp_chest_bbox_top_height = (sprite_get_yoffset(temp_chest_top_sprite) - sprite_get_bbox_top(temp_chest_top_sprite));
	var temp_chest_bbox_center_height = (sprite_get_bbox_bottom(temp_chest_top_sprite) - sprite_get_yoffset(temp_chest_top_sprite)) + (sprite_get_yoffset(temp_chest_bot_sprite) - sprite_get_bbox_top(temp_chest_bot_sprite));
	var temp_chest_bbox_bot_height = (sprite_get_bbox_bottom(temp_chest_bot_sprite) - sprite_get_yoffset(temp_chest_bot_sprite));

	var temp_chest_top_height = (temp_leg_bbox_height * 2) + temp_chest_bbox_bot_height + temp_chest_bbox_center_height + temp_chest_bbox_top_height;

	var temp_leg_rotate_forward = unit_instance.image_xscale > 0 ? 90 : 45;
	var temp_leg_rotate_back = unit_instance.image_xscale > 0 ? -45 : -90;

	// Instantiate Limbs & Bodyparts
	var temp_ragdoll_struct = 
	{
	    head: noone,
	    left_forarm: noone,
	    left_upperarm: noone,
	    right_forearm: noone,
	    right_upperarm: noone,
	    chest: noone,
	    torso: noone,
	    left_upper_leg: noone,
	    left_lower_leg: noone,
	    right_upper_leg: noone,
	    right_lower_leg: noone
	};

	var temp_ragdoll_head_obj = instance_create_depth
	(
	    unit_instance.x, 
	    unit_instance.y - temp_chest_top_height + head_offset, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Head, 
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_head_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_head_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_head_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_head_emissivemap,
	        image_xscale: unit_instance.image_xscale
	    }
    );
    
	temp_ragdoll_struct.head = temp_ragdoll_head_obj;

	var temp_ragdoll_left_forearm_obj = instance_create_depth
	(
	    unit_instance.x - (arm_offset * unit_instance.image_xscale), 
	    unit_instance.y - temp_chest_top_height + temp_arm_bbox_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Arm,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_emissivemap,
	        image_index: 1,
	        image_xscale: -unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.left_forarm = temp_ragdoll_left_forearm_obj;

	var temp_ragdoll_left_upperarm_obj = instance_create_depth
	(
	    unit_instance.x - (arm_offset * unit_instance.image_xscale), 
	    unit_instance.y - temp_chest_top_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Arm,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_left_emissivemap,
	        image_index: 0,
	        image_xscale: -unit_instance.image_xscale,
	    }
	);
	
	temp_ragdoll_struct.left_upperarm = temp_ragdoll_left_upperarm_obj;

	var ragdoll_chest_top_obj = instance_create_depth
	(
	    unit_instance.x, 
	    unit_instance.y - temp_chest_top_height + temp_chest_bbox_top_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Chest,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_top_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_top_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_top_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_top_emissivemap,
	        image_xscale: unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.chest = ragdoll_chest_top_obj;

	var ragdoll_chest_bot_obj = instance_create_depth
	(
	    unit_instance.x, 
	    unit_instance.y - temp_chest_top_height + temp_chest_bbox_top_height + temp_chest_bbox_center_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Chest,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_bot_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_bot_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_bot_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_chest_bot_emissivemap,
	        image_xscale: unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.torso = ragdoll_chest_bot_obj;

	var ragdoll_leftleg1_obj = instance_create_depth
	(
	    unit_instance.x - leg_offset, 
	    unit_instance.y - (temp_leg_bbox_height * 2), 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Leg,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_emissivemap,
	        image_index: 0,
	        image_xscale: unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.left_upper_leg = ragdoll_leftleg1_obj;

	var ragdoll_rightleg1_obj = instance_create_depth
	(
	    unit_instance.x + leg_offset, 
	    unit_instance.y - (temp_leg_bbox_height * 2), 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Leg,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_emissivemap,
	        image_index: 0,
	        image_xscale: unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.right_upper_leg = ragdoll_rightleg1_obj;

	var ragdoll_leftleg2_obj = instance_create_depth
	(
	    unit_instance.x - leg_offset, 
	    unit_instance.y - temp_leg_bbox_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Leg,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_left_emissivemap,
	        image_index: 1,
	        image_xscale: unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.left_lower_leg = ragdoll_leftleg2_obj;

	var ragdoll_rightleg2_obj = instance_create_depth
	(
	    unit_instance.x + leg_offset, 
	    unit_instance.y - temp_leg_bbox_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Leg,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_leg_right_emissivemap,
	        image_index: 1,
	        image_xscale: unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.right_lower_leg = ragdoll_rightleg2_obj;

	var ragdoll_arm2bot_obj = instance_create_depth
	(
	    unit_instance.x + (arm_offset * unit_instance.image_xscale), 
	    unit_instance.y - temp_chest_top_height + temp_arm_bbox_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Arm,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_emissivemap,
	        image_index: 1,
	        image_xscale: -unit_instance.image_xscale
	    }
    );
    
	temp_ragdoll_struct.right_forearm = ragdoll_arm2bot_obj;

	var ragdoll_arm2top_obj = instance_create_depth
	(
	    unit_instance.x + (arm_offset * unit_instance.image_xscale), 
	    unit_instance.y - temp_chest_top_height, 
	    unit_instance.depth, 
	    oRagdollEntity_UnitBody_Arm,
	    {
	        layer: unit_instance.layer,
	        sub_layer_name: LightingEngineDefaultLayer,
	        sprite_index: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_sprite,
	        normal_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_normalmap,
	        metallicroughness_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_metallicroughnessmap,
	        emissive_map: global.unit_packs[unit_instance.unit_pack].ragdoll_arm_right_emissivemap,
	        image_index: 0,
	        image_xscale: -unit_instance.image_xscale
	    }
	);
	
	temp_ragdoll_struct.right_upperarm = ragdoll_arm2top_obj;

	// Instantiate Joints between Limbs
	physics_joint_revolute_create(temp_ragdoll_struct.head, temp_ragdoll_struct.chest, temp_ragdoll_struct.head.x, temp_ragdoll_struct.head.y, -45, 45, 1, 0, 0, 0, 0); 

	physics_joint_revolute_create(temp_ragdoll_left_upperarm_obj, temp_ragdoll_struct.chest, temp_ragdoll_left_upperarm_obj.x, temp_ragdoll_left_upperarm_obj.y, 0, 0, 0, 0, 0, 0, 0);
	physics_joint_revolute_create(temp_ragdoll_left_forearm_obj, temp_ragdoll_left_upperarm_obj, temp_ragdoll_left_forearm_obj.x, temp_ragdoll_left_forearm_obj.y, -(75 + (-unit_instance.image_xscale * 75)), (75 + (unit_instance.image_xscale * 75)), 1, 0, 0, 0, 0);

	physics_joint_revolute_create(ragdoll_arm2top_obj, temp_ragdoll_struct.chest, ragdoll_arm2top_obj.x, ragdoll_arm2top_obj.y, 0, 0, 0, 0, 0, 0, 0);
	physics_joint_revolute_create(ragdoll_arm2bot_obj, ragdoll_arm2top_obj, ragdoll_arm2bot_obj.x, ragdoll_arm2bot_obj.y, -(75 + (-unit_instance.image_xscale * 75)), (75 + (unit_instance.image_xscale * 75)), 1, 0, 0, 0, 0);

	physics_joint_revolute_create(temp_ragdoll_struct.chest, ragdoll_chest_bot_obj, temp_ragdoll_struct.chest.x, temp_ragdoll_struct.chest.y + (temp_chest_bbox_center_height / 2), -20, 20, 1, 0, 0, 0, 0);

	physics_joint_revolute_create(ragdoll_leftleg1_obj, ragdoll_chest_bot_obj, ragdoll_leftleg1_obj.x, ragdoll_leftleg1_obj.y, temp_leg_rotate_back, temp_leg_rotate_forward, 1, 0, 0, 0, 0);
	physics_joint_revolute_create(ragdoll_rightleg1_obj, ragdoll_chest_bot_obj, ragdoll_rightleg1_obj.x, ragdoll_rightleg1_obj.y, temp_leg_rotate_back, temp_leg_rotate_forward, 1, 0, 0, 0, 0);

	physics_joint_revolute_create(ragdoll_leftleg2_obj, ragdoll_leftleg1_obj, ragdoll_leftleg2_obj.x, ragdoll_leftleg2_obj.y, -(75 + (unit_instance.image_xscale * 75)), (75 + (unit_instance.image_xscale * -75)), 1, 0, 0, 0, 0);
	physics_joint_revolute_create(ragdoll_rightleg2_obj, ragdoll_rightleg1_obj, ragdoll_rightleg2_obj.x, ragdoll_rightleg2_obj.y, -(75 + (unit_instance.image_xscale * 75)), (75 + (unit_instance.image_xscale * -75)), 1, 0, 0, 0, 0);

	// Return Ragdoll UnitBody Limbs Struct
	return temp_ragdoll_struct;
}
