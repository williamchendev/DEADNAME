/// @description Prop Animation Combat Action Initialization
// Initializes the Prop Animation Combat Action for Celestial Simulator Behaviour and Rendering

// Prop Animation Settings
image_speed = 0;

// Prop Animation Variables
animation_image_value = 0;
animation_image_count = sprite_get_number(sprite_index);
animation_speed = sprite_get_speed_real(sprite_index);

// Calculate Prop Animation Combat Action Duration
action_duration = (animation_loop_count * animation_image_count) / animation_speed;

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.PropAnimation;

