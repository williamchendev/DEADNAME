/// @description Insert description here
// You can write your code in this editor

// Cleanup UnitPack NormalMap and SpecularMap UV Buffers
var s = 0;

repeat (array_length(global.unit_packs))
{
	//
	spritepack_destroy_buffers(global.unit_packs[s].idle_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].walk_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].jump_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].aim_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].aim_walk_normalmap.uv_buffers);
	
	//
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_head_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_arm_left_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_arm_right_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_chest_top_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_chest_bot_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_leg_left_normalmap.uv_buffers);
	spritepack_destroy_buffers(global.unit_packs[s].ragdoll_leg_right_normalmap.uv_buffers);
	
	//
	s++;
}

//
var w = 0;

repeat (array_length(global.weapon_packs))
{
	//
    spritepack_destroy_buffers(global.weapon_packs[w].weapon_normalmap.uv_buffers);
	
	//
	w++;
}