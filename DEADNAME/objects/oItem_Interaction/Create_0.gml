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
		temp_dialogue_box.set_dialogue_text(global.inventory_item_packs[interaction_instance.interaction_object.item_pack].item_dialogue);
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
		var temp_item_x = interaction_instance.interaction_object.x;
		var temp_item_y = interaction_instance.interaction_object.y;
		
		//
		unit_inventory_take_item_instance(GameManager.player_unit, interaction_instance.interaction_object);
		
		//
		if (GameManager.player_unit.weapon_active)
		{
			//
			GameManager.player_unit.weapon_equipped.unequip_weapon();
			
			//
			//create_inventory_item_object(item_pack, item_x, item_y)
		}
		
		//
		interaction_instance.interaction_object.weapon_instance.equip_weapon(GameManager.player_unit);
		interaction_instance.interaction_object.weapon_instance.item_take_set_displacement(temp_item_x, temp_item_y, 1, GameManager.player_unit.item_take_lerp_movement_spd);
	}
};

