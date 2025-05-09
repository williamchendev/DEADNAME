/// @description Create Player-Controlled Unit
// Instantiates a Player-Controlled Unit based on the Sprite Index

// Find UnitPack from Sprite Index Unit Idle Animation
var temp_unit_pack = 0;

repeat (array_length(global.unit_packs))
{
	// Auto Assign Unit Sprite Pack from Unit Object's Idle Sprite Index
	if (global.unit_packs[temp_unit_pack].idle_sprite == sprite_index)
	{
		break;
	}
	
	temp_unit_pack++;
}

// Create Unit Object
var temp_unit = instance_create_unit(x, y, temp_unit_pack);
temp_unit.draw_angle = image_angle;
temp_unit.draw_xscale = image_xscale;
temp_unit.draw_yscale = image_yscale;

temp_unit.player_input = true;

// Destroy Temporary Instance
instance_destroy();