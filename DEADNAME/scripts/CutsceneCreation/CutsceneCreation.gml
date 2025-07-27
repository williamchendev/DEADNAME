// Cutscene Enums
enum CutsceneEventType
{
	Dialogue,
	DialogueClear,
	Delay,
	UnitMovement,
	End
}

/// @function cutscene_add_dialogue(cutscene_instance, text, unit, xoffset, tail_start, tail_end);
/// @description Adds a Dialogue Event to a Cutscene Object Instance's list of Cutscene Events with the provided Dialogue Event's parameters
/// @param {oCutscene} cutscene_instance - The given Cutscene Object Instance to add a Dialogue Event to their list of Cutscene Events
/// @param {string} text - The Dialogue Text that will show in the Dialogue Box created in the added Cutscene Event's Dialogue Event
/// @param {string} unit - The Unit Instance that the Dialogue Box created in the added Cutscene Event's Dialogue Event will belong to
/// @param {real} xoffset - The Horizontal Offset of the created Dialogue Box relative to the Dialogue Box's Unit Instance's Dialogue Pivot
/// @param {real} tail_start - The position of the Dialogue Box's Tail's starting point within the Dialogue Box within a range from -1.0 to 1.0
///	-1.0 positions the tail at the end of the dialogue box behind where the player is facing, 0.0 positions the tail in the center of the dialogue box, and 1.0 positions the tail at the end of the dialogue box forward where the player is facing.
/// @param {real} tail_end - The position of the Dialogue Box's Tail's ending point within the Dialogue Box's next Dialogue Box entry in its Unit's Dialogue Box Chain within a range from -1.0 to 1.0
///	-1.0 positions the tail at the end of the dialogue box behind where the player is facing, 0.0 positions the tail in the center of the dialogue box, and 1.0 positions the tail at the end of the dialogue box forward where the player is facing.
function cutscene_add_dialogue(cutscene_instance, text, unit, xoffset = 0, tail_start = -0.1, tail_end = -0.2)
{
	cutscene_instance.cutscene_events[array_length(cutscene_instance.cutscene_events)] = 
	{
		cutscene_type: CutsceneEventType.Dialogue,
		
		dialogue_text: text,
		dialogue_unit: unit,
		
		dialogue_tail_start_position: tail_start,
		dialogue_tail_end_position: tail_end,
		dialogue_horizontal_offset: xoffset
	};
}

/// @function cutscene_add_dialogue_clear(cutscene_instance);
/// @description Adds a Dialogue Clear Event to a Cutscene Object Instance's list of Cutscene Events with the provided Dialogue Event's parameters, the Dialogue Clear removes all Dialogue Boxes being shown as a part of the Cutscene Event
/// @param {oCutscene} cutscene_instance - The given Cutscene Object Instance to add a Dialogue Clear Event to their list of Cutscene Events
/// @param {bool} instant - Whether or not the Dialogue Clear Event is instantaneous which destroys all Dialogue Boxes and advances the Cutscene to its next Cutscene Event instead of waiting for all Dialogue Boxes to sequentially fade
function cutscene_add_dialogue_clear(cutscene_instance, instant = false)
{
	cutscene_instance.cutscene_events[array_length(cutscene_instance.cutscene_events)] = 
	{
		cutscene_type: CutsceneEventType.DialogueClear,
		
		dialogue_clear_instant: instant
	};
}

/// @function cutscene_add_delay(cutscene_instance, duration);
/// @description Adds a Delay Event to a Cutscene Object Instance's list of Cutscene Events that pauses the Cutscene for the given duration
/// @param {oCutscene} cutscene_instance - The given Cutscene Object Instance to add a Delay Event to their list of Cutscene Events
/// @param {real} duration - The duration of the Delay Event to add to the Cutscene Instance's list of Cutscene Events
function cutscene_add_delay(cutscene_instance, duration)
{
	cutscene_instance.cutscene_events[array_length(cutscene_instance.cutscene_events)] = 
	{
		cutscene_type: CutsceneEventType.Delay,
		
		delay_duration: duration
	};
}

/// @function cutscene_add_unit_movement(cutscene_instance, unit, move_x, move_y, move_position_local, move_end_direction, wait_for_movement_to_finish);
/// @description Adds a Unit Movement Event to a Cutscene Object Instance's list of Cutscene Events with the provided Unit Movement Event's parameters, the Unit Movement Event causes a Unit to pathfind and move to the given destination
/// @param {oCutscene} cutscene_instance - The given Cutscene Object Instance to add a Unit Movement Event to their list of Cutscene Events
/// @param {string} unit - The Unit Instance that the Unit Movement Event will move
/// @param {real} move_x - The horizontal position the Unit will move to
/// @param {real} move_y - The vertical position the Unit will move to
/// @param {bool} move_position_local - Whether or not the move_x and move_y positions are relative to the given Unit's position (true), or if they are the raw world position (false)
/// @param {PathfindingEndDirection} move_end_direction - The behaviour the Unit Instance will take to face the given direction once they have finished their pathfinding movement behaviour
/// @param {bool} wait_for_movement_to_finish - Whether or not the Cutscene Instance will keep track of the Unit's movement and wait for it to finish moving before advancing the cutscene (consecutive Unit Movement Cutscene Events will always be performed together)
function cutscene_add_unit_movement(cutscene_instance, unit, move_x, move_y, move_position_local = false, move_end_direction = PathfindingEndDirection.None, wait_for_movement_to_finish = true)
{
	cutscene_instance.cutscene_events[array_length(cutscene_instance.cutscene_events)] = 
	{
		cutscene_type: CutsceneEventType.UnitMovement,
		
		unit_movement_wait: wait_for_movement_to_finish,
		
		unit_movement_name: unit,
		
		unit_movement_x: move_x,
		unit_movement_y: move_y,
		unit_movement_position_local: move_position_local,
		unit_movement_end_direction: move_end_direction
	};
}
