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
var temp_unit_struct = { unit_pack: temp_unit_pack, player_input: true };
var temp_unit = instance_create_depth(x, y, 0, oUnit,  temp_unit_struct);
temp_unit.draw_angle = image_angle;
temp_unit.draw_xscale = image_xscale;
temp_unit.draw_yscale = image_yscale;

// Debug - Set Render Position Centered on Unit
LightingEngine.render_x = temp_unit.x - (GameManager.game_width * 0.5);
LightingEngine.render_y = temp_unit.y - (GameManager.game_height * 0.5);

// Debug - Set Player Faction to Moralists
GameManager.squad_behaviour_director.create_squad("LoneWolfPlayer", SquadType.Infantry, "Moralists", [ temp_unit ]);

// Destroy Temporary Instance
instance_destroy();