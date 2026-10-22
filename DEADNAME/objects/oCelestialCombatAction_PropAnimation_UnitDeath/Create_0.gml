/// @description Prop Animation Unit Death Combat Action Initialization
// Initializes the Prop Animation Unit Death Combat Action for Celestial Simulator Behaviour and Rendering

// Prop Animation Combat Action Initialization Behaviour
event_inherited();

// Combat Action Functions
combat_action_end = function()
{
	// Establish Physics Body Struct
	var temp_physics_body_struct = { physics_body_direction: 90 - (image_xscale * 90), physics_body_velocity: random_range(2, 3) };
	
	// Instantiate Physics Body Instance
	var temp_physics_body_instance = instance_create_depth(x, y, 0, oCelestialCombatAction_PhysicsBody_FaceDown, temp_physics_body_struct);
	
	// Index Physics Body's Combat Action Instance within the Celestial Battle's Combat Actions Array
	array_push(battle_instance.battle_combat_actions, temp_physics_body_instance);
	temp_physics_body_instance.battle_instance = battle_instance;
	
	// Update Physics Body Color
	temp_physics_body_instance.image_blend = image_blend;
	
	// Update Physics Body Item Facing Direction
	temp_physics_body_instance.image_xscale = image_xscale;
	temp_physics_body_instance.physics_body_xscale = image_xscale;
	
	// Update Physics Body Facing Ground Y Level
	temp_physics_body_instance.physics_body_ground_y = y;
	
	// Update Physics Body's Vertical Depth
	temp_physics_body_instance.vertical_depth_y = y;
	temp_physics_body_instance.vertical_depth_offset = 2;
}

