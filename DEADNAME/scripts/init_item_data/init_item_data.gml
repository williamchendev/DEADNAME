/// init_item_data();
/// @description Establishes the global variables for all item data

/// ***Enums***
enum itemstats
{
	name,
	description,
	sprite_index,
	image_index,
	width_space,
	height_space,
	stack_limit,
	type,
	type_index
}

enum itemtypes
{
	consumable,
	weapon,
	ammo,
	key_item
}

/// ***Items***

// Null
global.item_data[0, itemstats.name] = "Empty";
global.item_data[0, itemstats.description] = "Empty";
global.item_data[0, itemstats.sprite_index] = sItems1x1;
global.item_data[0, itemstats.image_index] = 0;
global.item_data[0, itemstats.width_space] = 1;
global.item_data[0, itemstats.height_space] = 1;
global.item_data[0, itemstats.stack_limit] = 0;
global.item_data[0, itemstats.type] = "Empty";
global.item_data[0, itemstats.type_index] = 0;

// Debug Candy
global.item_data[1, itemstats.name] = "Debug Candy";
global.item_data[1, itemstats.description] = "It's a rare candy made to debug games.";
global.item_data[1, itemstats.sprite_index] = sItems1x1;
global.item_data[1, itemstats.image_index] = 0;
global.item_data[1, itemstats.width_space] = 1;
global.item_data[1, itemstats.height_space] = 1;
global.item_data[1, itemstats.stack_limit] = 1;
global.item_data[1, itemstats.type] = itemtypes.consumable;
global.item_data[1, itemstats.type_index] = 0;

// Granola Bar
global.item_data[2, itemstats.name] = "Granola Bar";
global.item_data[2, itemstats.description] = "It tastes gross but they're light and filling";
global.item_data[2, itemstats.sprite_index] = sItems1x1;
global.item_data[2, itemstats.image_index] = 1;
global.item_data[2, itemstats.width_space] = 1;
global.item_data[2, itemstats.height_space] = 1;
global.item_data[2, itemstats.stack_limit] = 4;
global.item_data[2, itemstats.type] = itemtypes.consumable;
global.item_data[2, itemstats.type_index] = 1;

// Trail Mix
global.item_data[3, itemstats.name] = "Trail Mix";
global.item_data[3, itemstats.description] = "An unfortunate blend of tasty chocolate and... raisins";
global.item_data[3, itemstats.sprite_index] = sItems2x2;
global.item_data[3, itemstats.image_index] = 0;
global.item_data[3, itemstats.width_space] = 2;
global.item_data[3, itemstats.height_space] = 2;
global.item_data[3, itemstats.stack_limit] = 1;
global.item_data[3, itemstats.type] = itemtypes.consumable;
global.item_data[3, itemstats.type_index] = 2;

// Baseball Bat
global.item_data[4, itemstats.name] = "Baseball Bat";
global.item_data[4, itemstats.description] = "Smmmmaaaaashhhhhhh!";
global.item_data[4, itemstats.sprite_index] = sItems4x1;
global.item_data[4, itemstats.image_index] = 1;
global.item_data[4, itemstats.width_space] = 4;
global.item_data[4, itemstats.height_space] = 1;
global.item_data[4, itemstats.stack_limit] = 1;
global.item_data[4, itemstats.type] = itemtypes.weapon;
global.item_data[4, itemstats.type_index] = 0;

// M14
global.item_data[5, itemstats.name] = "Marinda .308";
global.item_data[5, itemstats.description] = "Arkov's standard issue rifle, a traditon-bound old world firearm. The markings indicate it was manufactured in Rasa.";
global.item_data[5, itemstats.sprite_index] = sItems6x2;
global.item_data[5, itemstats.image_index] = 1;
global.item_data[5, itemstats.width_space] = 6;
global.item_data[5, itemstats.height_space] = 2;
global.item_data[5, itemstats.stack_limit] = 1;
global.item_data[5, itemstats.type] = itemtypes.weapon;
global.item_data[5, itemstats.type_index] = 1;

