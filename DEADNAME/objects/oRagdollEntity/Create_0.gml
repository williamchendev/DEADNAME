/// @description Ragdoll Entity Init Event
// Initializes variables for the Ragdoll Entity Object

// Lighting Object Inherited Event
event_inherited();

// Deltatime Physics Variables
old_delta_time = global.deltatime;

phy_speed_old_x = 0;
phy_speed_old_y = 0;

phy_speed_x_bank = 0;
phy_speed_y_bank = 0;