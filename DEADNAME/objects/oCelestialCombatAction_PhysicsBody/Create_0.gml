/// @description Physics Body Combat Action Initialization
// Initializes the Physics Body Combat Action for Celestial Simulator Behaviour and Rendering

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.PhysicsBody;

// Physics Body Image Settings
image_speed = 0;

// Physics Body Settings
physics_body_aerial_rotate_with_movement_direction = false;

// Physics Body Direction Variables
physics_body_xscale = 0;

// Physics Body Ground Variables
physics_body_ground_y = 0;
physics_body_grounded = false;
physics_body_grounded_image_index = irandom(sprite_get_number(physics_body_ground_sprite) - 1);

// Physics Body Velocity Variables
rot_prefetch(physics_body_direction);

physics_body_horizontal_velocity = physics_body_velocity * rot_point_x(1, 0);
physics_body_vertical_velocity = physics_body_velocity * rot_point_y(1, 0);

// Physics Body Position Variables
physics_body_old_x = x;
physics_body_old_y = y;

physics_body_new_x = x;
physics_body_new_y = y;

// Physics Body's Depth Variables
physics_body_vertical_depth_y = 0;
physics_body_vertical_depth_offset = 0;

