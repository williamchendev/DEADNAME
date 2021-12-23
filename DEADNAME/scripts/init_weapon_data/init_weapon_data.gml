/// init_weapon_data();
/// @description Establishes the global variables for all weapon item data

/// ***Enums***
enum weaponstats {
	action_title,
	image_index,
	object,
	type,
	ammo
}

enum weapontype {
	melee,
	firearm
}

/// ***Weapons***

// Baseball Bat
global.weapon_data[0, weaponstats.action_title] = "Use Baseball Bat";
global.weapon_data[0, weaponstats.image_index] = 4;
global.weapon_data[0, weaponstats.object] = oMelee;
global.weapon_data[0, weaponstats.type] = weapontype.melee;
global.weapon_data[0, weaponstats.ammo] = -1;

// M14
global.weapon_data[1, weaponstats.action_title] = "Marinda .308";
global.weapon_data[1, weaponstats.image_index] = 5;
global.weapon_data[1, weaponstats.object] = oGun_M14;
global.weapon_data[1, weaponstats.type] = weapontype.firearm;
global.weapon_data[1, weaponstats.ammo] = 7;

// FAL
global.weapon_data[2, weaponstats.action_title] = "FAL-E";
global.weapon_data[2, weaponstats.image_index] = 5;
global.weapon_data[2, weaponstats.object] = oGun_FAL;
global.weapon_data[2, weaponstats.type] = weapontype.firearm;
global.weapon_data[2, weaponstats.ammo] = 7;

// M3
global.weapon_data[3, weaponstats.action_title] = "M3 Grease Gun";
global.weapon_data[3, weaponstats.image_index] = 5;
global.weapon_data[3, weaponstats.object] = oGun_M3;
global.weapon_data[3, weaponstats.type] = weapontype.firearm;
global.weapon_data[3, weaponstats.ammo] = 7;

// Trench Gun
global.weapon_data[4, weaponstats.action_title] = "Trench Gun";
global.weapon_data[4, weaponstats.image_index] = 5;
global.weapon_data[4, weaponstats.object] = oGun_Shotgun;
global.weapon_data[4, weaponstats.type] = weapontype.firearm;
global.weapon_data[4, weaponstats.ammo] = 7;

// Bolt Action Rifle
global.weapon_data[5, weaponstats.action_title] = "Bolt Action Rifle";
global.weapon_data[5, weaponstats.image_index] = 5;
global.weapon_data[5, weaponstats.object] = oGun_BoltAction;
global.weapon_data[5, weaponstats.type] = weapontype.firearm;
global.weapon_data[5, weaponstats.ammo] = 7;

// Bolt Action Rifle
global.weapon_data[6, weaponstats.action_title] = "Revolver";
global.weapon_data[6, weaponstats.image_index] = 5;
global.weapon_data[6, weaponstats.object] = oGun_Revolver;
global.weapon_data[6, weaponstats.type] = weapontype.firearm;
global.weapon_data[6, weaponstats.ammo] = 7;

// Grenade Launcher
global.weapon_data[7, weaponstats.action_title] = "Grenade Launcher";
global.weapon_data[7, weaponstats.image_index] = 5;
global.weapon_data[7, weaponstats.object] = oGun_GrenadeLauncher;
global.weapon_data[7, weaponstats.type] = weapontype.firearm;
global.weapon_data[7, weaponstats.ammo] = 7;