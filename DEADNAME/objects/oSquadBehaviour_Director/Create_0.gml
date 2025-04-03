/// @description Insert description here
// You can write your code in this editor

//
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

//
squad_ids_map = ds_map_create();
squad_factions_map = ds_map_create();

//
squad_count = 0;

squad_exists_list = ds_list_create();
squad_id_list = ds_list_create();
squad_type_list = ds_list_create();
squad_faction_list = ds_list_create();
squad_behaviour_list = ds_list_create();
squad_luck_list = ds_list_create();
squad_leader_list = ds_list_create();
squad_units_list = ds_list_create();

//
create_squad = function(squad_id, squad_type, squad_faction, squad_units = undefined)
{
    //
    if (!is_undefined(ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id)))
    {
        // Squad already exists, unable to create new Squad - Early Return
        return;
    }
    else
    {
        //
        ds_map_add(GameManager.squad_behaviour_director.squad_ids_map, squad_id, GameManager.squad_behaviour_director.squad_count);
    }
    
    //
    if (is_undefined(ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction)))
    {
        ds_map_add_list(GameManager.squad_behaviour_director.squad_factions_map, squad_faction, ds_list_create());
    }
    
    ds_list_add(ds_map_find_value(GameManager.squad_behaviour_director.squad_factions_map, squad_faction), GameManager.squad_behaviour_director.squad_count);
    
    //
    ds_list_add(GameManager.squad_behaviour_director.squad_exists_list, false);
    ds_list_add(GameManager.squad_behaviour_director.squad_id_list, squad_id);
    ds_list_add(GameManager.squad_behaviour_director.squad_type_list, squad_type);
    ds_list_add(GameManager.squad_behaviour_director.squad_faction_list, squad_faction);
    ds_list_add(GameManager.squad_behaviour_director.squad_behaviour_list, SquadBehaviour.Idle);
    ds_list_add(GameManager.squad_behaviour_director.squad_luck_list, 1.0);
    ds_list_add(GameManager.squad_behaviour_director.squad_leader_list, undefined);
    ds_list_add_list(GameManager.squad_behaviour_director.squad_units_list, ds_list_create());
    
    //
    if (!is_undefined(squad_units))
    {
        //
        var temp_squad_leader_exists = false;
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, GameManager.squad_behaviour_director.squad_count);
        
        //
        for (var i = 0; i < array_length(squad_units); i++)
        {
            //
            var temp_squad_unit = array_get(squad_units, i);
            
            //
            ds_list_add(temp_squad_units_list, temp_squad_unit);
            
            //
            if (!temp_squad_leader_exists)
            {
                ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, GameManager.squad_behaviour_director.squad_count, temp_squad_unit);
                temp_squad_leader_exists = true;
            }
        }
        
        //
        if (ds_list_size(temp_squad_units_list) > 0)
        {
            ds_list_set(GameManager.squad_behaviour_director.squad_exists_list, GameManager.squad_behaviour_director.squad_count, true);
        }
    }
    
    //
    GameManager.squad_behaviour_director.squad_count++;
}

add_unit_to_squad = function(squad_id, squad_unit)
{
    //
    var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
    
    //
    if (!is_undefined(temp_squad_index))
    {
        // Squad does not exists, unable to add Unit to Squad - Early Return
        return;
    }
    else
    {
        //
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
        
        //
        ds_list_add(temp_squad_units_list, squad_unit);
        
        //
        ds_list_set(GameManager.squad_behaviour_director.squad_exists_list, temp_squad_index, true);
    }
}

remove_unit_from_squad = function(squad_id, squad_unit)
{
    //
    var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
    
    //
    if (!is_undefined(temp_squad_index))
    {
        // Squad does not exists, unable to remove Unit from Squad - Early Return
        return;
    }
    else
    {
        //
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
        
        //
        var temp_squad_unit_in_units_list_index = ds_map_find_value(temp_squad_units_list, squad_unit);
        
        //
        if (!is_undefined(temp_squad_unit_in_units_list_index))
        {
            // Squad Unit is not in Squad with Squad ID - Early Return
            return;
        }
        else
        {
            //
            ds_list_delete(temp_squad_units_list, temp_squad_unit_in_units_list_index);
            
            //
            if (ds_list_find_value(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index) == squad_unit)
            {
                //
                ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index, undefined);
            }
            
            //
            if (ds_list_size(temp_squad_units_list) == 0)
            {
                ds_list_set(GameManager.squad_behaviour_director.squad_exists_list, temp_squad_index, false);
            }
        }
    }
}

set_unit_as_squad_leader = function(squad_id, squad_unit)
{
    //
    var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
    
    //
    if (!is_undefined(temp_squad_index))
    {
        // Squad does not exists, unable to set Unit as Squad Leader - Early Return
        return;
    }
    else
    {
        //
        var temp_squad_units_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
        
        //
        var temp_squad_unit_in_units_list_index = ds_map_find_value(temp_squad_units_list, squad_unit);
        
        //
        if (!is_undefined(temp_squad_unit_in_units_list_index))
        {
            // Squad Unit is not in Squad with Squad ID - Early Return
            return;
        }
        else
        {
            //
            ds_list_set(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index, squad_unit);
        }
    }
}