// FAL
global.item_data[6, itemstats.name] = "FAL-E";
global.item_data[6, itemstats.description] = "The right arm of the free world, now in burst fire";
global.item_data[6, itemstats.sprite_index] = sItems6x2;
global.item_data[6, itemstats.image_index] = 2;
global.item_data[6, itemstats.width_space] = 6;
global.item_data[6, itemstats.height_space] = 2;
global.item_data[6, itemstats.stack_limit] = 1;
global.item_data[6, itemstats.type] = itemtypes.weapon;
global.item_data[6, itemstats.type_index] = 2;

// 308 Winchester Ammo
global.item_data[7, itemstats.name] = ".308 Winchester Ammo";
global.item_data[7, itemstats.description] = "";
global.item_data[7, itemstats.sprite_index] = sItems1x1;
global.item_data[7, itemstats.image_index] = 2;
global.item_data[7, itemstats.width_space] = 1;
global.item_data[7, itemstats.height_space] = 1;
global.item_data[7, itemstats.stack_limit] = 8;
global.item_data[7, itemstats.type] = itemtypes.ammo;
global.item_data[7, itemstats.type_index] = 0;

// M3 Grease Gun
global.item_data[8, itemstats.name] = "M3 Grease Gun";
global.item_data[8, itemstats.description] = "Shitty foreign sub machine gun";
global.item_data[8, itemstats.sprite_index] = sItems6x2;
global.item_data[8, itemstats.image_index] = 2;
global.item_data[8, itemstats.width_space] = 6;
global.item_data[8, itemstats.height_space] = 2;
global.item_data[8, itemstats.stack_limit] = 1;
global.item_data[8, itemstats.type] = itemtypes.weapon;
global.item_data[8, itemstats.type_index] = 3;

// Trench Shotgun
global.item_data[9, itemstats.name] = "Trench Gun";
global.item_data[9, itemstats.description] = "Shitty foreign shotgun";
global.item_data[9, itemstats.sprite_index] = sItems6x2;
global.item_data[9, itemstats.image_index] = 2;
global.item_data[9, itemstats.width_space] = 6;
global.item_data[9, itemstats.height_space] = 2;
global.item_data[9, itemstats.stack_limit] = 1;
global.item_data[9, itemstats.type] = itemtypes.weapon;
global.item_data[9, itemstats.type_index] = 4;

// Bolt Action Rifle
global.item_data[10, itemstats.name] = "Bolt Action Rifle";
global.item_data[10, itemstats.description] = "Antique Bullshit";
global.item_data[10, itemstats.sprite_index] = sItems6x2;
global.item_data[10, itemstats.image_index] = 2;
global.item_data[10, itemstats.width_space] = 6;
global.item_data[10, itemstats.height_space] = 2;
global.item_data[10, itemstats.stack_limit] = 1;
global.item_data[10, itemstats.type] = itemtypes.weapon;
global.item_data[10, itemstats.type_index] = 5;

// Bolt Action Rifle
global.item_data[11, itemstats.name] = "Arkovian Revolver";
global.item_data[11, itemstats.description] = "3 Shot Garbage";
global.item_data[11, itemstats.sprite_index] = sItems6x2;
global.item_data[11, itemstats.image_index] = 2;
global.item_data[11, itemstats.width_space] = 6;
global.item_data[11, itemstats.height_space] = 2;
global.item_data[11, itemstats.stack_limit] = 1;
global.item_data[11, itemstats.type] = itemtypes.weapon;
global.item_data[11, itemstats.type_index] = 6;

// Grenade Launcher
global.item_data[12, itemstats.name] = "M79";
global.item_data[12, itemstats.description] = "Kuthunk";
global.item_data[12, itemstats.sprite_index] = sItems6x2;
global.item_data[12, itemstats.image_index] = 2;
global.item_data[12, itemstats.width_space] = 6;
global.item_data[12, itemstats.height_space] = 2;
global.item_data[12, itemstats.stack_limit] = 1;
global.item_data[12, itemstats.type] = itemtypes.weapon;
global.item_data[12, itemstats.type_index] = 7;

