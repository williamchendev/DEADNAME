

function lighting_engine_draw_sprite(diffusemap_sprite, normalmap_spritepack, specularmap_spritepack, subimage_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    //
    shader_set_uniform_f_array(LightingEngine.mrt_rendering_shader_normal_uv_index, normalmap_spritepack.uvs[subimage_index]);
    shader_set_uniform_f_array(LightingEngine.mrt_rendering_shader_specular_uv_index, specularmap_spritepack.uvs[subimage_index]);
    
    //
    texture_set_stage(LightingEngine.mrt_rendering_shader_normal_map_index, normalmap_spritepack.textures[subimage_index]);
    texture_set_stage(LightingEngine.mrt_rendering_shader_specular_map_index, specularmap_spritepack.textures[subimage_index]);
    
    //
    draw_sprite_ext(diffusemap_sprite, subimage_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}