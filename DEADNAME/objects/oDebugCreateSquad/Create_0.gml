/// @description Insert description here
// You can write your code in this editor

var temp_unit_array = array_create(0);

temp_unit_array[0] = undefined;
for (var i = 1; i < squad_size; i++)
{
	temp_unit_array[i] = instance_create_unit(x, y, squad_unit_pack);
}
temp_unit_array[0] = instance_create_unit(x, y, squad_leader_unit_pack);

if (create_player_squad)
{
	temp_unit_array[0].player_input = true;
}

GameManager.squad_behaviour_director.create_squad(squad_id, SquadType.Infantry, squad_faction_id, temp_unit_array);

instance_destroy();