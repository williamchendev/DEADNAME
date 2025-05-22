/// @description Smoke Trail Decay & Movement Behaviour
// Updates the Smoke Trail's Alpha and Wisp Movement

// Smoke Trail Segment Wisp Movement Calculations
for (var i = 0; i < trail_segments; i++)
{
	trail_segment_position_x[i] += trail_segment_movement_h[i] * trail_segment_movement_spd[i] * trail_movement_spd * frame_delta;
	trail_segment_position_y[i] += trail_segment_movement_v[i] * trail_segment_movement_spd[i] * trail_movement_spd * frame_delta;
	
	trail_segment_position_x[i] += trail_wind_direction_h * trail_wind_spd * frame_delta;
	trail_segment_position_y[i] += trail_wind_direction_v * trail_wind_spd * frame_delta;
	
	trail_segment_bezier_weight_h[i] += trail_segment_bezier_spd_h[i] * trail_weight_spd * frame_delta;
	trail_segment_bezier_weight_v[i] += trail_segment_bezier_spd_v[i] * trail_weight_spd * frame_delta;
	
	trail_segment_thickness[i] -= trail_segment_thickness_decay[i] * trail_thickness_decay_spd * frame_delta;
	trail_segment_thickness[i] = max(trail_segment_thickness[i], 0);
}

// Smoke Trail Weight & Thickness Mult Decay
trail_weight_spd *= power(trail_weight_mult, frame_delta);

trail_thickness_decay_spd *= power(trail_thickness_decay_mult, frame_delta);

// Smoke Trail Color & Alpha Calculation
trail_color += trail_color_spd * frame_delta;
trail_color = trail_color > 1 ? 1 : trail_color;

trail_alpha -= trail_alpha_decay * frame_delta;
trail_alpha = trail_alpha < 0 ? 0 : trail_alpha;

// Smoke Trail Destroy Condition
if (trail_alpha <= 0)
{
	// Destroy Smoke Trail
	instance_destroy();
}
