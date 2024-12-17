/// @function		emod(val, div);
/// @param			{real}	val
/// @param			{real}	div
/// @description	Returns the modulo (remainder) of a number with Euclidean division. 
///					Unlike the built-in `mod` (`%`) operator, this function will always 
///					return a positive value between zero and the divisor (`div`).
///	
/// @example		image_angle = emod(image_angle, 360);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function emod(_val, _div) {
	return (_val - (_div*ceil((_val/_div) - 1)));
}