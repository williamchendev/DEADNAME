/// @description Inventory Initialization

// Settings
debug = false;
unit_id = noone;

no_placement = false;
no_placement_allow_id = -1;
hide_items = false;

console_input = false;

// Object Mode Variables
object_mode = false;

// Inventory Variables
inventory = noone;
inventory_stacks = noone;
inventory_width = 0;
inventory_height = 0;

inventory_cursor_xoffset = 0;
inventory_cursor_yoffset = 0;

inventory_other_swap = false;
inventory_other_swap_master = false
inventory_other_swap_master_obj = noone;
inventory_other_swap_sub_obj = noone;

// Inventory Weapon Variables
weapons = ds_list_create();
weapons_index = ds_list_create();

weapon_place_index = -1;
weapon_place_list = noone;
weapon_place_index_list = noone;

// Inventory GUI Mode Settings
inventory_grid_size = 16;
inventory_outline_size = 2;
inventory_offset_size = 6;

draw_lerp_spd = 0.15;
radial_spd = 0.0067;

// Inventory GUI Mode Variables
draw_inventory = false;
draw_inventory_open = false;

select_show_cursor = false;

select_place = false;
select_place_num = 0;

select_index = 0;
select_target_width = 1;
select_target_height = 1;

select_item_id = 0;
select_item_stacks = 0;
select_item_width = 0;
select_item_height = 0;
select_can_place = true;

select_xpos = 0;
select_ypos = 0;
select_width = 0;
select_height = 0;

draw_alpha = 0;
sin_val = 0;
draw_inventory_outline_size = 0;
draw_inventory_x = x;
draw_inventory_y = y;

draw_sprite_index = noone;

// Singleton
game_manager = instance_find(oGameManager, 0);