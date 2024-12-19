/// @description Platform Update Event
// performs all the calculations for the platform update event

// Update Unit List
for (var i = 0; i < ds_list_size(units); i++) 
{
	var temp_unit = ds_list_find_value(units, i);
	
	if (!instance_exists(temp_unit)) 
	{
		ds_list_delete(units, ds_list_find_index(units, temp_unit.id));
	}
	else if (temp_unit.y > y + 1) 
	{
		ds_list_delete(temp_unit.platform_list, ds_list_find_index(temp_unit.platform_list, id));
		ds_list_delete(units, ds_list_find_index(units, temp_unit.id));
	}
}

// Unit Collision Check
ds_list_clear(collision_units_list);

var unit_num = collision_rectangle_list(x, y - 32, x + sprite_width, y, oUnit, false, true, collision_units_list, false);

if (unit_num > 0) 
{
	// Adds Units that are not apart of the list of indexed units if they touch the platform
	for (var i = 0; i < ds_list_size(collision_units_list); i++) 
	{
		var temp_unit = ds_list_find_value(collision_units_list, i);
		
		if (ds_list_find_index(units, temp_unit.id) == -1) 
		{
			if (temp_unit.y <= y + 1 and temp_unit.y_velocity >= 0) 
			{
				ds_list_add(temp_unit.platform_list, id);
				ds_list_add(units, temp_unit.id);
			}
		}
	}
}