
function instance_create_unit(unit_x, unit_y, unit_pack)
{
	//
	var temp_unit = instance_create_depth
	(
		unit_x, 
		unit_y, 
		0, 
		oUnit, 
		{
			unit_pack: unit_pack
		}
	);
	
	//
	return temp_unit;
}