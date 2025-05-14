
//
image_index = irandom(sprite_get_number(sprite_index));
image_angle = irandom(360);

//
trail_thickness = 1;

trail_segments = 6;
trail_segment_length = 5;
trail_segment_divisions = 10;

trail_vector_h = dcos(trail_angle);
trail_vector_v = dsin(trail_angle);

trail_vector_dh = dcos(trail_angle - 90);
trail_vector_dv = dsin(trail_angle - 90);

trail_direction = random(1.0) > 0.5 ? 1 : -1;

trail_weight_spd = 1;
trail_weight_mult = 0.98;

trail_weights[0] = 0;
trail_weights[1] = 0;
trail_weights[2] = 0;
trail_weights[3] = 0;
trail_weights[4] = 0;
trail_weights[5] = 0;

trail_weights_spd[0] = random_range(0.5, 1) * trail_direction;
trail_weights_spd[1] = random_range(1, 2) * -trail_direction;
trail_weights_spd[2] = random_range(1, 2) * trail_direction;
trail_weights_spd[3] = random_range(0.5, 1) * -trail_direction;
trail_weights_spd[4] = random_range(0.5, 1) * trail_direction;
trail_weights_spd[5] = random_range(0, 0.5) * -trail_direction;

trail_start_color = merge_color(c_white, c_black, 0.1);
trail_end_color = merge_color(c_white, c_black, 0.6);

trail_start_alpha = 0.8;
trail_end_alpha = 0;

trail_decay = 0.0037;
trail_alpha = 1.0;

//
hitmarker_dropshadow_horizontal_offset = random_range(-3, 3);
hitmarker_dropshadow_vertical_offset = random_range(-3, 3);

//
hitmarker_destroy_timer = 8;