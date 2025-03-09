
function lighting_engine_create_distortion(sprite, subimage, x_pos, y_pos, x_scale, y_scale, rotation, alpha)
{
    //
    var temp_distortion_struct = 
    {
        distortion_sprite: sprite,
        distortion_subimage: subimage,
        distortion_x_position: x_pos,
        distortion_y_position: y_pos,
        distortion_horizontal_scale: x_scale,
        distortion_vertical_scale: y_scale,
        distortion_angle: rotation,
        distortion_alpha: alpha
    };
    
    //
    ds_list_add(LightingEngine.lighting_engine_distortion_effects, temp_distortion_struct);
}