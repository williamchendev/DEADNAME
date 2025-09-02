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

// Destroy Unit's Inventory
for (var i = array_length(inventory_slots) - 1; i >= 0; i--)
{
	if (inventory_slots[i].item_instance != noone)
	{
		DELETE(inventory_slots[i].item_instance);
	}
}

array_clear(inventory_slots);

// Clean Up Unit's Platform DS List
ds_list_destroy(platform_list);
platform_list = -1;

// Clean Up Unit's Pathfinding Path DS List
if (!is_undefined(pathfinding_path))
{
	pathfinding_delete_path(pathfinding_path);
	pathfinding_path = undefined;
}
