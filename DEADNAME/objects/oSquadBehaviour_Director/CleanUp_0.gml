/// @description Director Cleanup
// Destroys any unnecessary Data Structures used by the Director previously

// Destroy Squad DS Maps
ds_map_destroy(squad_ids_map);
squad_ids_map = -1;

// Destroy Faction DS Maps
ds_map_destroy(faction_ids_map);
faction_ids_map = -1;

ds_map_destroy(factions_squad_ids_map);
factions_squad_ids_map = -1;

// Destroy Squad DS Lists
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

ds_list_destroy(squad_sub_behaviour_list);
squad_sub_behaviour_list = -1;

ds_list_destroy(squad_movement_list);
squad_movement_list = -1;

ds_list_destroy(squad_movement_target_x_list);
squad_movement_target_x_list = -1;

ds_list_destroy(squad_movement_target_y_list);
squad_movement_target_y_list = -1;

ds_list_destroy(squad_sight_active_list);
squad_sight_active_list = -1;

ds_list_destroy(squad_sight_value_list);
squad_sight_value_list = -1;

ds_list_destroy(squad_sight_calculation_delay_list);
squad_sight_calculation_delay_list = -1;

ds_list_destroy(squad_luck_list);
squad_luck_list = -1;

ds_list_destroy(squad_properties_list);
squad_properties_list = -1;

ds_list_destroy(squad_leader_list);
squad_leader_list = -1;

ds_list_destroy(squad_units_list);
squad_units_list = -1;

// Destroy Faction DS Lists
ds_list_destroy(faction_id_list);
faction_id_list = -1;

ds_list_destroy(faction_allies_list);
faction_allies_list = -1;

ds_list_destroy(faction_enemies_list);
faction_enemies_list = -1;
