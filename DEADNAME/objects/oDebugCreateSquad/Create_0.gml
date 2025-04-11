/// @description Insert description here
// You can write your code in this editor

var temp_unit_array = array_create(0);

temp_unit_array[0] = undefined;
temp_unit_array[1] = instance_create_unit(x + 24, y, squad_unit_pack);
temp_unit_array[2] = instance_create_unit(x - 24, y, squad_unit_pack);
temp_unit_array[3] = instance_create_unit(x + 48, y, squad_unit_pack);
temp_unit_array[4] = instance_create_unit(x - 48, y, squad_unit_pack);
temp_unit_array[5] = instance_create_unit(x + 64, y, squad_unit_pack);
temp_unit_array[0] = instance_create_unit(x, y, squad_leader_unit_pack);

if (create_player_squad)
{
	temp_unit_array[0].player_input = true;
}

GameManager.squad_behaviour_director.create_squad(squad_id, SquadType.Infantry, squad_faction_id, temp_unit_array);

instance_destroy();