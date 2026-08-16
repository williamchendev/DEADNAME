/// @description Game End Cleanup Event
// Cleanup Event for Celestial Simulator

// Clean Up Celestial Simulation Surfaces
surface_free(background_surface);
background_surface = -1;

surface_free(temp_surface);
temp_surface = -1;

surface_free(celestial_body_render_surface);
celestial_body_render_surface = -1;

surface_free(celestial_body_diffuse_surface);
celestial_body_diffuse_surface = -1;

surface_free(celestial_body_emissive_surface);
celestial_body_emissive_surface = -1;

surface_free(celestial_body_atmosphere_depth_mask_surface);
celestial_body_atmosphere_depth_mask_surface = -1;

surface_free(clouds_render_surface);
clouds_render_surface = -1;

surface_free(post_processing_surface);
post_processing_surface = -1;

surface_free(diffuse_surface);
diffuse_surface = -1;

surface_free(emissive_surface);
emissive_surface = -1;

surface_free(bloom_premult_surface);
bloom_premult_surface = -1;

surface_free(final_render_surface);
final_render_surface = -1;

// Delete Vertex Formats
vertex_format_delete(icosphere_render_vertex_format);
icosphere_render_vertex_format = -1;

vertex_format_delete(background_stars_render_vertex_format);
background_stars_render_vertex_format = -1;

vertex_format_delete(square_uv_vertex_format);
square_uv_vertex_format = -1;

// Delete Vertex Buffers
var temp_solar_systems_background_stars_vertex_buffer_count = array_length(solar_systems_background_stars_vertex_buffer);
var temp_solar_systems_background_stars_vertex_buffer_index = temp_solar_systems_background_stars_vertex_buffer_count - 1;

repeat (temp_solar_systems_background_stars_vertex_buffer_count)
{
	// Delete Background Stars Vertex Buffer from Background Stars Vertex Buffer Array
	vertex_delete_buffer(solar_systems_background_stars_vertex_buffer[temp_solar_systems_background_stars_vertex_buffer_index]);
	solar_systems_background_stars_vertex_buffer[temp_solar_systems_background_stars_vertex_buffer_index] = -1;
	
	// Decrement Background Stars Vertex Buffer Array Index
	temp_solar_systems_background_stars_vertex_buffer_index--;
}

vertex_delete_buffer(square_uv_vertex_buffer);
square_uv_vertex_buffer = -1;

// Destroy DS Lists
ds_list_destroy(pathfinding_queue_list);
pathfinding_queue_list = -1;

// Destroy DS Maps
ds_map_destroy(faction_relationships);
faction_relationships = -1;

// Clear Celestial Battle Combat Grid
var temp_battle_combat_grid_column_index = CelestialBattleCombatGridColumns - 1;

repeat (CelestialBattleCombatGridColumns)
{
	// Increment through Battle's Combat Grid Arrays and clear all Row Structs
	var temp_battle_combat_grid_row_index = CelestialBattleCombatGridRows - 1;
	
	repeat (CelestialBattleCombatGridRows)
	{
		// Establish Structs
		var temp_battle_combat_grid_struct_a = array_get(CelestialSimulator.battle_combat_grid_a_structs[temp_battle_combat_grid_column_index], temp_battle_combat_grid_row_index);
		var temp_battle_combat_grid_struct_b = array_get(CelestialSimulator.battle_combat_grid_b_structs[temp_battle_combat_grid_column_index], temp_battle_combat_grid_row_index);
		
		// Delete Structs
		delete temp_battle_combat_grid_struct_a;
		delete temp_battle_combat_grid_struct_b;
		
		// Decrement Combat Grid Row Index
		temp_battle_combat_grid_row_index--;
	}
	
	// Clear Battle Combat Grid's Column Arrays
	array_resize(CelestialSimulator.battle_combat_grid_a_structs[temp_battle_combat_grid_column_index], 0);
	array_resize(CelestialSimulator.battle_combat_grid_b_structs[temp_battle_combat_grid_column_index], 0);
	
	// Delete Battle Combat Grid's Column Arrays from Battle Combat Grid Arrays
	array_delete(CelestialSimulator.battle_combat_grid_a_structs, temp_battle_combat_grid_column_index, 1);
	array_delete(CelestialSimulator.battle_combat_grid_b_structs, temp_battle_combat_grid_column_index, 1);
	
	// Decrement Combat Grid Column Index
	temp_battle_combat_grid_column_index--;
}
