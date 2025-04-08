/// @description Insert description here
// You can write your code in this editor

// Global Squad Properties
#macro SquadIDNull "#NULL_SQUAD#"

// Squad Enums
enum SquadType
{
    Infantry
}

enum SquadBehaviour
{
    Idle,
    Hunting,
    Patrol,
    Sentry,
    Action
}

enum SquadSubBehaviour
{
    Default,
    Regroup
}

enum SquadMovement
{
    None,
    Moving,
    Finished
}

// Squad Variables
squad_count = 0;

// Squad Lookup DS Maps
squad_ids_map = ds_map_create();
squad_factions_map = ds_map_create();

// Squad Property DS Lists
squad_exists_list = ds_list_create();
squad_id_list = ds_list_create();
squad_type_list = ds_list_create();
squad_faction_list = ds_list_create();
squad_behaviour_list = ds_list_create();
squad_sub_behaviour_list = ds_list_create();
squad_movement_list = ds_list_create();
squad_movement_target_list = ds_list_create();
squad_luck_list = ds_list_create();
squad_leader_list = ds_list_create();
squad_units_list = ds_list_create();

// Squad Functions
create_squad = function(squad_id, squad_type, squad_faction, squad_units = undefined)
{
    // Check if Squad ID is Indexed in Squad IDs DS Map
    if (!is_undefined(ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id)))
    {
        // Squad already exists, unable to create new Squad - Early Return
        return;
    }
    else
    {
        // Create new index for Squad ID in Squad IDs DS Map
        ds_map_add(GameManager.squad_behaviour_director.squad_ids_map, squad_id, GameManager.squad_behaviour_director.squad_count);
    }
    
    // Check if Squad Faction Exists
    if (is_undefined(ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction)))
    {
        // Create new List within Squad Factions Map to index all Squads within that faction
        ds_map_add_list(GameManager.squad_behaviour_director.squad_factions_map, squad_faction, ds_list_create());
    }
    
    ds_list_add(ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction), squad_id);
    
    // Add Default Squad Properties to Squad Property DS Lists
    ds_list_add(GameManager.squad_behaviour_director.squad_exists_list, false);
    ds_list_add(GameManager.squad_behaviour_director.squad_id_list, squad_id);
    ds_list_add(GameManager.squad_behaviour_director.squad_type_list, squad_type);
    ds_list_add(GameManager.squad_behaviour_director.squad_faction_list, squad_faction);
    ds_list_add(GameManager.squad_behaviour_director.squad_behaviour_list, SquadBehaviour.Idle);
    ds_list_add(GameManager.squad_behaviour_director.squad_sub_behaviour_list, SquadSubBehaviour.Default);
    ds_list_add(GameManager.squad_behaviour_director.squad_movement_list, SquadMovement.None);
    ds_list_add(GameManager.squad_behaviour_director.squad_movement_target_list, { position_x: 0, position_y: 0 });
    ds_list_add(GameManager.squad_behaviour_director.squad_luck_list, 1.0);
    ds_list_add(GameManager.squad_behaviour_director.squad_leader_list, undefined);
    ds_list_add_list(GameManager.squad_behaviour_director.squad_units_list, ds_list_create());
    
    // Index all Squad Units to Squad
    if (!is_undefined(squad_units))
    {
        // Establish Squad Unit Variables
        var temp_squad_leader_exists = false;
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, GameManager.squad_behaviour_director.squad_count);
        
        // Iterate through all Squad Units in Array
        for (var i = 0; i < array_length(squad_units); i++)
        {
            // Find Squad Unit in array
            var temp_squad_unit = array_get(squad_units, i);
            
            // Add Unit to Squad
            ds_list_add(temp_squad_units_list, temp_squad_unit);
            
            // Set Unit Squad ID
            temp_squad_unit.squad_id = squad_id;
            
            // Set first Unit in Squad Units Array as Squad Leader
            if (!temp_squad_leader_exists)
            {
                ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, GameManager.squad_behaviour_director.squad_count, temp_squad_unit);
                temp_squad_unit.squad_leader = true;
                temp_squad_leader_exists = true;
            }
            else
            {
            	temp_squad_unit.squad_leader = false;
            }
        }
        
        // Squad Exists because 
        if (ds_list_size(temp_squad_units_list) > 0)
        {
            ds_list_set(GameManager.squad_behaviour_director.squad_exists_list, GameManager.squad_behaviour_director.squad_count, true);
        }
    }
    
    // Increment Squad Count
    GameManager.squad_behaviour_director.squad_count++;
}

