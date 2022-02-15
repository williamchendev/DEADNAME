/// @description Weapon Initialization
// Creates the settings and variables of the wepaon object

// Basic Lighting Setting
basic_old_depth = depth;
basic_reindex_depth = true;

// Instance Settings
game_manager = instance_find(oGameManager, 0);

active = true;

// Weapon Settings
weapon_type = "firearm";
weapon_sprite = sArkov_ParagonRifle;

weapon_rotation = 0;
weapon_xscale = 1;
weapon_yscale = 1;

// Behaviour Settings
attack = false;
equip = false;
aiming = true;
click = false;

use_realdeltatime = false;

// Draw Settings
attack_show = true;

// Combat Settings
damage = 1;

// Behaviour Variables
aim = 0;
click_old = false;

weapon_reindex = false;
weapon_reindex_item_id = -1;
weapon_reindex_inventory = -1;

// Deltatime Physics Variables
old_delta_time = global.deltatime;

phy_speed_old_x = 0;
phy_speed_old_y = 0;

phy_speed_x_bank = 0;
phy_speed_y_bank = 0;

// Debug Settings
draw_debug = false;