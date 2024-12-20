

function lighting_engine_draw_sprite(diffusemap_sprite, normalmap_sprite, specular_sprite, sprite_image_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
    texture_set_stage(LightingEngine.mrt_rendering_shader_normal_map_index, sprite_get_texture(normalmap_sprite, sprite_image_index));
    texture_set_stage(LightingEngine.mrt_rendering_shader_specular_map_index, sprite_get_texture(specular_sprite, sprite_image_index));
    draw_sprite_ext(diffusemap_sprite, sprite_image_index, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}