//
enum CelestialUnitBehaviourType
{
	None,
	Attack,
	Regroup,
	Hunt,
	Patrol,
	Garrison,
	Retreat
}

enum CelestialUnitTerrainType
{
	Land,
	Air,
	Sea
}

//
function celestial_unit_attack_stat_to_value_conversion(attack_stat)
{
	// Damage Reference - 1 damage is like getting a concussion from being hit with a baseball bat
	
	//
	switch (attack_stat)
	{
		case 1:
			// Pistol Round
			return 3;
		case 2:
			// Full-Sized Rifle Round
			return 5;
		case 3:
			// Mortar Shell / Small Explosive
			return 10;
		case 4:
			// Artillery Shell
			return 14;
		case 5:
			// Anti Armor Round
			return 17;
		case 6:
			// Anti Armor Round
			return 20;
		case 7:
			// Large Artillery Shell
			return 23;
		case 8:
			// Very Large Artillery Shell
			return 28;
		case 9:
			// Bunker Buster Bomb
			return 32;
		case 10:
			// Fictional Bullshit
			return 42;
		case 11:
			// Fictional Bullshit
			return 54;
		case 12:
			// Fictional Bullshit
			return 64;
	}
	
	//
	return 1;
}

function celestial_unit_armor_stat_to_value_conversion(armor_stat)
{
	// Damage Reference - 1 damage is like getting a concussion from being hit with a baseball bat
	
	//
	switch (armor_stat)
	{
		case 1:
			// Light Body Armor (Protective Cladding and Improvised Civillian Armored Clothing)
			return 2;
		case 2:
			// Heavy Body Armor (Anti-Terrorism Small Arms Stopping Armored Plate Carriers & Militarized Police Armor)
			return 4;
		case 3:
			// Light (Improvised) Defensive Structures - Wood Material Fixtures & Sandbags
			// Light Aircraft
			return 8;
		case 4:
			// Medium Defensive Structures - Unhardened Civilian Buildings & Infrustructure
			// Infantry with Fictional Power Armor
			// Armored Cars & Light Tanks
			// Medium Aircraft
			return 12;
		case 5:
			// Medium Tanks
			// Heavy Aircraft
			return 15;
		case 6:
			// Heavy Tanks
			return 18;
		case 7:
			// Heavy Defensive Structures - Hardened Concrete Infrustructure
			return 21;
		case 8:
			// Super Heavy Defensive Structures - Steel clad reinforced Concrete Infrustructure
			return 26;
		case 9:
			// Fictional Bullshit
			return 30;
		case 10:
			// Fictional Bullshit
			return 40;
		case 11:
			// Fictional Bullshit
			return 50;
		case 12:
			// Fictional Bullshit
			return 60;
	}
	
	//
	return 0;
}

//
function celestial_unit_add_subunit(celestial_unit, celestial_subunit)
{
	//
	array_push(celestial_unit.sub_units, celestial_subunit);
	
	//
	celestial_subunit.unit_instance = celestial_unit;
}

