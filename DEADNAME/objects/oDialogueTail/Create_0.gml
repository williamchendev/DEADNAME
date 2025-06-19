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

path_x_coordinate_array = array_create(0);
path_y_coordinate_array = array_create(0);

path_h_vector_array = array_create(0);
path_v_vector_array = array_create(0);

//
add_path_point = function(x_coordinate, y_coordinate, h_vector, v_vector)
{
	array_set(path_x_coordinate_array, path_count, x_coordinate);
	array_set(path_y_coordinate_array, path_count, y_coordinate);
	
	array_set(path_h_vector_array, path_count, h_vector);
	array_set(path_v_vector_array, path_count, v_vector);
	
	path_count++;
}

//
//add_path_point(160, 200, 50, 0);
//add_path_point(160, 220, 0, 0);
//add_path_point(160, 240, -50, 0);