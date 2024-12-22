/// @description Unit Clean Up Event
// Cleans up the variables and DS Structures of the Unit on the Unit's Destroy Event

// Destroy Unit's Limbs
if (limb_primary_arm != noone)
{
	// Left Hand
	DELETE(limb_primary_arm);
}

if (limb_secondary_arm != noone)
{
	// Right Hand
	DELETE(limb_secondary_arm);
}

// Destroy Unit's Weapons
if (weapon_equipped != noone)
{
	DELETE(weapon_equipped);
}

// Clean Up Unit's Platform DS List
ds_list_destroy(platform_list);
platform_list = -1;
