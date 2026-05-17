/// @description Battle Cleanup Event
// Celestial Battle Cleanup Behaviour Event

// Incrememnt through Battle's Matchups Array and Erase Battle's Matchup Structs
var temp_battle_matchup_count = array_length(battle_matchups);
var temp_battle_matchup_index = temp_battle_matchup_count - 1;

repeat (temp_battle_matchup_count)
{
	// Delete Battle Matchup Struct
	delete battle_matchups[temp_battle_matchup_index];
	
	// Decrement Battle Matchup Index
	temp_battle_matchup_index--;
}

array_resize(battle_matchups, 0);

