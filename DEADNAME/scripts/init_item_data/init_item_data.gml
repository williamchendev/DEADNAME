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

// Debug Item 1
global.item_data[1, itemstats.name] = "Debug Item 1";
global.item_data[1, itemstats.description] = "Placeholder Object";
global.item_data[1, itemstats.sprite_index] = sItems1x1;
global.item_data[1, itemstats.image_index] = 0;
global.item_data[1, itemstats.width_space] = 1;
global.item_data[1, itemstats.height_space] = 1;
global.item_data[1, itemstats.stack_limit] = 1;
global.item_data[1, itemstats.type] = itemtypes.key_item;
global.item_data[1, itemstats.type_index] = 0;

// Debug Item 2
global.item_data[2, itemstats.name] = "Debug Item 2";
global.item_data[2, itemstats.description] = "Placeholder Object";
global.item_data[2, itemstats.sprite_index] = sItems1x1;
global.item_data[2, itemstats.image_index] = 0;
global.item_data[2, itemstats.width_space] = 1;
global.item_data[2, itemstats.height_space] = 1;
global.item_data[2, itemstats.stack_limit] = 1;
global.item_data[2, itemstats.type] = itemtypes.key_item;
global.item_data[2, itemstats.type_index] = 0;

// Debug Item 3
global.item_data[3, itemstats.name] = "Debug Item 3";
global.item_data[3, itemstats.description] = "Placeholder Object";
global.item_data[3, itemstats.sprite_index] = sItems1x1;
global.item_data[3, itemstats.image_index] = 0;
global.item_data[3, itemstats.width_space] = 1;
global.item_data[3, itemstats.height_space] = 1;
global.item_data[3, itemstats.stack_limit] = 1;
global.item_data[3, itemstats.type] = itemtypes.key_item;
global.item_data[3, itemstats.type_index] = 0;

// Debug Item 4
global.item_data[4, itemstats.name] = "Debug Item 4";
global.item_data[4, itemstats.description] = "Placeholder Object";
global.item_data[4, itemstats.sprite_index] = sItems1x1;
global.item_data[4, itemstats.image_index] = 0;
global.item_data[4, itemstats.width_space] = 1;
global.item_data[4, itemstats.height_space] = 1;
global.item_data[4, itemstats.stack_limit] = 1;
global.item_data[4, itemstats.type] = itemtypes.key_item;
global.item_data[4, itemstats.type_index] = 0;

// Dernos Needle Rifle
global.item_data[5, itemstats.name] = "Dernos Needle Rifle";
global.item_data[5, itemstats.description] = "A single shot, needle fire rifle that fires Arkovian paper cartridges. An iconic weapon from the coconut conflicts that led to Arkov's internationalist attitudes.";
global.item_data[5, itemstats.sprite_index] = sItems6x2;
global.item_data[5, itemstats.image_index] = 0;
global.item_data[5, itemstats.width_space] = 6;
global.item_data[5, itemstats.height_space] = 2;
global.item_data[5, itemstats.stack_limit] = 1;
global.item_data[5, itemstats.type] = itemtypes.weapon;
global.item_data[5, itemstats.type_index] = 1;

// Beatle Brand Paper Cartridge
global.item_data[6, itemstats.name] = "BEATLE Brand Paper Cartridge";
global.item_data[6, itemstats.description] = "Despite foregoing blast powder made from cave insects, the Beatle Company proudly retains its nostalgic logo on this neat white box of black powder ammunition.";
global.item_data[6, itemstats.sprite_index] = sItems1x1;
global.item_data[6, itemstats.image_index] = 0;
global.item_data[6, itemstats.width_space] = 1;
global.item_data[6, itemstats.height_space] = 1;
global.item_data[6, itemstats.stack_limit] = 6;
global.item_data[6, itemstats.type] = itemtypes.ammo;
global.item_data[6, itemstats.type_index] = 0;

// Corso Bolt Action Rifle
global.item_data[7, itemstats.name] = "Corso Bolt Action Rifle";
global.item_data[7, itemstats.description] = "A five shot, rifle that fires the Arkovian .01ars standard. Like the river that shares its name, the Corso evokes the ferocity of frigid rapids cutting through mountains and rocks on its path to the sea.";
global.item_data[7, itemstats.sprite_index] = sItems6x2;
global.item_data[7, itemstats.image_index] = 1;
global.item_data[7, itemstats.width_space] = 6;
global.item_data[7, itemstats.height_space] = 2;
global.item_data[7, itemstats.stack_limit] = 1;
global.item_data[7, itemstats.type] = itemtypes.weapon;
global.item_data[7, itemstats.type_index] = 2;

// Arkovian .01Arshin Standard Ammunition
global.item_data[8, itemstats.name] = "Arkovian .01Arshin Standard Ammunition";
global.item_data[8, itemstats.description] = "While the democratic coalition wanted a committee design, the Urta State Arsenal Chief Engineer found it much easier (and cost effective) to plagiarize surplus ammunition from age old holy wars.";
global.item_data[8, itemstats.sprite_index] = sItems1x1;
global.item_data[8, itemstats.image_index] = 4;
global.item_data[8, itemstats.width_space] = 1;
global.item_data[8, itemstats.height_space] = 1;
global.item_data[8, itemstats.stack_limit] = 5;
global.item_data[8, itemstats.type] = itemtypes.ammo;
global.item_data[8, itemstats.type_index] = 0;

