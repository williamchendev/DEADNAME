/// @description Insert description here
// You can write your code in this editor

gpu_set_blendenable(false);
draw_surface_ext(global.debug ? normalmap_color_surface : diffuse_color_surface, 0, 0, 1, 1, 0, c_white, 1);
gpu_set_blendenable(true);

surface_free(diffuse_color_surface);
surface_free(normalmap_color_surface);
surface_free(depth_specular_stencil_surface);
