/// @function closest_point_in_triangle_barycentric(ax, ay, bx, by, cx, cy, px, py);
/// @description Finds the barycentric coordinates of the closest position within the given triangle to the given point
/// @param {real} ax The X position of the first vertex in the triangle to find the closest coordinate to (This will be referred to as Triangle Vertex A)
/// @param {real} ay The Y position of the first vertex in the triangle to find the closest coordinate to (This will be referred to as Triangle Vertex A)
/// @param {real} bx The X position of the second vertex in the triangle to find the closest coordinate to (This will be referred to as Triangle Vertex B)
/// @param {real} by The Y position of the second vertex in the triangle to find the closest coordinate to (This will be referred to as Triangle Vertex B)
/// @param {real} cx The X position of the third vertex in the triangle to find the closest coordinate to (This will be referred to as Triangle Vertex C)
/// @param {real} cy The Y position of the third vertex in the triangle to find the closest coordinate to (This will be referred to as Triangle Vertex C)
/// @param {real} px The Point's X coordinate to check for the closest position within the triangle to
/// @param {real} py The Point's Y coordinate to check for the closest position within the triangle to
/// @returns {array<real>} An array containing the barycentric coordinates of the closest position within the given triangle to the given point (index 0 corresponds to triangle vertex a, index 1 corresponds to triangle vertex b, and index 2 corresponds to triangle vertex c)
function closest_point_in_triangle_barycentric(ax, ay, bx, by, cx, cy, px, py) 
{
	// Establish Edge vectors
    var temp_abx = bx - ax;
    var temp_aby = by - ay;
    var temp_acx = cx - ax;
    var temp_acy = cy - ay;
    var temp_apx = px - ax;
    var temp_apy = py - ay;

    var temp_d1 = temp_abx * temp_apx + temp_aby * temp_apy;
    var temp_d2 = temp_acx * temp_apx + temp_acy * temp_apy;

    // Check closest point is Vertex A
    if (temp_d1 <= 0 and temp_d2 <= 0) 
    {
        return [1, 0, 0];
    }

    // Check closest point is Vertex B
    var temp_bpx = px - bx;
    var temp_bpy = py - by;
    var temp_d3 = temp_abx * temp_bpx + temp_aby * temp_bpy;
    var temp_d4 = temp_acx * temp_bpx + temp_acy * temp_bpy;

    if (temp_d3 >= 0 and temp_d4 <= temp_d3) 
    {
        return [0, 1, 0];
    }

    // Check closest point is on Edge AB
    var temp_vc = temp_d1 * temp_d4 - temp_d3 * temp_d2;
    
    if (temp_vc <= 0 and temp_d1 >= 0 and temp_d3 <= 0) 
    {
        var temp_v = temp_d1 / (temp_d1 - temp_d3);
        return [1 - temp_v, temp_v, 0];
    }

    // Check closest point is Vertex C
    var temp_cpx = px - cx;
    var temp_cpy = py - cy;
    var temp_d5 = temp_abx * temp_cpx + temp_aby * temp_cpy;
    var temp_d6 = temp_acx * temp_cpx + temp_acy * temp_cpy;

    if (temp_d6 >= 0 and temp_d5 <= temp_d6) 
    {
        return [0, 0, 1];
    }

    // Check closest point is on Edge AC
    var temp_vb = temp_d5 * temp_d2 - temp_d1 * temp_d6;
    
    if (temp_vb <= 0 and temp_d2 >= 0 and temp_d6 <= 0) 
    {
        var temp_w = temp_d2 / (temp_d2 - temp_d6);
        return [1 - temp_w, 0, temp_w];
    }

    // Check closest point is on Edge BC
    var temp_va = temp_d3 * temp_d6 - temp_d5 * temp_d4;
    
    if (temp_va <= 0 and (temp_d4 - temp_d3) >= 0 and (temp_d5 - temp_d6) >= 0) 
    {
        var temp_w_bc = (temp_d4 - temp_d3) / ((temp_d4 - temp_d3) + (temp_d5 - temp_d6));
        return [0, 1 - temp_w_bc, temp_w_bc];
    }

    // Closest point is inside Triangle
    var temp_denom = temp_va + temp_vb + temp_vc;
    var temp_v_in = temp_vb / temp_denom;
    var temp_w_in = temp_vc / temp_denom;
    var temp_u_in = 1 - temp_v_in - temp_w_in;

    return [temp_u_in, temp_v_in, temp_w_in];
}
