/// @description Dialogue Tail Init Event
// Initializes the Dialogue Tail's Settings and Variables

// Dialogue Tail's Lighting Engine UI Object Type & Depth
object_type = LightingEngineUIObjectType.DialogueTail;
object_depth = 0;

// Default Lighting Engine UI Object Initialization Behaviour
event_inherited();

//
path_segment_divisions = 10;
path_thickness = 2;

//
path_count = 0;

path_x_coordinate_list = ds_list_create();
path_y_coordinate_list = ds_list_create();

path_h_vector_list = ds_list_create();
path_v_vector_list = ds_list_create();

path_thickness_list = ds_list_create();

//
add_path_point = function(x_coordinate, y_coordinate, h_vector, v_vector, thickness = 1)
{
	ds_list_add(path_x_coordinate_list, x_coordinate);
	ds_list_add(path_y_coordinate_list, y_coordinate);
	
	ds_list_add(path_h_vector_list, h_vector);
	ds_list_add(path_v_vector_list, v_vector);
	
	ds_list_add(path_thickness_list, thickness);
	
	path_count++;
}

clear_all_points = function()
{
	ds_list_clear(path_x_coordinate_list);
	ds_list_clear(path_y_coordinate_list);
	
	ds_list_clear(path_h_vector_list);
	ds_list_clear(path_v_vector_list);
	
	ds_list_clear(path_thickness_list);
	
	path_count = 0;
}
