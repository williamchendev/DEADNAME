

function lighting_engine_draw_sprite(diffusemap_index, diffusemap_subimage, normalmap_texture, specularmap_texture, normalmap_uvs, specularmap_uvs, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    //
    texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index, normalmap_texture);
    texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_specularmap_texture_index, specularmap_texture);
    
    //
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index, x_scale, y_scale, 1);
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index, rotation);
    
    //
    shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index, normalmap_uvs);
    shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_specularmap_uv_index, specularmap_uvs);
    
    //
    draw_sprite_ext(diffusemap_index, diffusemap_subimage, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}