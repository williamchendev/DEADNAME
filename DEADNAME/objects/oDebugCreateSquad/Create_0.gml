/// @description Insert description here
// You can write your code in this editor

var temp_unit_array = array_create(0);

temp_unit_array[0] = undefined;
temp_unit_array[1] = instance_create_unit(x + 24, y, 0);
temp_unit_array[2] = instance_create_unit(x - 24, y, 0);
temp_unit_array[3] = instance_create_unit(x + 48, y, 0);
temp_unit_array[4] = instance_create_unit(x - 48, y, 0);
temp_unit_array[5] = instance_create_unit(x + 64, y, 0);
temp_unit_array[0] = instance_create_unit(x, y, 3);

GameManager.squad_behaviour_director.create_squad("temp", SquadType.Infantry, "Moralist", temp_unit_array);

instance_destroy();