// Corso Rifle
global.item_data[13, itemstats.name] = "Corso Rifle";
global.item_data[13, itemstats.description] = "It works";
global.item_data[13, itemstats.sprite_index] = sItems6x2;
global.item_data[13, itemstats.image_index] = 1;
global.item_data[13, itemstats.width_space] = 6;
global.item_data[13, itemstats.height_space] = 2;
global.item_data[13, itemstats.stack_limit] = 1;
global.item_data[13, itemstats.type] = itemtypes.weapon;
global.item_data[13, itemstats.type_index] = 8;

// Item Slot 14
global.item_data[14, itemstats.name] = "Dernos Needle Rifle";
global.item_data[14, itemstats.description] = "Shit";
global.item_data[14, itemstats.sprite_index] = sItems6x2;
global.item_data[14, itemstats.image_index] = 0;
global.item_data[14, itemstats.width_space] = 6;
global.item_data[14, itemstats.height_space] = 2;
global.item_data[14, itemstats.stack_limit] = 1;
global.item_data[14, itemstats.type] = itemtypes.weapon;
global.item_data[14, itemstats.type_index] = 9;

// Item Slot 15
global.item_data[15, itemstats.name] = "DebugItem15";
global.item_data[15, itemstats.description] = "Debug";
global.item_data[15, itemstats.sprite_index] = sItems2x2;
global.item_data[15, itemstats.image_index] = 0;
global.item_data[15, itemstats.width_space] = 2;
global.item_data[15, itemstats.height_space] = 2;
global.item_data[15, itemstats.stack_limit] = 1;
global.item_data[15, itemstats.type] = itemtypes.key_item;
global.item_data[15, itemstats.type_index] = 0;

// Item Slot 16
global.item_data[16, itemstats.name] = "DebugItem16";
global.item_data[16, itemstats.description] = "Debug";
global.item_data[16, itemstats.sprite_index] = sItems2x2;
global.item_data[16, itemstats.image_index] = 0;
global.item_data[16, itemstats.width_space] = 2;
global.item_data[16, itemstats.height_space] = 2;
global.item_data[16, itemstats.stack_limit] = 1;
global.item_data[16, itemstats.type] = itemtypes.key_item;
global.item_data[16, itemstats.type_index] = 0;

// Item Slot 17
global.item_data[17, itemstats.name] = "DebugItem17";
global.item_data[17, itemstats.description] = "Debug";
global.item_data[17, itemstats.sprite_index] = sItems2x2;
global.item_data[17, itemstats.image_index] = 0;
global.item_data[17, itemstats.width_space] = 2;
global.item_data[17, itemstats.height_space] = 2;
global.item_data[17, itemstats.stack_limit] = 1;
global.item_data[17, itemstats.type] = itemtypes.key_item;
global.item_data[17, itemstats.type_index] = 0;

// Item Slot 18
global.item_data[18, itemstats.name] = "DebugItem18";
global.item_data[18, itemstats.description] = "Debug";
global.item_data[18, itemstats.sprite_index] = sItems2x2;
global.item_data[18, itemstats.image_index] = 0;
global.item_data[18, itemstats.width_space] = 2;
global.item_data[18, itemstats.height_space] = 2;
global.item_data[18, itemstats.stack_limit] = 1;
global.item_data[18, itemstats.type] = itemtypes.key_item;
global.item_data[18, itemstats.type_index] = 0;

// Item Slot 19
global.item_data[19, itemstats.name] = "DebugItem19";
global.item_data[19, itemstats.description] = "Debug";
global.item_data[19, itemstats.sprite_index] = sItems2x2;
global.item_data[19, itemstats.image_index] = 0;
global.item_data[19, itemstats.width_space] = 2;
global.item_data[19, itemstats.height_space] = 2;
global.item_data[19, itemstats.stack_limit] = 1;
global.item_data[19, itemstats.type] = itemtypes.key_item;
global.item_data[19, itemstats.type_index] = 0;