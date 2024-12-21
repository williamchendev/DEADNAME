

function lighting_engine_draw_sprite(diffusemap_sprite, normalmap_sprite, specular_sprite, sprite_image_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    //
    var temp_normalmap_uvs = sprite_get_uvs(normalmap_sprite, sprite_image_index);
    var temp_specularmap_uvs = sprite_get_uvs(specular_sprite, sprite_image_index);
    
    var a = sprite_get_uvs(diffusemap_sprite, sprite_image_index);
    var b = sprite_get_uvs(normalmap_sprite, sprite_image_index);
    var c = 1 / ( a[2] - a[0] ) * ( b[2] - b[0] );
    var d = 1 / ( a[3] - a[1] ) * ( b[3] - b[1] );
    var e = b[0] - a[0] * c;
    var f = b[1] - a[1] * d;
    
    //
    
    shader_set_uniform_f(LightingEngine.mrt_rendering_shader_normal_uv_index, c, d, e, f);
    shader_set_uniform_f(LightingEngine.mrt_rendering_shader_specular_uv_index, temp_specularmap_uvs[0], temp_specularmap_uvs[1], 1 / (temp_specularmap_uvs[2] - temp_specularmap_uvs[0]), 1 / (temp_specularmap_uvs[3] - temp_specularmap_uvs[1]));
    
    //
    texture_set_stage(LightingEngine.mrt_rendering_shader_normal_map_index, sprite_get_texture(normalmap_sprite, sprite_image_index));
    texture_set_stage(LightingEngine.mrt_rendering_shader_specular_map_index, sprite_get_texture(specular_sprite, sprite_image_index));
    
    //
    draw_sprite_ext(diffusemap_sprite, sprite_image_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}