// Paragon Self Loading Rifle
global.item_data[9, itemstats.name] = "The \'Paragon\' Self Loading Rifle";
global.item_data[9, itemstats.description] = "A five shot, magazine fed rifle that fires 7.62 NATO of ecclesiastical fame. Ironically the Arkovian war committee would adopt a modified old surplus rifle design despite rebuking self loaders as the edifice of violent fratricide.";
global.item_data[9, itemstats.sprite_index] = sItems6x2;
global.item_data[9, itemstats.image_index] = 2;
global.item_data[9, itemstats.width_space] = 6;
global.item_data[9, itemstats.height_space] = 2;
global.item_data[9, itemstats.stack_limit] = 1;
global.item_data[9, itemstats.type] = itemtypes.weapon;
global.item_data[9, itemstats.type_index] = 3;

// 7.62 NATO Firearm Ammunition
global.item_data[10, itemstats.name] = "7.62 NATO Firearm Ammunition";
global.item_data[10, itemstats.description] = "An antique of great significance to the scattered peoples of this continent. When the holy wars exhausted its supply they were once worth their weight in gold, now relegated as a keepsake of hard times.";
global.item_data[10, itemstats.sprite_index] = sItems1x1;
global.item_data[10, itemstats.image_index] = 3;
global.item_data[10, itemstats.width_space] = 1;
global.item_data[10, itemstats.height_space] = 1;
global.item_data[10, itemstats.stack_limit] = 2;
global.item_data[10, itemstats.type] = itemtypes.ammo;
global.item_data[10, itemstats.type_index] = 0;

// Burst Fire FAL Rifle
global.item_data[11, itemstats.name] = "LONGSWORD OF THE LEFT";
global.item_data[11, itemstats.description] = "Ancient evil given physical form. Forged of metal and polymer, heralds of conflict and misery.";
global.item_data[11, itemstats.sprite_index] = sItems6x2;
global.item_data[11, itemstats.image_index] = 3;
global.item_data[11, itemstats.width_space] = 6;
global.item_data[11, itemstats.height_space] = 2;
global.item_data[11, itemstats.stack_limit] = 1;
global.item_data[11, itemstats.type] = itemtypes.weapon;
global.item_data[11, itemstats.type_index] = 4;

// Oiler Stamped Submachine Gun
global.item_data[12, itemstats.name] = "Oiler Stamped Submachine Gun";
global.item_data[12, itemstats.description] = "An automatic sixteen round magazine fed submachine gun, manufactured by the black markets across the continent. Although crude in appearance, these guns last longer than the states that purchase them. Synonymous with illegal.";
global.item_data[12, itemstats.sprite_index] = sItems3x2;
global.item_data[12, itemstats.image_index] = 0;
global.item_data[12, itemstats.width_space] = 3;
global.item_data[12, itemstats.height_space] = 2;
global.item_data[12, itemstats.stack_limit] = 1;
global.item_data[12, itemstats.type] = itemtypes.weapon;
global.item_data[12, itemstats.type_index] = 5;

// Black Market Ammunition
global.item_data[13, itemstats.name] = "Black Market Pistol Caliber Ammunition";
global.item_data[13, itemstats.description] = "Standardization and Black Markets seem contradictory, but cheap tooling coupled with Cavass's generous national lend lease program meant anyone with a working knowledge of metallurgy could engage in production.";
global.item_data[13, itemstats.sprite_index] = sItems1x1;
global.item_data[13, itemstats.image_index] = 1;
global.item_data[13, itemstats.width_space] = 1;
global.item_data[13, itemstats.height_space] = 1;
global.item_data[13, itemstats.stack_limit] = 3;
global.item_data[13, itemstats.type] = itemtypes.ammo;
global.item_data[13, itemstats.type_index] = 0;

// Planetside Revolver
global.item_data[14, itemstats.name] = "Planetside Revolver";
global.item_data[14, itemstats.description] = "Back when weapons were still distinguished by origin, firearm engineers had a certain fondness for ineffective design. This revolver is a meditation on the purpose of violence.";
global.item_data[14, itemstats.sprite_index] = sItems2x1;
global.item_data[14, itemstats.image_index] = 0;
global.item_data[14, itemstats.width_space] = 2;
global.item_data[14, itemstats.height_space] = 1;
global.item_data[14, itemstats.stack_limit] = 1;
global.item_data[14, itemstats.type] = itemtypes.weapon;
global.item_data[14, itemstats.type_index] = 6;

