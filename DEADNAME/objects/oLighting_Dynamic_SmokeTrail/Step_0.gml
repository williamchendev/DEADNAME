/// @description Insert description here
// You can write your code in this editor

//
for (var i = 0; i < array_length(trail_weights); i++)
{
	trail_weights[i] += trail_weights_spd[i] * trail_weight_spd * frame_delta;
}

trail_weight_spd *= power(trail_weight_mult, frame_delta);

trail_alpha -= trail_decay * frame_delta;
trail_alpha = trail_alpha < 0 ? 0 : trail_alpha;

if (trail_alpha <= 0)
{
	//
	lighting_engine_remove_object(id);
}
