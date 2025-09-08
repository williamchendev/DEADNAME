/// @description Bulk Dynamic Layer Cleanup Event
// Cleans up Bulk Dynamic Layer's Lighting Engine Vertex Buffer and DS Lists

// Delete Bulk Dynamic Layer's Vertex Buffer
vertex_delete_buffer(bulk_dynamic_layer_vertex_buffer);
bulk_dynamic_layer_vertex_buffer = -1;

// Destroy all Bulk Dynamic Layer's DS Lists
ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_ax_list);
bulk_dynamic_layer_vertex_coordinate_ax_list = -1;
ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_ay_list);
bulk_dynamic_layer_vertex_coordinate_ay_list = -1;

ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_bx_list);
bulk_dynamic_layer_vertex_coordinate_bx_list = -1;
ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_by_list);
bulk_dynamic_layer_vertex_coordinate_by_list = -1;

ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_cx_list);
bulk_dynamic_layer_vertex_coordinate_cx_list = -1;
ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_cy_list);
bulk_dynamic_layer_vertex_coordinate_cy_list = -1;

ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_dx_list);
bulk_dynamic_layer_vertex_coordinate_dx_list = -1;
ds_list_destroy(bulk_dynamic_layer_vertex_coordinate_dy_list);
bulk_dynamic_layer_vertex_coordinate_dy_list = -1;

ds_list_destroy(bulk_dynamic_layer_image_angle_list);
bulk_dynamic_layer_image_angle_list = -1;

ds_list_destroy(bulk_dynamic_layer_image_xscale_list);
bulk_dynamic_layer_image_xscale_list = -1;
ds_list_destroy(bulk_dynamic_layer_image_yscale_list);
bulk_dynamic_layer_image_yscale_list = -1;

ds_list_destroy(bulk_dynamic_layer_normal_strength_list);
bulk_dynamic_layer_normal_strength_list = -1;

ds_list_destroy(bulk_dynamic_layer_image_blend_list);
bulk_dynamic_layer_image_blend_list = -1;

ds_list_destroy(bulk_dynamic_layer_image_alpha_list);
bulk_dynamic_layer_image_alpha_list = -1;

ds_list_destroy(bulk_dynamic_layer_diffusemap_uvs_list);
bulk_dynamic_layer_diffusemap_uvs_list = -1;
ds_list_destroy(bulk_dynamic_layer_normalmap_uvs_list);
bulk_dynamic_layer_normalmap_uvs_list = -1;
ds_list_destroy(bulk_dynamic_layer_metallicroughnessmap_uvs_list);
bulk_dynamic_layer_metallicroughnessmap_uvs_list = -1;
ds_list_destroy(bulk_dynamic_layer_emissivemap_uvs_list);
bulk_dynamic_layer_emissivemap_uvs_list = -1;

ds_list_destroy(bulk_dynamic_layer_metallic_list);
bulk_dynamic_layer_metallic_list = -1;
ds_list_destroy(bulk_dynamic_layer_roughness_list);
bulk_dynamic_layer_roughness_list = -1;
ds_list_destroy(bulk_dynamic_layer_emissive_list);
bulk_dynamic_layer_emissive_list = -1;
ds_list_destroy(bulk_dynamic_layer_emissive_multiplier_list);
bulk_dynamic_layer_emissive_multiplier_list = -1;
