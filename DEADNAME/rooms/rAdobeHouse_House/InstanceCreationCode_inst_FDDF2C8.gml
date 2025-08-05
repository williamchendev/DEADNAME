interaction_object = find_unit_name("Charn");
interaction_object_name = "William";

interact_options[0] = 
{
	option_name: "Talk",
	option_function: function(interaction_instance) 
	{
		//
		var temp_player_unit = GameManager.player_unit;
		var temp_interact_unit = interaction_instance.interaction_object;
		
		temp_interact_unit.draw_xscale = sign(temp_player_unit.x - temp_interact_unit.x);
		
		if (temp_interact_unit.draw_xscale == 0)
		{
			temp_interact_unit.draw_xscale = 1;
		}
		
		// Dialogue Cutscene Event
		var temp_dialogue_cutscene = instance_create_depth(0, 0, 0, oCutscene);
	}
};