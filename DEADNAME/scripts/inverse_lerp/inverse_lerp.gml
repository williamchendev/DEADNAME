/// @function inverse_lerp(from, to, value);
/// @description Finds the inverse linear interpolation percentage the given value is between the from and to arguments
/// @param {real} from The number which the range starts from
/// @param {real} to The number which the range goes to
/// @param {real} value The value between the from and to arguments
/// @param {bool} clamp_value Argument to optionally set whether or not the value is clamped in the range between the from and to arguments (by default the value is clamped)
/// @returns {real} Returns the percentage the given value is between the from and to arguments
function inverse_lerp(from, to, value, clamp_value = true) 
{
	var temp_inv_lerp = (value - from) / (to - from);
    return clamp_value ? clamp(temp_inv_lerp, 0, 1) : temp_inv_lerp;
}

/// @function inverse_lerp_position(from_x, from_y, to_x, to_y, value_x, value_y);
/// @description Finds the inverse linear interpolation percentage the given value is between the from and to arguments using positions instead of a single value
/// @param {real} from_x The coordinate x which the vector range starts from
/// @param {real} from_y The coordinate y which the vector range starts from
/// @param {real} to_x The coordinate x which the vector range goes to
/// @param {real} to_x The coordinate x which the vector range goes to
/// @param {real} value_x The coordinate x between the from and to arguments
/// @param {real} value_y The coordinate y between the from and to arguments
/// @param {bool} clamp_value Argument to optionally set whether or not the value is clamped in the range between the from and to arguments (by default the value is clamped)
/// @returns {real} Returns the percentage the given value is between the from and to arguments
function inverse_lerp_position(from_x, from_y, to_x, to_y, value_x, value_y, clamp_value = true)
{
    // Direction vector of the line
    var temp_dx = to_x - from_x;
    var temp_dy = to_y - from_y;

    // Vector from P1 to P3
    var temp_vx = value_x - from_x;
    var temp_vy = value_y - from_y;

    // Compute the projection scalar (dot(v, d) / dot(d, d))
    var temp_projection_scalar = dot_product(temp_vx, temp_vy, temp_dx, temp_dy) / dot_product(temp_dx, temp_dy, temp_dx, temp_dy);
    
    // Clamp projection scalar to range
	return clamp_value ? clamp(temp_projection_scalar, 0, 1) : temp_projection_scalar;
}
