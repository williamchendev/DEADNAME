/// @description Adobe House Update
// Calculates the behaviour of the Adobe House

// Check if Unit that is controlled by the Player is colliding with the House
var temp_unit_exists = false;
var temp_unit_list = ds_list_create();
var temp_unit_number = instance_place_list(floor(x), floor(y), oUnit, temp_unit_list, false);

for (var i = 0; i < temp_unit_number; i++) 
{
	var temp_unit_inst = ds_list_find_value(temp_unit_list, i);
	
	if (temp_unit_inst.player_input) 
	{
		temp_unit_exists = true;
		break;
	}
}

ds_list_destroy(temp_unit_list);

// Adobe House Front Becomes Transparent during Unit Collision
alpha_value = temp_unit_exists ? 0 : 1;

// Set House Objects to have same Transparency as House
image_alpha = temp_unit_exists ? 0 : 1;
house_front.image_alpha = temp_unit_exists ? 0 : 1;
house_door.image_alpha = temp_unit_exists ? 0.7 : 1;
house_ladder.image_alpha = temp_unit_exists ? 0.6 : 1;
