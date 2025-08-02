/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

//
interact_options[0] = 
{
	option_name: "Inspect",
	option_function: function(interaction_instance) 
	{
		// Dialogue Cutscene Event - Create new Dialogue Box for Cutscene
		var temp_dialogue_box = instance_create_depth(0, 0, 0, oDialogueBox);
		
		// Set Dialogue Text and Unit
		temp_dialogue_box.set_dialogue_text(global.inventory_item_pack[interaction_instance.interaction_object.item_pack].item_dialogue);
		temp_dialogue_box.dialogue_unit = GameManager.player_unit;
		
		// Set Dialogue Cutscene Behaviour Properties
		temp_dialogue_box.dialogue_continue = true;
	}
};

interact_options[1] = 
{
	option_name: "Take Item",
	option_function: function(interaction_instance) 
	{
		//
		unit_inventory_take_item_instance(GameManager.player_unit, interaction_instance.interaction_object);
		
		//
		interaction_instance.interaction_object.weapon_instance.equip_weapon(GameManager.player_unit);
	}
};

