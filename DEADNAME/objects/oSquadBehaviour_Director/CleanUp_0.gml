/// @description Insert description here
// You can write your code in this editor

//
ds_map_destroy(squad_ids_map);
squad_ids_map = -1;

ds_map_destroy(squad_factions_map);
squad_factions_map = -1;

//
ds_list_destroy(squad_exists_list);
squad_exists_list = -1;

ds_list_destroy(squad_id_list);
squad_id_list = -1;

ds_list_destroy(squad_type_list);
squad_type_list = -1;

ds_list_destroy(squad_faction_list);
squad_faction_list = -1;

ds_list_destroy(squad_behaviour_list);
squad_behaviour_list = -1;

ds_list_destroy(squad_luck_list);
squad_luck_list = -1;

ds_list_destroy(squad_leader_list);
squad_leader_list = -1;

ds_list_destroy(squad_units_list);
squad_units_list = -1;
