/// @function instance_create_unit(unit_x, unit_y, unit_pack);
/// @description Creates a Unit Instance with the given Coordinate Position and UnitPack enum
/// @param {real} unit_x - The x coordinate position to create the given Unit Instance at in the Scene
/// @param {real} unit_y - The y coordinate position to create the given Unit Instance at in the Scene
/// @param {?UnitPack} unit_pack - The UnitPack enum to create the given Unit Instance with, can be Undefined
/// @returns {oUnit} Returns the instance of the Unit Object created
function instance_create_unit(unit_x, unit_y, unit_pack = undefined)
{
	// Create Unit Object Instance
	var temp_unit = instance_create_depth
	(
		unit_x, 
		unit_y, 
		0, 
		oUnit, 
		{
			unit_pack: unit_pack == undefined ? UnitPack.Default : unit_pack
		}
	);
	
	// Return Unit Object Instance
	return temp_unit;
}
