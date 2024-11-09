/// @function		array_clear(id);
/// @param			{array}	id
/// @description	Clears an array's data from memory. This also includes any child arrays the input 
///					array may hold. To clear a multidimensional array, input the root array. However, 
///					it is also possible to clear just one dimension of an array by including any 
///					parent arrays in the input value, e.g. `my_array[0][0]`.
///
///					Note that this function will not destroy the array itself! To de-reference an
///					array after clearing, simply set the parent variable to 0.
///
/// @example		array_clear(my_array);
///					array_clear(my_array[0][0]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function array_clear(_id) {
	array_delete(_id, 0, array_length(_id));
}
