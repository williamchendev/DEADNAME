/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
player_squad = true;

// Create Squad ID
squad_id = "auto_generated_squad_" + string(game_manager.generated_squads + 1);
game_manager.generated_squads++;

// Assemble Squad
var temp_squad_list = ds_list_create();
var temp_squad_num = instance_place_list(x, y, oUnit, temp_squad_list, false);
for (var i = 0; i < temp_squad_num; i++) {
	var temp_squad_unit_inst = ds_list_find_value(temp_squad_list, i);
	temp_squad_unit_inst.squad_id = squad_id;
	ds_list_add(squad_units_list, temp_squad_unit_inst);
}
ds_list_destroy(temp_squad_list);

// Reset Sprite Index
sprite_index = sSquadIcons;
image_xscale = 1;
image_yscale = 1;
image_angle = 0;