// Arkovian Heavy Revolver Ammunition
global.item_data[15, itemstats.name] = "Arkovian Heavy Revolver Ammunition";
global.item_data[15, itemstats.description] = "The Arkovian Government, wary of the public's indifference towards the lethality of pistol caliber sidearms, committed themselves into a long term relationship with powerful handguns citing \'a man has a right to die\' when shot.";
global.item_data[15, itemstats.sprite_index] = sItems1x1;
global.item_data[15, itemstats.image_index] = 8;
global.item_data[15, itemstats.width_space] = 1;
global.item_data[15, itemstats.height_space] = 1;
global.item_data[15, itemstats.stack_limit] = 3;
global.item_data[15, itemstats.type] = itemtypes.ammo;
global.item_data[15, itemstats.type_index] = 0;

// Arkovian Grenade Launcher
global.item_data[16, itemstats.name] = "The \'Imperial\' Grenade Launcher";
global.item_data[16, itemstats.description] = "A single shot, break action grenade launcher. When Arkov consolidated as a nation it found itself overwhelmed by the mass migration to its cities. But with the influx of cheap explosives, the police quickly reasserted control.";
//It would appear that the Arkovian Government's allocated budget for alleviating poverty was embezzled and reinvested into indiscriminate homicide and war crimes... for all three years it took to develop this weapon's platform.
global.item_data[16, itemstats.sprite_index] = sItems4x2;
global.item_data[16, itemstats.image_index] = 0;
global.item_data[16, itemstats.width_space] = 4;
global.item_data[16, itemstats.height_space] = 2;
global.item_data[16, itemstats.stack_limit] = 1;
global.item_data[16, itemstats.type] = itemtypes.weapon;
global.item_data[16, itemstats.type_index] = 7;

// High-Explosive Grenade Launcher Ammunition
global.item_data[17, itemstats.name] = "HE Grenade Launcher Canister";
global.item_data[17, itemstats.description] = "High Explosive impact-detonated grenade. In order to survive their poverty, evicted farmers from southern lands turned their trades as merchants of death, scavenging forgotten derelicts among the inhospitable northern reach.";
//These unassuming teal cans command great reverence from their user, bestowing the terrifying and awesome power to unmake a human being. Usually in groups.
global.item_data[17, itemstats.sprite_index] = sItems1x1;
global.item_data[17, itemstats.image_index] = 9;
global.item_data[17, itemstats.width_space] = 1;
global.item_data[17, itemstats.height_space] = 1;
global.item_data[17, itemstats.stack_limit] = 2;
global.item_data[17, itemstats.type] = itemtypes.ammo;
global.item_data[17, itemstats.type_index] = 0;

// Arkovian Devoted Shotgun
global.item_data[18, itemstats.name] = "The \'Devotion\' Shotgun";
global.item_data[18, itemstats.description] = "A six round internal tube magazine, self loading shotgun. Mostly found slung on the backs of guard detail or the Capital's finest, this firearm was chosen for its compactness and urban discretion.";
global.item_data[18, itemstats.sprite_index] = sItems4x2;
global.item_data[18, itemstats.image_index] = 1;
global.item_data[18, itemstats.width_space] = 4;
global.item_data[18, itemstats.height_space] = 2;
global.item_data[18, itemstats.stack_limit] = 1;
global.item_data[18, itemstats.type] = itemtypes.weapon;
global.item_data[18, itemstats.type_index] = 8;

// Arkovian Shotgun Ammunition
global.item_data[19, itemstats.name] = "Arkovian Shotgun Rounds";
global.item_data[19, itemstats.description] = "While round hulls would normally be dyed red, law enforcement criticized this as state endorsement of communism.";
global.item_data[19, itemstats.sprite_index] = sItems1x1;
global.item_data[19, itemstats.image_index] = 6;
global.item_data[19, itemstats.width_space] = 1;
global.item_data[19, itemstats.height_space] = 1;
global.item_data[19, itemstats.stack_limit] = 6;
global.item_data[19, itemstats.type] = itemtypes.ammo;
global.item_data[19, itemstats.type_index] = 0;

// Bolt Action Gun
global.item_data[20, itemstats.name] = "Bolt Action Gun";
global.item_data[20, itemstats.description] = "It go bang";
global.item_data[20, itemstats.sprite_index] = sItems8x2;
global.item_data[20, itemstats.image_index] = 0;
global.item_data[20, itemstats.width_space] = 8;
global.item_data[20, itemstats.height_space] = 2;
global.item_data[20, itemstats.stack_limit] = 1;
global.item_data[20, itemstats.type] = itemtypes.weapon;
global.item_data[20, itemstats.type_index] = 9;

// Bolt Action Ammunition
global.item_data[21, itemstats.name] = "Bolt Action Ammunition";
global.item_data[21, itemstats.description] = "Debug";
global.item_data[21, itemstats.sprite_index] = sItems1x1;
global.item_data[21, itemstats.image_index] = 5;
global.item_data[21, itemstats.width_space] = 1;
global.item_data[21, itemstats.height_space] = 1;
global.item_data[21, itemstats.stack_limit] = 6;
global.item_data[21, itemstats.type] = itemtypes.ammo;
global.item_data[21, itemstats.type_index] = 0;