add_unit_to_squad = function(squad_id, squad_unit)
{
    // Find Squad Index from Squad IDs DS Map
    var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
    
    // Check if Squad Index Exists
    if (!is_undefined(temp_squad_index))
    {
        // Squad does not exists, unable to add Unit to Squad - Early Return
        return;
    }
    else
    {
        // Find Squad Unit List
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
        
        // Add Unit to Squad
        ds_list_add(temp_squad_units_list, squad_unit);
        
        // Set Unit Squad ID
        squad_unit.squad_id = squad_id;
        
        // Add Squad back to Squad Faction Map (is removed for being empty)
        if (!is_undefined(ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction)))
        {
            var temp_squad_faction_list = ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction);
            var temp_squad_faction_index = ds_list_find_index(temp_squad_faction_list, squad_id);
            
            if (temp_squad_faction_index == -1)
            {
                ds_list_add(temp_squad_faction_list, squad_id);
            }
        }
        
        // Check if Squad Leader is undefined (by default this Squad Unit will become Squad Leader)
        var temp_current_squad_leader = ds_list_find_value(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index);
        
        if (squad_unit.player_input or is_undefined(temp_current_squad_leader) or (squad_unit.squad_leader and !temp_current_squad_leader.player_input))
        {
            ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index, squad_unit);
            
            if (!temp_current_squad_leader.player_input and temp_current_squad_leader.squad_leader)
            {
            	temp_current_squad_leader.squad_leader = false;
            }
        }
        
        // Set Squad to Exist because Unit was successfully added to Squad
        ds_list_set(GameManager.squad_behaviour_director.squad_exists_list, temp_squad_index, true);
    }
}

remove_unit_from_squad = function(squad_id, squad_unit)
{
    // Find Squad Index from Squad IDs DS Map
    var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
    
    // Check if Squad Index Exists
    if (!is_undefined(temp_squad_index))
    {
        // Squad does not exists, unable to remove Unit from Squad - Early Return
        return;
    }
    else
    {
        // Find Squad Unit List
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
        
        // Find Squad Unit Index in Squad Units List
        var temp_squad_unit_in_units_list_index = ds_map_find_value(temp_squad_units_list, squad_unit);
        
        // Check if Squad Unit exists in Squad Units List
        if (!is_undefined(temp_squad_unit_in_units_list_index))
        {
            // Squad Unit is not in Squad with Squad ID - Early Return
            return;
        }
        else
        {
            // Delete Unit from Squad Units
            ds_list_delete(temp_squad_units_list, temp_squad_unit_in_units_list_index);
            
            // Reset Unit's Squad ID & Squad Leader Trait
            squad_unit.squad_id = SquadIDNull;
            squad_unit.squad_leader = false;
            
            // Check if there are remaining Units in Squad
            if (ds_list_size(temp_squad_units_list) == 0)
            {
                // Squad is empty - Squad no longer exists
                ds_list_set(GameManager.squad_behaviour_director.squad_exists_list, temp_squad_index, false);
                
                // Squad is empty - Set Squad Leader as undefined
                ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index, undefined);
                
                // Remove Squad from Factions List
                if (is_undefined(ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction)))
                {
                    var temp_squad_faction_list = ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction);
                    var temp_squad_faction_index = ds_list_find_index(temp_squad_faction_list, squad_id);
                    
                    if (temp_squad_faction_index != -1)
                    {
                        ds_list_delete(temp_squad_faction_list, temp_squad_faction_index);
                    }
                }
            }
            else if (ds_list_find_value(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index) == squad_unit)
            {
                // Remove Unit as Squad Leader and Replace Unit with next viable Squad Leader
                var temp_new_squad_leader = undefined;
                
                for (var temp_squad_unit_index = 0; temp_squad_unit_index < ds_list_size(temp_squad_units_list); temp_squad_unit_index++)
                {
                    var temp_squad_unit_instance = ds_list_find_value(temp_squad_units_list, temp_squad_unit_index);
                    
                    if (temp_squad_unit_instance.player_input)
                    {
                        temp_new_squad_leader = temp_squad_unit_instance;
                        break;
                    }
                    else if (temp_squad_unit_instance.squad_leader)
                    {
                        temp_new_squad_leader = temp_squad_unit_instance;
                    }
                }
                
                //
                if (is_undefined(temp_new_squad_leader))
                {
                    temp_squad_unit_instance = ds_list_find_value(temp_squad_units_list, 0);
                }
                
                //
                ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index, temp_squad_unit_instance);
                
                //
                if (!temp_squad_unit_instance.player_input)
                {
                	temp_squad_unit_instance.squad_leader = true;
                }
            }
        }
    }
}

set_unit_as_squad_leader = function(squad_id, squad_unit)
{
    // Find Squad Index from Squad IDs DS Map
    var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
    
    // Check if Squad Index Exists
    if (!is_undefined(temp_squad_index))
    {
        // Squad does not exists, unable to set Unit as Squad Leader - Early Return
        return;
    }
    else
    {
        // Find Squad Unit List
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
        
        // Find Squad Unit Index in Squad Units List
        var temp_squad_unit_in_units_list_index = ds_map_find_value(temp_squad_units_list, squad_unit);
        
        // Check if Squad Unit exists in Squad Units List
        if (!is_undefined(temp_squad_unit_in_units_list_index))
        {
            // Squad Unit is not in Squad with Squad ID - Early Return
            return;
        }
        else
        {
        	//
        	var temp_current_squad_leader = ds_list_find_value(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index);
        	temp_current_squad_leader.squad_leader = false;
        	
            // Set Squad Unit as Squad Leader
            ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index, squad_unit);
            squad_unit.squad_leader = true;
        }
    }
}