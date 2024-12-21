

function lighting_engine_draw_sprite(diffusemap_sprite, normalmap_spritepack, specular_spritepack, subimage_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    //
    var temp_normalmap_uvs = sprite_get_uvs_transformed(diffusemap_sprite, subimage_index, normalmap_sprite, subimage_index);
    var temp_specularmap_uvs = sprite_get_uvs_transformed(diffusemap_sprite, subimage_index, specular_sprite, subimage_index);
    
    //
    shader_set_uniform_f_array(LightingEngine.mrt_rendering_shader_normal_uv_index, temp_normalmap_uvs);
    shader_set_uniform_f_array(LightingEngine.mrt_rendering_shader_specular_uv_index, temp_specularmap_uvs);
    //shader_set_uniform_f_buffer(LightingEngine.mrt_rendering_shader_normal_uv_index, normalmap_spritepack.uv_buffers[subimage_index], 0, 4);
    //shader_set_uniform_f_buffer(LightingEngine.mrt_rendering_shader_specular_uv_index, specular_spritepack.uv_buffers[subimage_index], 0, 4);
    
    //
    texture_set_stage(LightingEngine.mrt_rendering_shader_normal_map_index, normalmap_spritepack.textures[subimage_index]);
    texture_set_stage(LightingEngine.mrt_rendering_shader_specular_map_index, specular_spritepack.textures[subimage_index]);
    
    //
    draw_sprite_ext(diffusemap_sprite, subimage_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}