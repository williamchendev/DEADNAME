/// @description Default Item Interaction Menu UI
// Instantiates the Interaction Menu's Options and Behaviours for a Default Item Instance

// Perform Interaction Object's Event Inherited
event_inherited();

// Item Interaction Menu Options
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
		// Check if Item is Valid and Exists
		if (interaction_instance.interaction_object.item_pack == -1)
		{
			// Destroy Interaction Object if it Exists
			if (instance_exists(interaction_instance.interaction_object))
			{
				instance_destroy(interaction_instance.interaction_object);
			}
			
			// Destroy Interaction Instance if it Exists
			if (instance_exists(interaction_instance))
			{
				instance_destroy(interaction_instance);
			}
			
			// Interaction Destroyed - Early Return
			return;
		}
		
		// Establish Item's Position based on Interaction Object's Position
		var temp_item_x = interaction_instance.interaction_object.x;
		var temp_item_y = interaction_instance.interaction_object.y;
		var temp_item_angle = interaction_instance.interaction_object.image_angle;
		
		// Establish Player Unit's Inventory Slot Index
		var temp_take_item_slot_index = unit_inventory_take_item_instance(GameManager.player_unit, interaction_instance.interaction_object);
		
		// Check if Item was successfully taken by Player Unit's Inventory
		if (temp_take_item_slot_index != -1)
		{
			// Switch Player Unit's Inventory Slot Index to the Inventory Slot where the new Item was placed
			unit_inventory_change_slot(GameManager.player_unit, temp_take_item_slot_index);
			
			// Perform Take Item Specific Behaviours based on Inventory Item's Type 
			if (global.inventory_item_packs[interaction_instance.interaction_object.item_pack].item_type == InventoryItemType.Weapon)
			{
				// Weapon Item Type Behaviour
				interaction_instance.interaction_object.weapon_instance.item_take_set_displacement(temp_item_x, temp_item_y, 1, GameManager.player_unit.item_take_lerp_movement_spd);
				interaction_instance.interaction_object.weapon_instance.weapon_angle = temp_item_angle;
			}
		}
	}
};

