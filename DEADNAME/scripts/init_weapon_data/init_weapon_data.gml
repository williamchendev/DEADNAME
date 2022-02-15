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

// Empty
global.weapon_data[0, weaponstats.action_title] = "Default Action";
global.weapon_data[0, weaponstats.image_index] = 0;
global.weapon_data[0, weaponstats.object] = noone;
global.weapon_data[0, weaponstats.type] = weapontype.firearm;
global.weapon_data[0, weaponstats.ammo] = -1;

// Dernov Needle Rifle
global.weapon_data[1, weaponstats.action_title] = "Dernov Needle Rifle";
global.weapon_data[1, weaponstats.image_index] = 5;
global.weapon_data[1, weaponstats.object] = oGun_Arkov_DernosNeedleRifle;
global.weapon_data[1, weaponstats.type] = weapontype.firearm;
global.weapon_data[1, weaponstats.ammo] = 6;

// Corso Bolt Action Rifle
global.weapon_data[2, weaponstats.action_title] = "Corso Bolt Action Rifle";
global.weapon_data[2, weaponstats.image_index] = 5;
global.weapon_data[2, weaponstats.object] = oGun_Arkov_CorsoRifle;
global.weapon_data[2, weaponstats.type] = weapontype.firearm;
global.weapon_data[2, weaponstats.ammo] = 8;

// Paragon Self Loading Rifle
global.weapon_data[3, weaponstats.action_title] = "Paragon Self Loading Rifle";
global.weapon_data[3, weaponstats.image_index] = 5;
global.weapon_data[3, weaponstats.object] = oGun_Arkov_ParagonRifle;
global.weapon_data[3, weaponstats.type] = weapontype.firearm;
global.weapon_data[3, weaponstats.ammo] = 10;

// Arkov FAL
global.weapon_data[4, weaponstats.action_title] = "LONGSWORD";
global.weapon_data[4, weaponstats.image_index] = 5;
global.weapon_data[4, weaponstats.object] = oGun_Arkov_FAL;
global.weapon_data[4, weaponstats.type] = weapontype.firearm;
global.weapon_data[4, weaponstats.ammo] = 10;

// Oiler Submachine Gun
global.weapon_data[5, weaponstats.action_title] = "OilerSubMachineGun";
global.weapon_data[5, weaponstats.image_index] = 5;
global.weapon_data[5, weaponstats.object] = oGun_BlackMarket_OilerSubmachineGun;
global.weapon_data[5, weaponstats.type] = weapontype.firearm;
global.weapon_data[5, weaponstats.ammo] = 13;

// Planetside Revolver
global.weapon_data[6, weaponstats.action_title] = "Planetside Revolver";
global.weapon_data[6, weaponstats.image_index] = 5;
global.weapon_data[6, weaponstats.object] = oGun_BlackMarket_PlanetsideRevolver;
global.weapon_data[6, weaponstats.type] = weapontype.firearm;
global.weapon_data[6, weaponstats.ammo] = 15;

// Imperial Grenade Launcher
global.weapon_data[7, weaponstats.action_title] = "Grenade Launcher";
global.weapon_data[7, weaponstats.image_index] = 5;
global.weapon_data[7, weaponstats.object] = oGun_Arkov_ImperialGrenadeLauncher;
global.weapon_data[7, weaponstats.type] = weapontype.firearm;
global.weapon_data[7, weaponstats.ammo] = 17;

// Arkovian Devotion Shotgun
global.weapon_data[8, weaponstats.action_title] = "Devotion Shotgun";
global.weapon_data[8, weaponstats.image_index] = 5;
global.weapon_data[8, weaponstats.object] = oGun_Arkov_DevotionShotgun;
global.weapon_data[8, weaponstats.type] = weapontype.firearm;
global.weapon_data[8, weaponstats.ammo] = 19;

// Bolt Action
global.weapon_data[9, weaponstats.action_title] = "Bolt Action";
global.weapon_data[9, weaponstats.image_index] = 5;
global.weapon_data[9, weaponstats.object] = oGun_BoltAction;
global.weapon_data[9, weaponstats.type] = weapontype.firearm;
global.weapon_data[9, weaponstats.ammo] = 21;