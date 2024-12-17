/// @function		array_shuffle(id);
/// @param			{array}		id
/// @description	Shuffles the contents of an array, resulting in values being stored in 
///					random order.
///
///					To shuffle a multidimensional array, input any parent arrays before the
///					child array to be shuffled, e.g. `my_array[0][0]`.
///					
///					Note that for development builds, GameMaker will use the same random seed,
///					meaning results will always randomize the same way every time the game is
///					restarted. To avoid this behavior, use the built-in `randomize` function
///					to create a new seed.
///
/// @example		array_shuffle(my_array);
///					array_shuffle(my_array[0][0]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function array_shuffle(_id) {
	// Initialize shuffle comparator function
	var _shuffle = function(_a, _b) {
		_a = irandom(1);
		_b = irandom(1);
		return (_a > _b);
	}
	
	// Sort array via shuffle
	array_sort(_id, _shuffle);
}
