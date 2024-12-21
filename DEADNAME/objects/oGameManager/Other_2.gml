/// @description Game Resolution & Settings

// Resolution
surface_resize(application_surface, game_width, game_height);
window_set_size(game_width * game_scale, game_height * game_scale);
window_center();

// Sleep Margin
display_set_timing_method(tm_sleep);
display_set_sleep_margin(20);

// Vsync
display_reset(0, true);

//
for (var i = 0; i < array_length(global.unit_packs); i++)
{
	//
	global.unit_packs[i].idle_normalmap_spritepack = spritepack_get_uvs_transformed(global.unit_packs[i].idle_sprite, global.unit_packs[i].idle_normalmap);
	global.unit_packs[i].walk_normalmap_spritepack = spritepack_get_uvs_transformed(global.unit_packs[i].walk_sprite, global.unit_packs[i].walk_normalmap);
	global.unit_packs[i].jump_normalmap_spritepack = spritepack_get_uvs_transformed(global.unit_packs[i].jump_sprite, global.unit_packs[i].jump_normalmap);
	global.unit_packs[i].aim_normalmap_spritepack = spritepack_get_uvs_transformed(global.unit_packs[i].aim_sprite, global.unit_packs[i].aim_normalmap);
	global.unit_packs[i].aim_walk_normalmap_spritepack = spritepack_get_uvs_transformed(global.unit_packs[i].aim_walk_sprite, global.unit_packs[i].aim_walk_normalmap);
}

//
for (var i = 0; i < array_length(global.weapon_packs); i++)
{
	//
    global.weapon_packs[i].weapon_normalmap_spritepack = spritepack_get_uvs_transformed(global.weapon_packs[i].weapon_sprite, global.weapon_packs[i].weapon_normalmap);
}