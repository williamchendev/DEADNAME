/// @description Ragdoll Entity Init Event
// Initializes variables for the Ragdoll Entity Object

// Lighting Object Inherited Event
event_inherited();

// Physics Movement Variables
held = false;

// Physics Culling Variables
physics_enabled = true;

// Deltatime Physics Variables
old_delta_time = frame_delta;

phy_speed_old_x = 0;
phy_speed_old_y = 0;

phy_speed_x_bank = 0;
phy_speed_y_bank = 0;

phy_linear_velocity_x = is_undefined(phy_linear_velocity_x) ? 0 : phy_linear_velocity_x;
phy_linear_velocity_y = is_undefined(phy_linear_velocity_y) ? 0 : phy_linear_velocity_y;
