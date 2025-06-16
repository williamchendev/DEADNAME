/// @description Insert description here
// You can write your code in this editor

//
visible = false;
sprite_index = -1;

//
enum CutsceneEventType
{
	Dialogue,
	End
}

//
cutscene_events[0] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "You can't do this shit to me man",
	dialogue_unit: "Mel"
};

cutscene_events[1] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "I went to college!",
	dialogue_unit: "Mel"
};

cutscene_events[2] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "I don't know what to tell you, shit is deeply fucked. Consider doing something else with your life.",
	dialogue_unit: "Charn"
};

// 
cutscene_event_index = -1;

cutscene_dialogue_box = noone;
cutscene_dialogue_boxes = ds_list_create();

//
continue_cutscene_event = function()
{
	//
	cutscene_event_index++;
	
	//
	if (cutscene_event_index >= array_length(cutscene_events))
	{
		//
		instance_destroy();
		return;
	}
	
	//
	switch (cutscene_events[cutscene_event_index].cutscene_type)
	{
		case CutsceneEventType.Dialogue:
			//
			var temp_dialogue_box = instance_create_depth(0, 0, 0, oDialogueBox);
			temp_dialogue_box.dialogue_text = cutscene_events[cutscene_event_index].dialogue_text;
			temp_dialogue_box.dialogue_unit = find_unit_name(cutscene_events[cutscene_event_index].dialogue_unit);
			temp_dialogue_box.dialogue_continue = true;
			temp_dialogue_box.cutscene_instance = id;
			
			if (instance_exists(cutscene_dialogue_box))
			{
				//
				cutscene_dialogue_box.dialogue_box_instance_following = temp_dialogue_box;
				
				//
				temp_dialogue_box.dialogue_box_animation_value = cutscene_dialogue_box.dialogue_box_animation_value + 0.25;
			}
			
			cutscene_dialogue_box = temp_dialogue_box;
			
			//
			ds_list_add(cutscene_dialogue_boxes, temp_dialogue_box);
			break;
		case CutsceneEventType.End:
		default:
			//
			instance_destroy();
			break;
	}
}

//
if (play_cutscene_on_create)
{
	continue_cutscene_event();
}
