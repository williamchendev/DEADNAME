/// @description Unit AI Initialization
// The variable and settings initialization for the Unit AI

// Inherit the parent event
event_inherited();

// Ai Behaviour Settings
ai_hunt = true;
ai_patrol = false;
ai_command = false;
ai_follow = false;

// Ai Inspect Settings
ai_inspect_radius = 48;

// Ai Follow Settings
ai_follow_start_radius = 64;
ai_follow_stop_radius = 48;

ai_follow_combat_endure_time = 40;

// Ai Patrol Settings
ai_patrol_id = "unassigned";

ai_patrol_sustain_time = 120;
ai_patrol_sustain_random_time = 60;
ai_patrol_inactive_time = 120;

// Ai Follow Variables
ai_follow_unit = noone;
ai_follow_active = false;
ai_follow_combat_timer = 0;

// Ai Path Variables
ai_pathing_delay = 10;
ai_pathing_timer = 0;

// Ai Patrol Variables
ai_patrol_active = true;
ai_patrol_inactive_timer = 0;

ai_patrol_node = noone;
ai_patrol_sustain_timer = 0;