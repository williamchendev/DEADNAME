/// point_check_solid_surface_angle(x, y, solid);
/// @description Uses a point to check what angle the instance colliding with the given solid will be
/// @param {number} pos_x The x position of the point to check
/// @param {number} pos_y The y position of the point to check
/// @param {oSolid} solid_inst The Solid Object instance's id to check the angle of the point resting on its surface
/// @return {number} The direction/angle of the object sitting on the solid instance surface
function point_check_solid_surface_angle(pos_x, pos_y, solid_inst) 
{
    //
    var temp_point_angle_from_center = point_direction(solid_inst.center_xpos, solid_inst.center_ypos, pos_x, pos_y);
	
	//
	var temp_side_angle = point_check_solid_surface_side(temp_point_angle_from_center, solid_inst);
	
	// Find 
	var temp_return_angle = solid_inst.image_angle;
	
	switch (temp_side_angle)
	{
	    case SolidSide.AB:
	        temp_return_angle = solid_inst.side_angle_ab;
	        break;
	    case SolidSide.BC:
	        temp_return_angle = solid_inst.side_angle_bc;
	        break;
	    case SolidSide.CD:
	        temp_return_angle = solid_inst.side_angle_cd;
	        break;
	    case SolidSide.DA:
	    default:
	        temp_return_angle = solid_inst.side_angle_da;
	        break;
	}
	
	// Return Angle & 
	return (temp_return_angle - 90) mod 360;
}

function point_check_solid_surface_angle_and_closest_point(pos_x, pos_y, solid_inst) 
{
    //
    var temp_point_angle_from_center = point_direction(solid_inst.center_xpos, solid_inst.center_ypos, pos_x, pos_y);
	
	//
	var temp_side_angle = point_check_solid_surface_side(temp_point_angle_from_center, solid_inst);
	
	// Find 
	var temp_closest_point;
	var temp_return_value = 
	{
	    return_angle: 0,
	    return_x: pos_x,
	    return_y: pos_y
	}
	
	switch (temp_side_angle)
	{
	    case SolidSide.AB:
	        temp_return_value.return_angle = solid_inst.side_angle_ab;
	        temp_closest_point = point_closest_on_line(pos_x, pos_y, solid_inst.corner_xpos_a, solid_inst.corner_ypos_a, solid_inst.corner_xpos_b, solid_inst.corner_ypos_b);
	        break;
	    case SolidSide.BC:
	        temp_return_value.return_angle = solid_inst.side_angle_bc;
	        temp_closest_point = point_closest_on_line(pos_x, pos_y, solid_inst.corner_xpos_b, solid_inst.corner_ypos_b, solid_inst.corner_xpos_c, solid_inst.corner_ypos_c);
	        break;
	    case SolidSide.CD:
	        temp_return_value.return_angle = solid_inst.side_angle_cd;
	        temp_closest_point = point_closest_on_line(pos_x, pos_y, solid_inst.corner_xpos_c, solid_inst.corner_ypos_c, solid_inst.corner_xpos_d, solid_inst.corner_ypos_d);
	        break;
	    case SolidSide.DA:
	    default:
	        temp_return_value.return_angle = solid_inst.side_angle_da;
	        temp_closest_point = point_closest_on_line(pos_x, pos_y, solid_inst.corner_xpos_d, solid_inst.corner_ypos_d, solid_inst.corner_xpos_a, solid_inst.corner_ypos_a);
	        break;
	}
	
	// Return Angle & 
	temp_return_value.return_angle = (temp_return_value.return_angle - 90) mod 360;
	temp_return_value.return_x = temp_closest_point.return_x;
	temp_return_value.return_y = temp_closest_point.return_y;
	return temp_return_value;
}

function point_check_solid_surface_side(angle_from_center, solid_inst)
{
	var temp_side_angle = SolidSide.AB;
	
	switch (solid_inst.rotations)
	{
		case 0:
			if (angle_from_center >= solid_inst.corner_angle_b and angle_from_center <= solid_inst.corner_angle_a)
			{
			    temp_side_angle = SolidSide.AB;
			}
			else if (angle_from_center > solid_inst.corner_angle_a and angle_from_center < solid_inst.corner_angle_d)
			{
			    temp_side_angle = SolidSide.DA;
			}
			else if (angle_from_center > solid_inst.corner_angle_d and angle_from_center < solid_inst.corner_angle_c)
			{
			    temp_side_angle = SolidSide.CD;
			}
			else
			{
			    temp_side_angle = SolidSide.BC;
			}
			break;
		case 1:
			if (angle_from_center >= solid_inst.corner_angle_c and angle_from_center <= solid_inst.corner_angle_b)
			{
			    temp_side_angle = SolidSide.BC;
			}
			else if (angle_from_center > solid_inst.corner_angle_b and angle_from_center < solid_inst.corner_angle_a)
			{
			    temp_side_angle = SolidSide.AB;
			}
			else if (angle_from_center > solid_inst.corner_angle_a and angle_from_center < solid_inst.corner_angle_d)
			{
			    temp_side_angle = SolidSide.DA;
			}
			else
			{
			    temp_side_angle = SolidSide.CD;
			}
			break;
		case 2:
			if (angle_from_center >= solid_inst.corner_angle_d and angle_from_center <= solid_inst.corner_angle_c)
			{
			    temp_side_angle = SolidSide.CD;
			}
			else if (angle_from_center > solid_inst.corner_angle_c and angle_from_center < solid_inst.corner_angle_b)
			{
			    temp_side_angle = SolidSide.BC;
			}
			else if (angle_from_center > solid_inst.corner_angle_b and angle_from_center < solid_inst.corner_angle_a)
			{
			    temp_side_angle = SolidSide.AB;
			}
			else
			{
			    temp_side_angle = SolidSide.DA;
			}
			break;
		case 3:
		default:
			if (angle_from_center >= solid_inst.corner_angle_a and angle_from_center <= solid_inst.corner_angle_d)
			{
			    temp_side_angle = SolidSide.DA;
			}
			else if (angle_from_center > solid_inst.corner_angle_d and angle_from_center < solid_inst.corner_angle_c)
			{
			    temp_side_angle = SolidSide.CD;
			}
			else if (angle_from_center > solid_inst.corner_angle_c and angle_from_center < solid_inst.corner_angle_b)
			{
			    temp_side_angle = SolidSide.BC;
			}
			else
			{
			    temp_side_angle = SolidSide.AB;
			}
			break;
	}
	
	return temp_side_angle;
}

enum SolidSide
{
    AB,
    BC,
    CD,
    DA
}