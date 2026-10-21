/// @description Prop Disappear Combat Action Initialization
// Initializes the Prop Disappear Combat Action for Celestial Simulator Behaviour and Rendering

// Calculate Prop Disappear Combat Action Duration
prop_disappear_phase_one_duration = disappear_duration + blink_duration * 3;
prop_disappear_phase_two_duration = disappear_duration + blink_duration * 2;
prop_disappear_phase_three_duration = disappear_duration + blink_duration;

action_duration = disappear_duration + blink_duration * 4;

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.PropDisappear;

