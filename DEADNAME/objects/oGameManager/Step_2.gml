/// @description Late Step Event

// Post-Interaction Reset Behaviour
if (mouse_check_button_pressed(mb_left) or mouse_check_button_pressed(mb_right))
{
	// After Interaction Input has been made, check if Interaction has been Selected
	if (!input_interaction_selection)
	{
		// Interaction has not been Selected - Reset all Interaction Object Instances
		with (oInteraction)
		{
			// Reset Interaction Selection Behaviours
			interaction_hover = false;
			interaction_selected = false;
		}
		
		// Reset Interaction Object
		cursor_interaction_object = noone;
	}
}
